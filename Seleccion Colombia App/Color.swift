//
//  Color.swift
//  Seleccion Colombia App
//
//  Created by Graciela Lucena on 6/27/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import HexColors

enum Color: String {
    
    case yellow = "FFCA0E"
    case black = "000000"

    var color : UIColor{
        return UIColor(self.rawValue)!
    }
}
