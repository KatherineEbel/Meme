//
//  SentMemesCollectionViewController.swift
//  Meme
//
//  Created by Katherine Ebel on 11/18/15.
//  Copyright © 2015 Katherine Ebel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
  
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  var memes: [Meme] {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
  }

    override func viewDidLoad() {
      super.viewDidLoad()
      let space: CGFloat = 3.0
      let width = (self.view.frame.width - (2 * space)) / 3
      let height = (self.view.frame.height - (2 * space)) / 3
      flowLayout.minimumInteritemSpacing = space
      flowLayout.minimumLineSpacing = space
      flowLayout.itemSize = CGSizeMake(width, height)
      collectionView?.reloadData()
    }


    // MARK: UICollectionViewDataSource


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemeCollectionViewCell
    
        // Configure the cell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
