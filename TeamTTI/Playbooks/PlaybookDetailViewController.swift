//
//  PlaybookDetailViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 17/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import WebKit

class PlaybookDetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet private weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        //show progress hud
        self.showHUD(progressLabel: "")
        let tncURL =  "http://www.pdf995.com/samples/pdf.pdf"
        wkWebView.navigationDelegate = self
        wkWebView.load(URLRequest(url: URL(string: tncURL)!))
    }
    
    // MARK: - WKWebView delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //hide progress hud
        self.dismissHUD(isAnimated: true)
    }
}
