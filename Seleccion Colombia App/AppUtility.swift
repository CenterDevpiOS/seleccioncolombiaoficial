//
//  AppUtility.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/12/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import Foundation

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
    static func isBSC() -> Bool{
        let targetName = Bundle.main.infoDictionary?["TargetName"] as? String
        
        if let _ = targetName, targetName == "BarcelonaSC"{
            return true
        }else{
            return false
        }
    }
}
