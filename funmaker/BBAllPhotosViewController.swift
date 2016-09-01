//
//  BBAllPhotosViewController.swift
//  PickerSystemPhotos
//
//  Created by goWhere on 16/5/6.
//  Copyright © 2016年 iwhere. All rights reserved.
//

import UIKit
import Photos

class BBAllPhotosViewController: UIViewController, PHPhotoLibraryChangeObserver, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //  屏幕宽高
    private var KSCREEN_HEIGHT =  UIScreen.mainScreen().bounds.size.height
    private var KSCREEN_WIDTH =  UIScreen.mainScreen().bounds.size.width
    
    //  头视图，显示标题和取消按钮
    private let headerView = UIView()
    //  默认头视图高度
    private var defaultHeight: CGFloat = 50
    
    //  底部视图，UIButton，点击完成
    private let completedButton = UIButton()
    //  已选择图片数量
    private let countLable = UILabel()
    
    //  载体
    private var myCollectionView: UICollectionView!
    //  collectionView 布局
    private let flowLayout = UICollectionViewFlowLayout()
    //  collectionviewcell 复用标识
    private let cellIdentifier = "myCell"
    //  数据源
    private var photosArray = PHFetchResult()
    //  已选图片数组，数据类型是 PHAsset
    private var seletedPhotosArray = [PHAsset]()
    
    //  一个包含0和1的数字数组，正确显示图片是否被选择
    private var isSelectedArray = [NSNumber]()
    
    //  弹框提醒
    private var alertController: UIAlertController!
    
    
    //  定义一个闭包
    typealias myBlock = (photosArray: Array<UIImage>, assetsArray: Array<PHAsset>) -> Void
    var selectedPhotosBlock: myBlock!
    
    /*****************  闭包回调  ****************/
    func processSelectPhotosBlock(callback: myBlock)  {
        selectedPhotosBlock = callback
    }

    
    /*****************  图片选择数量，唯一需要外部传入的值，默认为1  ****************/
    internal var maxSelectedCount = 1
    
    
    //  MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        //  判断选取图片数量书否合理
        maxSelectedCount < 1 ? (maxSelectedCount = 1) : (maxSelectedCount = maxSelectedCount)
        maxSelectedCount > 9 ? (maxSelectedCount = 9) : (maxSelectedCount = maxSelectedCount)
        
        //  添加collectionView，区分横竖屏
        if KSCREEN_WIDTH > KSCREEN_HEIGHT {
            defaultHeight = 44
            createCollectionView(everyLineNumberOfPhoto: 7)
        } else {
            defaultHeight = 50
            createCollectionView(everyLineNumberOfPhoto: 4)
        }
        
        //  添加顶部、底部视图
        addHeadViewAndBottomView()

        //  获取全部图片
        getAllPhotos()
        
        //  初始化 Alert
        initAlert()
    }
    
    //  MARK:- 添加headerView-标题、取消 , 添加底部视图，包括完成按钮和选择数量
    private func addHeadViewAndBottomView() {
        //  headerView
        headerView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, defaultHeight)
        headerView.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        view.addSubview(headerView)
        
        //  添加返回按钮
        let backButton = UIButton()
        backButton.frame = CGRectMake(0, 0, 60, 30)
        backButton.setTitle("取消", forState: .Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.center = CGPointMake(KSCREEN_WIDTH - 40, defaultHeight / 1.5)
        backButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        //  注意这里给按钮添加点击方法的写法
        backButton.addTarget(self, action:#selector(BBAllPhotosViewController.dismissAction),
                             forControlEvents: .TouchUpInside)
        headerView.addSubview(backButton)
        
        //  标题
        let titleLable = UILabel(frame: CGRectMake(0, 0, KSCREEN_WIDTH / 2, defaultHeight))
        titleLable.text = "全部图片"
        titleLable.textColor = UIColor.whiteColor()
        titleLable.font = UIFont.systemFontOfSize(19)
        titleLable.textAlignment = .Center
        titleLable.center = CGPointMake(KSCREEN_WIDTH / 2, defaultHeight / 1.5)
        headerView.addSubview(titleLable)
        
        //  底部View，点击选择完成
        completedButton.frame = CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH, 44)
        completedButton.addTarget(self, action: #selector(self.completedButtonClicked),
                                  forControlEvents: .TouchUpInside)
        completedButton.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
        view.addSubview(completedButton)
        
        //  完成按钮
        let overLabel = UILabel(frame: CGRectMake(KSCREEN_WIDTH / 2 + 10, 0, 40, 44))
        overLabel.text = "完成"
        overLabel.textColor = UIColor.greenColor()
        overLabel.font = UIFont.systemFontOfSize(18)
        completedButton .addSubview(overLabel)
        
        //  已选择图片数量
        countLable.frame = CGRectMake(KSCREEN_WIDTH / 2 - 25, 10, 24, 24)
        countLable.backgroundColor = UIColor.greenColor()
        countLable.textColor = UIColor.whiteColor()
        countLable.layer.masksToBounds = true
        countLable.layer.cornerRadius = countLable.bounds.size.height / 2
        countLable.textAlignment = .Center
        countLable.font = UIFont.systemFontOfSize(16)
        completedButton .addSubview(countLable)
    }
    
    //  取消选择，返回上一页
    func dismissAction() {
        self .dismissViewControllerAnimated(true, completion: nil)
    }
    
    //  MARK:- 屏幕旋转
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //  先移除
        while headerView.subviews.count > 0 {
            headerView.subviews[0].removeFromSuperview()
        }
        headerView.removeFromSuperview()
        while completedButton.subviews.count > 0 {
            completedButton.subviews[0].removeFromSuperview()
        }
        completedButton.removeFromSuperview()
        myCollectionView.removeFromSuperview()
        
        //  更改宽高数值
        if toInterfaceOrientation.isPortrait {
            defaultHeight = 50
            KSCREEN_HEIGHT =  UIScreen.mainScreen().bounds.size.height
            KSCREEN_WIDTH =  UIScreen.mainScreen().bounds.size.width
            
            //  添加collectionView
            createCollectionView(everyLineNumberOfPhoto: 4)
            
        } else {
            defaultHeight = 44
            KSCREEN_HEIGHT =  UIScreen.mainScreen().bounds.size.height
            KSCREEN_WIDTH =  UIScreen.mainScreen().bounds.size.width
            
            //  添加collectionView
            createCollectionView(everyLineNumberOfPhoto: 7)
        }
        
        //  添加headView
        addHeadViewAndBottomView()
    }
    
    //  MARK:- 获取全部图片
    private func getAllPhotos() {
        //  注意点！！-这里必须注册通知，不然第一次运行程序时获取不到图片，以后运行会正常显示。体验方式：每次运行项目时修改一下 Bundle Identifier，就可以看到效果。
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        //  获取所有系统图片信息集合体
        let allOptions = PHFetchOptions()
        //  对内部元素排序，按照时间由远到近排序
        allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        //  将元素集合拆解开，此时 allResults 内部是一个个的PHAsset单元
        let allResults = PHAsset.fetchAssetsWithOptions(allOptions)
        
        //  默认图片都是没有被选择的
        for _ in 0 ..< allResults.count {
            isSelectedArray.append(0)
        }
        
        //  将数据赋值给数据源
        photosArray = allResults
        myCollectionView.reloadData()
    }
    //  PHPhotoLibraryChangeObserver  第一次获取相册信息，这个方法只会进入一次
    func photoLibraryDidChange(changeInstance: PHChange) {
        getAllPhotos()
    }
    
    //  MARK:- 创建 CollectionView，传入每行的图片个数 并实现协议方法 delegate / dataSource
    private func createCollectionView(everyLineNumberOfPhoto number: Int) {
       
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 3
        let cellWidth: CGFloat = (KSCREEN_WIDTH - (CGFloat(number) + 1) * shape) / CGFloat(number)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, shape, 0, shape)
        flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        
        //  collectionView
        myCollectionView = UICollectionView(frame: CGRectMake(0, defaultHeight, KSCREEN_WIDTH, KSCREEN_HEIGHT - defaultHeight), collectionViewLayout: flowLayout)
        myCollectionView.backgroundColor = .whiteColor()
        //  添加协议方法
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        //  设置 cell
        myCollectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(myCollectionView)
    }
    
    //  collectionView dateSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        
        
        //  展示图片
        PHCachingImageManager.defaultManager().requestImageForAsset(photosArray[indexPath.row] as! PHAsset, targetSize: CGSizeZero, contentMode: .AspectFit, options: nil) { (result: UIImage?, dictionry: Dictionary?) in
            cell.imageView.image = result ?? UIImage.init(named: "iw_none")
        }
        
        //  判断图片是否已经被选择
        cell.isChoose = isSelectedArray[indexPath.row].boolValue
        
        return cell
    }
    
    //  collectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //  获取当前点击cell
        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! MyCollectionViewCell
        
        if seletedPhotosArray.count == maxSelectedCount && !currentCell.isChoose {
            //  此时图片已经选择完了，不能在选择了
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            currentCell.isChoose = !currentCell.isChoose
            
            if currentCell.isChoose {
                //  添加到数组
                seletedPhotosArray.append(photosArray[indexPath.row] as! PHAsset)
            } else {
                //  从数组中移除
                let idx = seletedPhotosArray.indexOf(photosArray[indexPath.row] as! PHAsset)
                seletedPhotosArray.removeAtIndex(idx!)
            }
            //  展示选择数量
            completedButtonShow()
        }
    }
    
    //  MARK:- 展示和点击完成按钮
    func completedButtonShow() {
        var originY: CGFloat
        
        if seletedPhotosArray.count > 0 {
            originY = KSCREEN_HEIGHT - 44
            flowLayout.sectionInset.bottom = 44
        } else {
            originY = KSCREEN_HEIGHT
            flowLayout.sectionInset.bottom = 0
        }
        
        UIView.animateWithDuration(0.2) {
            self.completedButton.frame.origin.y = originY
            self.countLable.text = String(self.seletedPhotosArray.count)
            
            //  仿射变换
            UIView.animateWithDuration(0.2, animations: {
                self.countLable.transform = CGAffineTransformMakeScale(0.35, 0.35)
                self.countLable.transform = CGAffineTransformScale(self.countLable.transform, 3, 3)
            })
        }
    }
    //  点击完成按钮
    func completedButtonClicked() {
        var photosArray = Array<UIImage>()
        
        //  转化图片
        for singleAsset  in seletedPhotosArray {
            PHCachingImageManager.defaultManager().requestImageForAsset(singleAsset, targetSize: CGSizeZero, contentMode: .AspectFit, options: nil, resultHandler: { (image, dictionary) in
                photosArray.append(image!)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                if (self.selectedPhotosBlock != nil && photosArray.count == self.seletedPhotosArray.count) {
                    self.selectedPhotosBlock(photosArray: photosArray, assetsArray: self.seletedPhotosArray)
                }
            })
        }
    }
    
    //  初始化alert
    func initAlert() {
        alertController = UIAlertController(title: nil, message: "最多只能选择 \(maxSelectedCount) 张照片", preferredStyle: .Alert)
        alertController!.addAction(UIAlertAction.init(title: "OK", style:.Default, handler: { (action) in
            
        }))
    }

    
}

//  MARK:- CollectionViewCell
class MyCollectionViewCell: UICollectionViewCell {
    
    let selectButton = UIButton()
    let imageView = UIImageView()
    //  cell 是否被选择
    var isChoose = false {
        didSet {
            selectButton.selected = isChoose
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  展示图片
        imageView.frame = contentView.bounds
        imageView.contentMode = .ScaleToFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.backgroundColor = .cyanColor()
        
        //  展示图片选择图标
        selectButton.frame = CGRectMake(contentView.bounds.size.width * 3 / 4 - 2, 2, contentView.bounds.size.width / 4 , contentView.bounds.size.width / 4)
        selectButton.setBackgroundImage(UIImage.init(named: "iw_unselected"), forState: .Normal)
        selectButton.setBackgroundImage(UIImage.init(named: "iw_selected"), forState: .Selected)
        imageView.addSubview(selectButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}