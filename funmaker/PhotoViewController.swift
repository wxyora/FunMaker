//
//  PhotoViewController.swift
//  funmaker
//
//  Created by Waylon on 16/9/1.
//  Copyright © 2016年 Waylon. All rights reserved.
//
import UIKit
import PhotosUI

class PhotoViewController: BaseViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //  collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    //  数据源
    var dataArray = [AnyObject]()
    

    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    
    @IBAction func clickedAction(sender: UIButton) {
        //  跳转页面
        let photosVC = BBAllPhotosViewController()
        photosVC.maxSelectedCount = 5
        
        photosVC.processSelectPhotosBlock { (photosArray, assetsArray) in
            self.dataArray = assetsArray
            self.collectionView.reloadData()
        }
        presentViewController(photosVC, animated: true, completion: nil)
    
    }
    
    
    //  代理方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        PHCachingImageManager.defaultManager().requestImageForAsset(dataArray[indexPath.row] as! PHAsset, targetSize: CGSizeMake(view.bounds.width, view.bounds.height), contentMode: .AspectFit, options: nil) { (result: UIImage?, dic: Dictionary?) in
            let imageview = UIImageView(frame: cell.contentView.bounds)
            cell.contentView.addSubview(imageview)
            imageview.contentMode = .ScaleAspectFill
            imageview.image = result ?? UIImage.init(named: "iw_none")
        }
        
        return cell
    }
}

