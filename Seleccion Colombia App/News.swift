//
//  News.swift
//  Seleccion Colombia App
//
//  Created by Daniel Torres on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

struct News {

    enum NewsType : Int{
        case noType = 0, isVideoNew, isInfograf, isNoticiaInfo
    }
    
    
    var date: Date
    var link : String?
    var tittle : String
    var description: String?
    var type : NewsType?
    var image : UIImage?
    var linkImage: String?
    
    init(){
        date = Date()
        link = ""
        tittle = ""
        description = ""
        type = NewsType.isNoticiaInfo
        image = nil
    }
    
    
    init(dictionary: [String:AnyObject]){
        
        self.init()
        
        if let dateNew = dictionary[ConstantsNews.JSONBodyResponseParseKeys.dateNew] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d/MM/yy"
            
            if let date = formatter.date(from: dateNew) {
                self.date = date
            }
            
        }
        
        if let link = dictionary[ConstantsNews.JSONBodyResponseParseKeys.linkNew] as? String {
            self.link = link
        }
        
        if let tittle = dictionary[ConstantsNews.JSONBodyResponseParseKeys.tittleNew] as? String {
            self.tittle = tittle
        }
        
        if let description = dictionary[ConstantsNews.JSONBodyResponseParseKeys.descNew] as? String {
            self.description = description
        }
        
        if let image = dictionary[ConstantsNews.JSONBodyResponseParseKeys.img] as? String {
            self.linkImage = image
        }
        
        if let isInfo = dictionary[ConstantsNews.JSONBodyResponseParseKeys.isInfograf] as? String, isInfo == "1" {
            self.type = NewsType.isInfograf
        }
        
        if let isVideo = dictionary[ConstantsNews.JSONBodyResponseParseKeys.isVideoNew] as? String, isVideo == "1" {
            self.type = NewsType.isVideoNew
        }
        
        if let isNoticia = dictionary[ConstantsNews.JSONBodyResponseParseKeys.isNoticiaInfo] as? String, isNoticia == "1" {
            self.type = NewsType.isNoticiaInfo
        }
        
    }
    
    
    static func arrayOfNews(from dictionary: [[String:AnyObject]]) -> [News]{
        var newsToReturn = [News]()
        
        for new in dictionary{
            newsToReturn.append(News(dictionary: new))
        }
        
        return newsToReturn
    }

}
