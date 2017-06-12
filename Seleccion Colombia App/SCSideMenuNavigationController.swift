//
//  SCSideMenuNavigationController.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import SideMenu

class SCSideMenuNavigationController: UISideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SideMenuManager.menuAnimationBackgroundColor = UIColor(red: 255/255, green: 200/255, blue: 27/255, alpha: 1)
        SideMenuManager.menuWidth = max(round(min((self.view.frame.width), (self.view.frame.height)) * 0.85), 240)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
