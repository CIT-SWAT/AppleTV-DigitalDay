//
//  TraktService.swift
//  Trakt
//
//  Created by Gian Nucci on 05/01/16.
//  Copyright © 2016 Gian Nucci. All rights reserved.
//

import UIKit
import Alamofire

private let traktApiKey = "c7079537354ba664cc7e651d92b346693c843a772f6000ba57e4793e16a30bd9"
private let baseURL = "https://api-v2launch.trakt.tv"

struct TraktResults {
    let showList : [TraktShow]
}

typealias TraktServiceCompletion = (() throws -> TraktResults?) -> Void

struct TraktService {
    let processingQueue = NSOperationQueue()
    
    private func traktPopularShowURL() -> NSURL {
        
        let URLString = "\(baseURL)/shows/popular"
        return NSURL(string: URLString)!
    }
    
    func fetchPopularShows(page: Int, completion: TraktServiceCompletion){
        
        let getURL = traktPopularShowURL()
        
        let parameters = [
            "extended":"full,images",
            "page":page,
            "limit":15
        ]
        
        let headers = [
            "Content-Type":"application/json",
            "trakt-api-version":"2",
            "trakt-api-key":traktApiKey,
            ]
        
        Alamofire.request(.GET, getURL, parameters: parameters as? [String : AnyObject], encoding:.URL, headers: headers)
            .responseJSON { (response) -> Void in
                
            if let _response = response.response {
                switch (_response.statusCode) {
                case 200, 201, 204:
                    print("Results processed OK")
                    break
                case 404:
                    print("OK but no records found")
                    break
                case 400, 401, 403, 405, 409, 412, 422, 429:
                    completion{ throw GenericError.Unexpected }
                default:
                    completion { throw GenericError.Server }
                }
                
                if (response.result.isSuccess) {
                    let shows = response.result.value as! NSArray;
                    let traktShows : [TraktShow] = shows.map {
                        showDictionary in
                        
                        let showID = showDictionary["ids"]!!["trakt"] as? String ?? ""
                        let showYear = showDictionary["year"] as? Int ?? 0
                        let showName = showDictionary["title"] as? String ?? ""
                        let showOverview = showDictionary["overview"] as? String ?? ""
                        let showRating = showDictionary["rating"] as? Float ?? 0.0
                        let showThumbURL = showDictionary["images"]!!["poster"]!!["thumb"] as? String ?? ""
                        let showLargeImageURL = showDictionary["images"]!!["fanart"]!!["full"] as? String ?? ""
                        
                        let traktShow = TraktShow(
                            showID: showID,
                            showName: showName,
                            showYear: showYear,
                            showThumbnailURL: showThumbURL,
                            showLargeImageURL: showLargeImageURL,
                            showOverview: showOverview,
                            showRating: showRating
                        )
                        
                        return traktShow
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion{ TraktResults(showList: traktShows) }
                    })
                }
            } else {
                completion{ throw GenericError.Connection }
            }
        }
    }
}
