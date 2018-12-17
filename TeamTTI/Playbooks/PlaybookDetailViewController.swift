//
//  PlaybookDetailViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 17/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import WebKit

class PlaybookDetailViewController: UIViewController {

    @IBOutlet private weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tncURL =  "http://www.pdf995.com/samples/pdf.pdf"
        wkWebView.load(URLRequest(url: URL(string: tncURL)!))
    }
}
