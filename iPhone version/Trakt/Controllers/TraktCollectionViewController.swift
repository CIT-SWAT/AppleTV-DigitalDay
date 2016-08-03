//
//  TraktCollectionViewController.swift
//  Trakt
//
//  Created by Gian Nucci on 05/01/16.
//  Copyright © 2016 Gian Nucci. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TraktCell"
private let reuseIdentifierForFooter = "FooterView"

private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

class TraktCollectionViewController: UICollectionViewController {

    lazy var traktService = TraktService()
    lazy var refreshControl = UIRefreshControl()
    
    var shows : [TraktShow] = []
    var currentPage = 1
    var loadMoreAvailable = true
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Shows"
        
        self.refreshControl.tintColor = UIColor(red: 1, green: 102/255.0, blue: 102/255.0, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(TraktCollectionViewController.refreseShows), forControlEvents: .ValueChanged)
        self.collectionView?.addSubview(refreshControl)
        self.collectionView!.alwaysBounceVertical = true;
        
        self.fetchShows()
    }
    
    func showForIndexPath(indexPath: NSIndexPath) -> TraktShow {
        return self.shows[indexPath.row]
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func fetchShows() {
        traktService.fetchPopularShows(currentPage) {[weak self] (response) in
            guard let _self = self else { return }
            
            do {
                guard let results = try response() else { return }
                
                _self.shows += results.showList
                _self.currentPage += 1
                
                if results.showList.count < 15 {
                    _self.loadMoreAvailable = false
                }
                
                _self.collectionView?.reloadData()
                _self.refreshControl.endRefreshing()
            } catch {
                let alertController = UIAlertController(title: "Oops!", message: "Erro inesperado.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
                _self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func refreseShows() {
        self.shows = []
        self.currentPage = 1
        
        fetchShows()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewController = segue.destinationViewController as! TraktShowViewController
        destinationViewController.show = self.shows[self.selectedIndex]
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TraktCollectionViewCell
    
        let traktShow = showForIndexPath(indexPath)
        
        cell.imageView.sd_setImageWithURL(NSURL(string: traktShow.showThumbnailURL), completed: { (image, error, imageCacheType, url) -> Void in
            cell.activityIndicator.stopAnimating()
        })
        
        cell.titleLabel.text = traktShow.showName
        
        return cell
    }
    
    // MARK: IBAction
    @IBAction func loadMore(sender: UIButton) {
        self.fetchShows()
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier("PresentDetail", sender: self)
    }
}

extension TraktCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: 100, height: 180)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView .dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifierForFooter, forIndexPath: indexPath)
        return reusableView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.loadMoreAvailable {
            return CGSizeMake(self.view.frame.size.width, 60)
        } else {
            return CGSizeZero
        }
    }
}
