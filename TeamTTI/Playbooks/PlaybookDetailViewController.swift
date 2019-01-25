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
    
    public var playbookURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        //show progress hud
        self.showHUD(progressLabel: "")
        wkWebView.navigationDelegate = self
        if playbookURL != nil {
            wkWebView.load(URLRequest(url: playbookURL!))
        }
    }
    
    // MARK: - WKWebView delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //hide progress hud
        self.dismissHUD(isAnimated: true)
    }
}
