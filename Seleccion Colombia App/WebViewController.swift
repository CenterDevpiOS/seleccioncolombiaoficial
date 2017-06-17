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
    
    var url: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

    override var prefersStatusBarHidden: Bool {
        
        return false
    }
    
    func videoDidRotate() {
        
        UIApplication.shared.isStatusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }

}
