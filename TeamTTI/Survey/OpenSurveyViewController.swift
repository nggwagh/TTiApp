//
//  OpenSurveyViewController.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/11/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import WebKit

class OpenSurveyViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet private weak var wkWebView: WKWebView!
    
    public var surveyURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //show progress hud
        self.showHUD(progressLabel: "")
        wkWebView.navigationDelegate = self
        if surveyURL != nil {
            wkWebView.load(URLRequest(url: surveyURL!))
        }
    }
    
    // MARK: - WKWebView delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //hide progress hud
        self.dismissHUD(isAnimated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
