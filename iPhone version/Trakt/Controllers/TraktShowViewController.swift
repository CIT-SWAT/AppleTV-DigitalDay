//
//  TraktShowViewController.swift
//  Trakt
//
//  Created by Gian Nucci on 05/01/16.
//  Copyright © 2016 Gian Nucci. All rights reserved.
//

import UIKit

class TraktShowViewController: UIViewController {

    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var show : TraktShow!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.bannerView.sd_setImageWithURL(NSURL(string: self.show.showLargeImageURL), completed: { (_, _, _, _) -> Void in
            self.activityIndicator.stopAnimating()
        })
        
        self.title = self.show.showName
        self.titleLabel.text = self.show.showName
        self.yearLabel.text = String(self.show.showYear)
        self.ratingLabel.text = String(format: "%.1f%%", arguments: [self.show.showRating])
        self.overview.text = self.show.showOverview
    }
}
