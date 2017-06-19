//
//  SCMenuViewController.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

class SCMenuViewController: UIViewController {

    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var newsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true

        if DeviceType.IS_IPHONE_6P {
            
            newsButton.frame = CGRect(x: 0, y: 260, width: 415, height: 62)
            
        } else if DeviceType.IS_IPHONE_6 {
            
            print("this is happening")
            newsButton.frame = CGRect(x: 0, y: 233, width: 375, height: 60)
        } else if DeviceType.IS_IPHONE_5 {
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
    @IBAction func closeMenuWithButton(_ sender: Any) {
        
        closeMenu()
    }
    
    func closeMenu() {
        dismiss(animated: true, completion: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
  
    
}
