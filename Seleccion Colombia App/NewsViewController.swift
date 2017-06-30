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
import MBProgressHUD
import MediaPlayer
import SideMenu

class NewsViewController: UIViewController{

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var tableNews: UITableView!
    @IBOutlet weak var backToTopButton: UIButton!
    @IBOutlet var divider: UIView!
    @IBOutlet var homeLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var appOfficialLbl: UILabel!
    @IBOutlet var poweredBy: UIImageView!
    @IBOutlet var footer1: UIImageView!
    @IBOutlet var footer2: UIImageView!
    @IBOutlet var topButton: UIButton!
    @IBOutlet var banner: UIImageView!
    
    var refreshControl: UIRefreshControl!
    var gettingNews = false

    var selectedNews : News?
    
    var moviePlayer : AVPlayer!

    var newsFromTable: [News] = [] {
        didSet {
            
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = false

        if AppUtility.isBSC(){
            prepareUI()
        }
        bannerImageView.isHidden = true
        navigationController?.navigationBar.isHidden = true
        setRefreshControl()
        
        if AppUtility.isBSC(){
            askForBSCNews(pageCount: UserDefaults.standard.integer(forKey: "pageCount"), primerid: UserDefaults.standard.integer(forKey: "primerId"), ultimoid: UserDefaults.standard.integer(forKey: "ultimoId"))
        }else{
            askForNews(pageCount: UserDefaults.standard.integer(forKey: "pageCount"))
        }
        setBackToTopButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadImageBanner()
        AppUtility.lockOrientation(.portrait)
    }

    //MARK: - UI
    private func prepareUI(){
        banner.isHidden = false
        divider.backgroundColor = Color.yellow.color
        homeLabel.textColor = Color.black.color
        appOfficialLbl.isHidden = true
        poweredBy.isHidden = true
        menuButton.setTitleColor(Color.yellow.color, for: .normal)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "newsDetail" {
            
            let vc = segue.destination as! DetailNewsViewController
            vc.selectedNews = selectedNews
            
            
        } else if segue.identifier == "showWebView"{
            let vc = segue.destination as! WebViewController
            
            vc.url = sender as! String
        }
    }
    
    //MARK: - @IBActions
    @IBAction func menu(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewDetailView(_ sender: UIButton) {
    }
    
    //MARK: - Helpers
    func setBackToTopButton () {
        
        self.backToTopButton.layer.cornerRadius = backToTopButton.bounds.width / 2
        self.backToTopButton.clipsToBounds = true
        backToTopButton.addTarget(self, action: #selector(backToTopAction), for: .touchUpInside)
    }
    
    func backToTopAction()  {
        self.tableNews.scrollsToTop = true
        let indexPath = IndexPath(row: 0, section: 0)
        tableNews.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    func setRefreshControl () {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: UIControlEvents.valueChanged)
        tableNews.addSubview(refreshControl)
    }
    
    func refreshAction () {
        UserDefaults.standard.set(1, forKey: "pageCount")
        let pageCount = UserDefaults.standard.integer(forKey: "pageCount")
        let primerId = UserDefaults.standard.integer(forKey: "primerId")
        let ultimoId = UserDefaults.standard.integer(forKey: "ultimoId")

        if AppUtility.isBSC(){
            askForBSCNews(pageCount: pageCount, primerid: primerId, ultimoid: ultimoId)
        }else{
            askForNews(pageCount: pageCount)
        }
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

    
    func askForNews(pageCount: Int){
    
        NetworkManagement.requestNews(with: pageCount, completionHandler: {(newsFromNetwork, error) in
            
            guard error == nil else {
                print("-----ERROR en Endpoint -----")
                print(error.debugDescription)
                return self.displayAlert("Disculpe tenemos problemas con el servicio, intente nuevamente", completionHandler: {})
            }
            guard let news = newsFromNetwork else {
                return
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.gettingNews = false
            UserDefaults.standard.set(pageCount, forKey: "pageCount")
            
            self.newsFromTable += news
            print("NEWS: %@", self.newsFromTable.count)
            self.refreshControl.endRefreshing()
            self.tableNews.reloadData()
        })
    }
    
    func askForBSCNews(pageCount: Int, primerid: Int?, ultimoid: Int?){
        
        NetworkManagement.requestBSCNews(with: pageCount, primerid: primerid, ultimoid: ultimoid, completionHandler: {(newsFromNetwork, deletedNewsFromNetwork, error) in
            
            guard error == nil else {
                print("-----ERROR en Endpoint -----")
                print(error.debugDescription)
                return self.displayAlert("Disculpe tenemos problemas con el servicio, intente nuevamente", completionHandler: {})
            }
            guard let news = newsFromNetwork else {
                return
            }
            
            guard let deletedNews = deletedNewsFromNetwork else {
                return
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.gettingNews = false
            UserDefaults.standard.set(pageCount, forKey: "pageCount")

            self.newsFromTable += news
            
            guard let primerId = Int((news.first?.idNew)!) else {
                return
            }
            
            guard let ultimoId = Int((news.last?.idNew)!) else {
                return
            }

            UserDefaults.standard.set(primerId, forKey: "primerId")
            UserDefaults.standard.set(ultimoId, forKey: "ultimoId")

            for deletedNew in deletedNews{
                for new in self.newsFromTable{
                    if deletedNew.idNew == new.idNew{
                        if let index = self.newsFromTable.index(where: { $0.idNew == new.idNew }){
                            self.newsFromTable.remove(at: index)
                        }
                    }
                }
            }
            
            print("NEWS: %@", self.newsFromTable.count)
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

//MARK: - NewsTableViewCellDelegate
extension NewsViewController: NewsTableViewCellDelegate {

    func seeMorePressed(newsCell: NewsTableViewCell) {
        
        guard let indexPath = tableNews.indexPath(for: newsCell) else {
            print("Unable to get index path for cell in \(#file)")
            return
        }
        
        tableView(tableNews, didSelectRowAt: indexPath)
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
        newsCell.delegate = self
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
                        
                        self.tableNews.reloadRows(at: [indexPath as IndexPath], with: .none)
                    }
                }
            }
        }
        
        if indexPath.row == self.newsFromTable.count - 1 {
            
            if !gettingNews {
                
                self.gettingNews = true
                
                let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
                
                loading.label.text = "Cargando..."
                loading.mode = .indeterminate
                
                let pageCount = UserDefaults.standard.integer(forKey: "pageCount") + 1
                let primerId = UserDefaults.standard.integer(forKey: "primerId")
                let ultimoId = UserDefaults.standard.integer(forKey: "ultimoId")

                if AppUtility.isBSC(){
                    askForBSCNews(pageCount: pageCount, primerid: primerId, ultimoid: ultimoId)
                }else{
                    self.askForNews(pageCount: pageCount)
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
