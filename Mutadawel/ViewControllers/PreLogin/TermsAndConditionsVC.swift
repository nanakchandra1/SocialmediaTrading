//
//  TermsAndConditionsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!

    
    var navTitleStr = ""
    var action = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationTitle.text = self.navTitleStr
        self.backBtn.rotateBackImage()
        showTermAndConditions()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ = sharedAppdelegate.nvc.popViewController(animated: true)
    }

    
    
    
    func showTermAndConditions() {
        
        var params = JSONDictionary()
        
        params["action"] = action as AnyObject
        showLoader()
        staticPagesAPI(params: params) { (success, msg, data) in
            hideLoader()

            if success{
                
                
                 let html = data?["content"].stringValue
                
                let str = html?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                print_debug(object: str)
                self.webView.loadHTMLString(str!, baseURL: nil)


            }
        }
    }
    
}
