//
//  ViewController.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/10/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire

class NewsViewController: UIViewController{

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var tableNews: UITableView!
    @IBOutlet weak var backToTopButton: UIButton!
    
    var refreshControl: UIRefreshControl!
    
    var selectedNews : News?
    
    var newsFromTable = [News](){
    
        didSet{
                    }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerImageView.isHidden = true
        
        navigationController?.navigationBar.isHidden = true
        
        setRefreshControl()
        askForNews()
        
        setBackToTopButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadImageBanner()
        
        AppUtility.lockOrientation(.portrait)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "newsDetail" {
            
            let vc = segue.destination as! DetailNewsViewController
            vc.selectedNews = selectedNews
            
            
        } else if segue.identifier == "showWebView"{
            let vc = segue.destination as! WebViewController
            
            vc.url = sender as! String
        }
    }
    

    @IBAction func viewDetailView(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableNews)
        let indexPath = self.tableNews.indexPathForRow(at: buttonPosition)
        
        let newsAtIndexPath = newsFromTable[(indexPath?.row)!]
        selectedNews = newsAtIndexPath
        
        switch selectedNews!.type! {
        case .isNoticiaInfo:
            self.performSegue(withIdentifier: "newsDetail", sender: nil)
        case .isInfograf:
            self.performSegue(withIdentifier: "showWebView", sender: selectedNews?.link)
            break
        case .isVideoNew:
            self.performSegue(withIdentifier: "showWebView", sender: selectedNews?.link)
            break
        case .noType:
            break
        }
        
    }
    
    func setBackToTopButton () {
        
        self.backToTopButton.layer.cornerRadius = backToTopButton.bounds.width / 2
        self.backToTopButton.clipsToBounds = true
        backToTopButton.addTarget(self, action: #selector(backToTopAction), for: .touchUpInside)
    }
    
    func backToTopAction()  {
        self.tableNews.scrollsToTop = true
        tableNews.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func setRefreshControl () {
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(askForNews), for: UIControlEvents.valueChanged)
        tableNews.addSubview(refreshControl)
    }
    
    func loadImageBanner() {
        Alamofire.request("http://fcf.2waysports.com/2waysports/Colombia/Noticias/banner.png").validate().responseData { (data) in
            
            switch data.result {
            case .success:
                
                if let data2 = data.data {
                    
                    let image = UIImage(data: data2)
                    
                    self.bannerImageView.isHidden = false
                    self.bannerImageView.image = image
                    
                    UIView.animate(withDuration: 0.6, animations: { 
                        self.backToTopButton.frame = CGRect(x: self.view.bounds.width - 62, y: self.view.bounds.height - 141 - 56, width: 56, height: 56)
                    })
                    
                    
                }
                
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
    
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension NewsViewController {

    
    func askForNews(){
    
        NetworkManagement.requestNews(with: 1, completionHandler: {(newsFromNetwork, error) in
            guard error == nil else {
                print("-----ERROR en Endpoint -----")
                print(error.debugDescription)
                return self.displayAlert("Disculpe tenemos problemas con el servicio, intente nuevamente", completionHandler: {})
            }
            guard let news = newsFromNetwork else {
                return
            }
            
            self.newsFromTable.removeAll()
            self.newsFromTable = news
            self.refreshControl.endRefreshing()
            self.tableNews.reloadData()

        })
        
    }
}

extension NewsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let newsAtIndexPath = newsFromTable[indexPath.row]
        selectedNews = newsAtIndexPath
        
        switch selectedNews!.type! {
            case .isNoticiaInfo:
                self.performSegue(withIdentifier: "newsDetail", sender: nil)
            case .isInfograf:
                self.performSegue(withIdentifier: "showWebView", sender: selectedNews?.link)
                break
            case .isVideoNew:
                self.performSegue(withIdentifier: "showWebView", sender: selectedNews?.link)
            break
            case .noType:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 229
    }
}

extension NewsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFromTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let newsCell = tableView.dequeueReusableCell(withIdentifier: "news") as? NewsTableViewCell else {
           return UITableViewCell()
        }
        
        let newsAtIndexPath = newsFromTable[indexPath.row]
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        newsCell.dataLabel.text = dateFormatter.string(from: newsAtIndexPath.date)
        newsCell.titleLable.text = newsAtIndexPath.tittle
        newsCell.newsImage.image = newsAtIndexPath.image
        newsCell.newsImage.contentMode = .scaleAspectFill
       
        
        DispatchQueue.global().async {
        
            if newsAtIndexPath.image == nil {
                
                if let imageNews = newsAtIndexPath.linkImage, let url = URL(string: imageNews) {
                    guard let dataImage = try? Data(contentsOf: url) else {
                        return
                    }
                    DispatchQueue.main.async {
                        
                        self.newsFromTable[indexPath.row].image = UIImage(data: dataImage)
                        
                        self.tableNews.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
                    }
                }
            }
        }
        
        return newsCell
    }

}


public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
