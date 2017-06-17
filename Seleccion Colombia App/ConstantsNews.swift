//
//  NewsConstants.swift
//  Seleccion Colombia App
//
//  Created by Daniel Torres on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import Foundation
import UIKit

struct ConstantsNews {
    
    // MARK: Constants
    struct ParseConstants {
        
        // MARK: URLs
        static let apiScheme = "http"
        static let apiHost = "fcf.2waysports.com"
        
        
    }
    
    // MARK: Methods
    struct Methods {
        
        static let searchNews = "/2waysports/Colombia/Noticias/noticias_new.php"
    }
    
    struct UrlKeys {
        static let page = "pag"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyParseKeys {
        
    }
    
    // MARK: JSON Body Response Keys
    struct JSONBodyResponseParseKeys {
        //data
        static let data = "data"
        
        //News
        static let idNew = "idNew"
        static let linkNew = "linkNew"
        static let tittleNew = "tittleNew"
        static let descNew = "descNew"
        static let dateNew = "dateNew"
        static let isVideoNew = "isVideoNew"
        static let playerNew = "playerNew"
        static let impot = "impot"
        static let isInfograf = "isInfograf"
        static let img = "img"
        static let heigthInfo = "heigthInfo"
        static let isNoticiaInfo = "isNoticiaInfo"
        static let panel = "panel"
        
        
    }
}
