//
//  NetworkManagement.swift
//  Seleccion Colombia App
//
//  Created by Daniel Torres on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import Alamofire

struct NetworkManagement {
    
    
    static func requestNews(with page: Int, completionHandler: @escaping (_ result: [News]?, _ error:
        Error?) -> Void){
        
        
        let network = NetworkManagement()
        Alamofire.request(Router.searchNews(page: page)).response { (response) in
            
            
            guard response.error == nil else {
                return completionHandler(nil, response.error!)
            }
            
            network.convertDataWithCompletionHandler(response.data!, completionHandlerForConvertData: { (responseJson, error) in
                
                guard let dic = responseJson as? [String:AnyObject] else {
                    return
                }
                
                guard let newsDict = dic[ConstantsNews.JSONBodyResponseParseKeys.data] as? [[String:AnyObject]] else {
                    return
                }
                
                let arrayOfNews = News.arrayOfNews(from: newsDict)
                
                
                completionHandler(arrayOfNews,nil)
                
            })
        }
        
    }
    
    
    static func requestBSCNews(with page: Int, primerid: Int?, ultimoid: Int?, completionHandler: @escaping (_ result: [News]?, _ deleted: [Deleted]?, _ error:
        Error?) -> Void){
        
        
        let network = NetworkManagement()
        Alamofire.request(Router.searchBSCNews(page: page, primerid: primerid, ultimoid: ultimoid)).response { (response) in
            
            
            guard response.error == nil else {
                return completionHandler(nil,nil, response.error!)
            }
            
            network.convertDataWithCompletionHandler(response.data!, completionHandlerForConvertData: { (responseJson, error) in
                
                guard let dic = responseJson as? [String:AnyObject] else {
                    return
                }
                
                guard let newsDict = dic[ConstantsNews.JSONBodyResponseParseKeys.data] as? [[String:AnyObject]] else {
                    return
                }
                
                guard let deletedDict = dic[ConstantsNews.JSONBodyResponseParseKeys.eliminadas] as? [[String:AnyObject]] else {
                    return
                }
                
                let arrayOfNews = News.arrayOfNews(from: newsDict)
                let arrayOfDeletedNews = Deleted.arrayOfDeletedNews(from: deletedDict)

                
                completionHandler(arrayOfNews,arrayOfDeletedNews,nil)
                
            })
        }
        
    }
}


enum Router: URLRequestConvertible {
    
    case searchNews(page: Int)
    case searchBSCNews(page: Int, primerid: Int?, ultimoid: Int?)

    var baseURLString: String {
        
        if AppUtility.isBSC(){
            return "http://2waysports.com"
        }else{
            return "http://fcf.2waysports.com"
        }
    }
    static let perPage = 50
    var baseURLPath: String {
        
        if AppUtility.isBSC(){
            return "/barcelona/"
        }else{
            return "/2waysports/Colombia/"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .searchNews(page) where page >= 0:
                return ("\(baseURLPath)\(ConstantsNews.Methods.searchNews)", [ConstantsNews.UrlKeys.page : page])
            case let .searchBSCNews(page, primerid, ultimoid) where page > 1:
                return ("\(baseURLPath)\(ConstantsNews.Methods.searchNews)", [ConstantsNews.UrlKeys.page : page,
                    ConstantsNews.UrlKeys.primerid : primerid ?? 0,
                    ConstantsNews.UrlKeys.ultimoid : ultimoid ?? 0])
            default :
                return ("\(baseURLPath)\(ConstantsNews.Methods.searchNews)", [ConstantsNews.UrlKeys.page : 1])
            }
        }()
        
        let url = URL(string: baseURLString)
        let urlRequest = URLRequest(url: (url?.appendingPathComponent(result.path))!)
        
        print("this is the url : \(result.parameters)")
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}

extension NetworkManagement {
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
}
