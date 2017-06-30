//
//  SCMenuViewController.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import SideMenu
import MediaPlayer

class SCMenuViewController: UIViewController {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var leadingConstraintStreaming: NSLayoutConstraint!
    @IBOutlet var topConstraintStreaming: NSLayoutConstraint!
    @IBOutlet var newsBttnBSC: UIButton!
    @IBOutlet var liveBttnBSC: UIButton!
    
    var moviePlayer : AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppUtility.isBSC(){
            prepareUI()
        }
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        if DeviceType.IS_IPHONE_6P {
            topConstraint.constant = 242
            newsButton.frame = CGRect(x: 0, y: 260, width: 415, height: 62)
            
        } else if DeviceType.IS_IPHONE_6 {
            print("this is happening")
            topConstraint.constant = 220
            newsButton.frame = CGRect(x: 0, y: 233, width: 375, height: 60)
        } else if DeviceType.IS_IPHONE_5 {
            topConstraintStreaming.constant = 35.5
            leadingConstraintStreaming.constant = 35
            topConstraint.constant = 187
            newsButton.frame = CGRect(x: 0, y: 200, width: 320, height: 48)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        AppUtility.lockOrientation(.portrait)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI(){
        newsBttnBSC.isUserInteractionEnabled = true
        liveBttnBSC.isUserInteractionEnabled = true
        newsButton.isUserInteractionEnabled = false
    }
    
    @IBAction func closeMenuWithButton(_ sender: Any) {
        closeMenu()
    }
    
    func closeMenu() {
        dismiss(animated: true, completion: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: -
    @IBAction func showNews(_ sender: UIButton) {
        print("showNews")
    }
    
    @IBAction func liveBSC(_ sender: UIButton) {
        print("goLive")
        self.performSegue(withIdentifier: "goLive", sender: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goLive"{
            let vc = segue.destination as! LiveViewController
            let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
            
            vc.url = urlString
        }
    }
    
}
