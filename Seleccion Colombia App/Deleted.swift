//
//  Deleted.swift
//  Seleccion Colombia App
//
//  Created by Graciela Lucena on 6/29/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

struct Deleted {
    
    enum NewsType : Int{
        case noType = 0, isVideoNew, isInfograf, isNoticiaInfo
    }
    
    
    var idNew: String
    
    init(){
        idNew = ""
    }
    
    
    init(dictionary: [String:AnyObject]){
        
        self.init()
        
        if let id = dictionary[ConstantsNews.JSONBodyResponseParseKeys.idNew] as? String {
            self.idNew = id
        }
        
        
    }
    
    
    static func arrayOfDeletedNews(from dictionary: [[String:AnyObject]]) -> [Deleted]{
        var newsDeletedToReturn = [Deleted]()
        
        for new in dictionary{
            newsDeletedToReturn.append(Deleted(dictionary: new))
        }
        
        return newsDeletedToReturn
    }
    
}
