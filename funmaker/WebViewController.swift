//
//  WebViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/30.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController,UIWebViewDelegate {

    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var progressShow: UIActivityIndicatorView!
    
    @IBAction func returnUpStep(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
    
        super.viewDidLoad()
        myWebView.delegate = self
        let url = NSURL(string: "https://www.baidu.com")!
        let request = NSURLRequest(URL: url)
        myWebView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        progressShow.stopAnimating()
        progressShow.hidesWhenStopped = true

        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        progressShow.startAnimating()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
