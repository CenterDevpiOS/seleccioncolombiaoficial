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
         
            print("result from request")
            
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
    
    
}


enum Router: URLRequestConvertible {
    case searchNews(page: Int)
    
    static let baseURLString = "http://fcf.2waysports.com"
    static let perPage = 50
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .searchNews(page) where page >= 0:
                return (ConstantsNews.Methods.searchNews, [ConstantsNews.UrlKeys.page : page])
            default :
                return (ConstantsNews.Methods.searchNews, [ConstantsNews.UrlKeys.page : 1])
            }
        }()
        
        let url = try Router.baseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
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
