//
//  Constant.swift
//  funmaker
//
//  Created by Waylon on 16/7/21.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import Foundation

class Constant: NSObject {
    
    
    static var host = "http://139.196.192.191:8080"
    //http://139.196.192.191:8080/eguest_image/
    static var head_image_host = "http://139.196.192.191:8080/eguest_image/"
    //static var host = "http://wxyora.xicp.net:39307"
    static var loginUrl = "/WaylonServer/loginValidate.action"
    static var registUrl = "/WaylonServer/register.action"
    static var updateHeadImage = "/WaylonServer/updateHeadImage.action"
    static var findUserUrl = "/WaylonServer/findUserByMobile.action"
    static var publishUrl = "/WaylonServer/addUnion.action"
    static var deleteUnion = "/WaylonServer/deleteUnion.action"
    static var getUnionByUser = "/WaylonServer/getUnionByUser.action"
    static var getUnionByUnionId = "/WaylonServer/getUnionByUnionId.action"
    static var getAllUnionByPage = "/WaylonServer/getAllUnionByPage.action"
 
    //wxyora.xicp.net:39307WaylonServer/getUnionByUser.action?userId=15901966196
    
    
    //wxyora.xicp.net:39307/WaylonServer/getUnionByUnionId.action?unionId=6
    
    //139.196.192.191:8080/WaylonServer/getUnionByUnionId.action?unionId=86
    
    //139.196.192.191:8080/WaylonServer/getUnionByUser.action?userId=15901966196

    

}
