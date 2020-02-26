//  ShowResultViewController.swift
//  Copyright © 2019 ALiCE. All rights reserved.

import UIKit
import WebKit
import AliceOnboarding

class ShowResultViewController: UIViewController, WKNavigationDelegate {
    var userId: String?
    var webView: WKWebView?
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dashboardView: UIView!
    @IBAction func doneAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    @IBAction func refreshAction(_ sender: Any) {
        webView!.reload()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadView() {
        super.loadView()
        let url = URL(string: "\(AliceUrl.dashboard)/#/users/\(self.userId ?? "")")!
        let myView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.bounds.width,
                                          height: view.bounds.height))
        self.view.addSubview(myView)
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration  = WKWebViewConfiguration()
        configuration.preferences = preferences
        webView = WKWebView(frame: myView.frame, configuration: configuration)
        webView!.navigationDelegate = self
        webView!.allowsBackForwardNavigationGestures = true
        dashboardView.addSubview(webView!)
        webView!.load(URLRequest(url: url))
        self.view.bringSubviewToFront(dashboardView)
        self.view.bringSubviewToFront(navigationBar)
    }
}
