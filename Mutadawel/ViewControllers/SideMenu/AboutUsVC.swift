//
//  AboutUsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AboutUsVC: MutadawelBaseVC {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var contactUsBtn: UIButton!

    let eventId = "about us"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewStup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initialViewStup(){
        
        self.navigationTitle.text = ABOUT_US.localized
        self.contactUsBtn.setTitle(CONTACT_US.localized, for: UIControlState.normal)
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.showAboutUs()
    
    }
    
    
    func showAboutUs() {
        
        var params = JSONDictionary()
        
        params["action"] = 1 as AnyObject
        
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

    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if sharedAppdelegate.appLanguage == .English{
            openLeft()
        }else{
            openRight()
        }
       // _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactUsBtnTapped(_ sender: UIButton) {
        setEvent(eventName: FirebaseEventName.contact_us, params: ["eventId": self.eventId as NSObject])

        let contactScene = sideMenuStoryboard.instantiateViewController(withIdentifier: "ContactUsID") as! ContactUsVC
        contactScene.sideMenuState = .None
        self.navigationController?.pushViewController(contactScene, animated: true)
    }



}
