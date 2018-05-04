//
//  WebViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/3.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import WebKit
//import JavaScriptCore

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate, WKScriptMessageHandler, UITextFieldDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        // 向JS注入bridge
        webView.configuration.userContentController.add(
            self,
            name: "callbackHandler"
        )
        
        // 调用js方法
//        let conf = WKWebViewConfiguration()
//        let userScript = WKUserScript(source: "changeTestText()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        conf.userContentController.addUserScript(userScript)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // WKNavigationDelegate protocol
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webview didStartProvisionalNavigation")
//        loading.startAnimating()
        //状态栏的网络请求轮圈开始转动
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // WKNavigationDelegate protocol
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webview didCommit")
//        loading.stopAnimating()
        //状态栏的网络请求轮圈停止转动
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webview didFinish")
        // 原生调用H5
        webView.evaluateJavaScript("changeTestText()") { (value, err) in
            print("call H5 javascript successfully")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.alpha = 1.0
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0.1, options: .beginFromCurrentState, animations: {
                    self.progressBar.alpha = 0
                }, completion: { (finish) in
                    self.progressBar.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    // WKScriptMessageHandler protocol
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            print("JavaScript is sending a message \(message.body)")
        }
    }
    
    // 加载请求的方法
    func loadUrl(url: String, web: WKWebView) {
        //载入输入的请求
        let aUrl = NSURL(string: ("http://" + url))!
        let urlRequest = NSURLRequest(url: aUrl as URL)
        web.load(urlRequest as URLRequest)
    }
    
    @IBAction func goBack() {
        webView.goBack()
    }
    
    // textfield protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loadUrl(url: textField.text!, web: webView)
        //解除textField的第一响应者的注册资格，键盘消失；若没有这一步，键盘会一直留在屏幕内
        textField.resignFirstResponder()
        return true
    }
    
    func methodForJs1() {
        print("js call methodForJs1 successfully")
    }
    
    func methodForJs2(str:String) {
        print("js call methodForJs2 successfully, str:" + str)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//@objc protocol JavaScriptSwiftDelegate: JSExport {
//    func callWithDict(dict: [String: AnyObject])
//}
//
//@objc class JSObjCModel: NSObject, JavaScriptSwiftDelegate {
//    weak var controller: UIViewController?
//    weak var jsContext: JSContext?
//
//    // JS调用了我们的方法
//    func callWithDict(dict: [String : AnyObject]) {
//        print("js call objc method: callWithDict, args: %@", dict)
//    }
//}
