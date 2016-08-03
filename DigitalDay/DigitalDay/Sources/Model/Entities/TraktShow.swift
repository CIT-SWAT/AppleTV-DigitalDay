//
//  TraktShow.swift
//  Trakt
//
//  Created by Gian Nucci on 05/01/16.
//  Copyright © 2016 Gian Nucci. All rights reserved.
//

import UIKit

struct TraktShow {
    let showID: String
    let showName: String
    let showYear: Int
    let showOverview: String
    let showRating: Float
    let showThumbnailURL: String
    let showLargeImageURL: String
    
    init (showID: String, showName: String, showYear: Int, showThumbnailURL: String, showLargeImageURL:String, showOverview: String, showRating: Float) {
        self.showID = showID
        self.showName = showName
        self.showYear = showYear
        self.showOverview = showOverview
        self.showRating = showRating
        self.showThumbnailURL = showThumbnailURL
        self.showLargeImageURL = showLargeImageURL
    }
}
