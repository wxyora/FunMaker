//
//  MyProfileViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/6.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

import Alamofire

class MyProfileViewController:BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var mobile: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    //UIImageView监听 1 uiimageview上增加tap gesture recognizer 2 uiimageview 开启user interaction enabled 3 controller最上面gesture图标拖拽action
    
    @IBAction func changeHeadImage(_ sender: AnyObject) {
        takePhoto()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 2{
            takePhoto()
        }
    }
    
    func takePhoto(){
        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.destructive) { (alertAciton) -> Void in
            
            //判断是否能进行拍照，可以的话打开相机
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
                
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
            
            })
        actionSheet.addAction(UIAlertAction(title: "打开相册", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
            //调用相册功能，打开相册
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
            })
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (alertAciton) -> Void in})
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobile.text=getMobile()
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()

        
        //设置头像圆角
        headImage.layer.cornerRadius = headImage.frame.width/2
        print(headImage.frame.width/2)
        //设置遮盖额外部分,下面两句的意义及实现是相同的
//      headImage.clipsToBounds = true
        headImage.layer.masksToBounds = true
        
        headImage.layer.borderWidth=1
        headImage.layer.borderColor = UIColor.gray.cgColor
        
        
        //let userInfo=NSUserDefaults.standardUserDefaults()
        let token  =  userInfo.object(forKey: "token")
        let headObj = userInfo.object(forKey: "headImage")
        var headName = ""
        
        if token == nil{
            let head=UIImage(named: "skull")
            self.headImage.image=head
            
        }else{
            headName  =  String(describing: headObj!)
            if headName != ""{
                let dispath=DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                dispath.async(execute: { () -> Void in
                    
                    var str = Constant.head_image_host+headName+".png"
                    //防止url报出空指针异常
                    str = str.addingPercentEscapes(using: String.Encoding.utf8)!
                    let url:URL = URL(string:str)!
                    let data=try? Data(contentsOf: url)
                    
                    if data != nil {
                        let ZYHImage=UIImage(data: data!)
                        //写缓存
                        DispatchQueue.main.async(execute: { () -> Void in
                            //刷新主UI
                            self.headImage.image = ZYHImage
                        })
                    }
                })

            }
        }
        
//        let headObj = userInfo.objectForKey("headImage")
//        var headName = ""
//        let dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
//        dispatch_async(dispath, { () -> Void in
//            
//            var str = Constant.host+Constant.headImageUrl+headName+".png"
//            //防止url报出空指针异常
//            str = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//            let url:NSURL = NSURL(string:str)!
//            let data=NSData(contentsOfURL: url)
//            
//            if data != nil {
//                let ZYHImage=UIImage(data: data!)
//                //写缓存
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    //刷新主UI
//                     self.headImage.image = ZYHImage
//                })
//            }
//        })
        


    }
    
    //MARK: - 保存图片至沙盒
    func saveImage(_ currentImage:UIImage,imageName:String){
        var imageData = Data()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(imageName)
        // 将图片写入文件
        try? imageData.write(to: URL(fileURLWithPath: fullPath), options: [])
    }
    
    //UIImagePicker回调方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //获取照片的原图
        //let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
        //获得编辑后的图片
       let image = (info as NSDictionary).object(forKey: UIImagePickerControllerEditedImage)
       let imageData = UIImageJPEGRepresentation(image as! UIImage, 0.5)!
        //保存图片至沙盒
       //self.saveImage(image as! UIImage, imageName: "currentImage.png")
       //let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("currentImage.png")
        //存储后拿出更新头像
        let savedImage = UIImage(data: imageData)
        self.headImage.image=savedImage
       // var fileURL = NSURL(fileURLWithPath: fullPath)
        upload(savedImage!,address: Constant.host + Constant.updateHeadImage)//上传
        
        picker.dismiss(animated: true, completion: nil)
        

  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
     func upload(_ uploadImage: UIImage,address: String) {
        
        self.pleaseWait()
        
        //Alamofire.upload(multipartFormData: (MultipartFormData) -> Void, to: URLConvertible, encodingCompletion: <#T##((SessionManager.MultipartFormDataEncodingResult) -> Void)?##((SessionManager.MultipartFormDataEncodingResult) -> Void)?##(SessionManager.MultipartFormDataEncodingResult) -> Void#>)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let data = UIImageJPEGRepresentation(uploadImage,0.3)?.base64EncodedData(options: Data.Base64EncodingOptions.init(rawValue: 0))

            multipartFormData.append(data!, withName: "headImage")
            //把剩下的两个参数作为字典,利用 multipartFormData.appendBodyPart(data: name: )添加参数,
            //因为这个方法的第一个参数接收的是NSData类型,所以要利用 NSUTF8StringEncoding 把字符串转为NSData
            let param = ["mobile":self.getMobile()]
            
            //遍历字典
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },to:address) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if let myJson = response.result.value {
                        let json = myJson as! Dictionary<String,AnyObject>
                        let result = json["result"] as! String
                        self.clearAllNotice()
                        if result=="上传成功" {
                            let headImage = String(describing: json["headImage"]!)
                            self.noticeSuccess("上传成功", autoClear: true, autoClearTime: 1)
                            let userInfo:UserDefaults=UserDefaults.standard
                            userInfo.set(headImage, forKey: "headImage")
                            userInfo.set(Constant.head_image_host+headImage+".png", forKey: self.getMobile())
                            userInfo.synchronize();
                            //上传头像成功后更新本地会话显示
                            RCIM.shared().currentUserInfo=RCUserInfo(userId: self.getMobile(), name: self.getMobile(), portrait: Constant.head_image_host+headImage+".png")
                            //通知融云头像发生变更
//                            let user = RCUserInfo(userId:self.getMobile(), name: self.getMobile(), portrait:Constant.head_image_host+headImage+".png")
//                            RCIM.sharedRCIM().refreshUserInfoCache(user, withUserId: self.getMobile())
                        }else {
                            self.noticeError("上传失败，请重试。", autoClear: true, autoClearTime: 2)
                        }
                    }
                })
            case .failure(let error):
                self.clearAllNotice()
                self.noticeError(String(describing: error), autoClear: true, autoClearTime: 2)
            }
            
        }
    }
}
