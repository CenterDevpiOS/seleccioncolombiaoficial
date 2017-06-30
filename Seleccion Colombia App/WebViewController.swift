//
//  WebViewController.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var banner: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var bscLogo: UIImageView!
    
    var url: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if AppUtility.isBSC() {
            prepareUI()
        }
        AppUtility.lockOrientation(.all)
        // Do any additional setup after loading the view.
        
         NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIDeviceOrientationDidChange, object: nil)
        
        let url = URL(string: self.url)
        
        let request = URLRequest(url: url!)
        
        webView.loadRequest(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    private func prepareUI(){
        banner.isHidden = false
        bscLogo.isHidden = false
        closeButton.setTitleColor(Color.yellow.color, for: .normal)
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override var prefersStatusBarHidden: Bool {
        
        return false
    }
    
    func videoDidRotate() {
        
        UIApplication.shared.isStatusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }

}
