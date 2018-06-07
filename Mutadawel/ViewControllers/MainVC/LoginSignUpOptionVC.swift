//
//  LoginSignUpOptionVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Crashlytics

class LoginSignUpOptionVC: MutadawelBaseVC {

    
    @IBOutlet weak var signUpbtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
	@IBOutlet weak var changeLangBtn: UIButton!
	@IBOutlet weak var langFlag: UIImageView!
	@IBOutlet weak var logo: UIImageView!
	@IBOutlet weak var changeLangBtnView: UIView!
	@IBOutlet weak var helpBtn: UIButton!
	
	
	let eventId = "main"
	
    override func viewDidLoad() {
		
		if sharedAppdelegate.appLanguage == .English{
			
			let img = #imageLiteral(resourceName: "saudi-arabia")
			self.langFlag.image = img
			self.changeLangBtn.setTitle("العربية", for: UIControlState.normal)
			
		}else{
			
			let img = #imageLiteral(resourceName: "united-states")
			self.langFlag.image = img
			self.changeLangBtn.setTitle("English", for: UIControlState.normal)
		}
		
		if sharedAppdelegate.appLanguage == .Arabic{
			
			 //self.tradeScene.view.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi))
			self.changeLangBtnView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
			//self.logo.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
		}

        super.viewDidLoad()
		self.helpBtn.setTitle(" \(SUPPORT.localized) ", for: .normal)
        self.signUpbtn.layer.cornerRadius = 2
        self.signUpbtn.setTitle(SIGN_UP.localized, for: UIControlState.normal)
        self.signinBtn.setTitle(SIGN_IN.localized, for: UIControlState.normal)
		//self.changeLangBtn.setTitle(CHANGE_LANG_BTN.localized, for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func showAlert(isEnglish: Bool){
        
        let alert = UIAlertController(title: "", message: change_lang.localized, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: Yes.localized, style: .default, handler: { (UIAlertAction) in
            
            self.changeLanguage(isEnglish: isEnglish)
        }))
        
        alert.addAction(UIAlertAction(title: No.localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func changeLanguage(isEnglish: Bool){
        
        if isEnglish{
            
            userDefaults.set("en", forKey: UserDefaultsKeys.APP_LANGUAGE)
        }else{
            
            userDefaults.set("ar", forKey: UserDefaultsKeys.APP_LANGUAGE)
        }
        
        Crashlytics.sharedInstance().crash()
        
    }

	
	@IBAction func changeLang(_ sender: Any) {
		
		if sharedAppdelegate.appLanguage == .English{
		
			showAlert(isEnglish: false)
			
		}else{
		
			showAlert(isEnglish: true)
		}
	}
	
    @IBAction func signupBtnTapped(_ sender: UIButton) {
		
        let loginScene = preLoginStoryboard.instantiateViewController(withIdentifier: "SignUpID") as! SignUpVC
        sharedAppdelegate.nvc.pushViewController(loginScene, animated: true)
        setEvent(eventName: FirebaseEventName.signup, params: ["eventId": "first page" as NSObject])

        
    }
    
    @IBAction func signinBtnTapped(_ sender: UIButton) {
        
        let loginScene = preLoginStoryboard.instantiateViewController(withIdentifier: "LoginID") as! LoginVC
        sharedAppdelegate.nvc.pushViewController(loginScene, animated: true)
        setEvent(eventName: FirebaseEventName.login, params: ["eventId": "first page" as NSObject])

    }
    
	@IBAction func helpBtnTapped(_ sender: Any) {
		
		let obj = mainStoryboard.instantiateViewController(withIdentifier: "helpID") as! helpVC
		
		self.navigationController?.pushViewController(obj, animated: true)
		
	}
	
    

}
