//
//  LiveViewController.swift
//  Seleccion Colombia App
//
//  Created by Graciela Lucena on 6/28/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import Foundation
import UIKit
import CoreMedia

class LiveViewController: UIViewController{

    //MARK: - @IBOutlets
    @IBOutlet var webView: UIWebView!

    //MARK: - Properties
    var url: String = ""
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppUtility.isBSC() {
            prepareUI()
        }
        AppUtility.lockOrientation(.all)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIDeviceOrientationDidChange, object: nil)
        
        let url = URL(string: self.url)
        
        let request = URLRequest(url: url!)
        
        webView.loadRequest(request)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }


    //MARK: - UI
    private func prepareUI(){

    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func videoDidRotate() {
        UIApplication.shared.isStatusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }

}
