//
//  DetailNewsViewController.swift
//  Seleccion Colombia App
//
//  Created by Daniel Torres on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNewLabel: UILabel!
    @IBOutlet weak var descriptionNew: UILabel!
    @IBOutlet var divider: UIView!
    @IBOutlet var newsLabel: UILabel!
    @IBOutlet var appOfficialLbl: UILabel!
    @IBOutlet var poweredBy: UIImageView!
    @IBOutlet var menuBttn: UIButton!
    @IBOutlet var footer: UIImageView!
    @IBOutlet var banner: UIImageView!
    
    var selectedNews : News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppUtility.isBSC(){
            prepareUI()
        }
        navigationController?.navigationBar.isHidden = true
        prepareView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI(){
        banner.isHidden = false
        divider.backgroundColor = Color.yellow.color
        newsLabel.textColor = Color.black.color
        appOfficialLbl.isHidden = true
        poweredBy.isHidden = true
        menuBttn.setTitleColor(Color.yellow.color, for: .normal)
        footer.isHidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailNewsViewController {
    
    func prepareView(){
        if let image = selectedNews?.image {
            imageNews.image = image
        }
        else {
            DispatchQueue.global().async {
                if self.selectedNews!.image == nil {
                    if let imageLinkNews = self.selectedNews!.linkImage, let url = URL(string: imageLinkNews) {
                        guard let dataImage = try? Data(contentsOf: url) else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.selectedNews!.image = UIImage(data: dataImage)
                            self.imageNews.image = self.selectedNews!.image
                        }
                    }
                }
            }
        }
        
        titleNewLabel.text = selectedNews?.tittle
        descriptionNew.text = selectedNews?.description
    
    }
}
