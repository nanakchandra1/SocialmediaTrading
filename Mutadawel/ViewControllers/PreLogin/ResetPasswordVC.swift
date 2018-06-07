//
//  ResetPasswordVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ResetPasswordVC: MutadawelBaseVC {

    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    
    var data = JSONDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    private func initialSetUp(){
        
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        if sharedAppdelegate.appLanguage == .Arabic{
            self.mobileTextField.textAlignment = .right
        }else{
            self.mobileTextField.textAlignment = .left
        }
        
        self.backBtn.rotateBackImage()
        
        self.sendBtn.setTitle(SUBMIT_BTN.localized, for: UIControlState.normal)
        self.mobileTextField.placeholder = EMAIL_OR_MOB_NO_TEXTFIELD.localized
        self.mobileTextField.selectedTitle = EMAIL_OR_MOB_NO_TEXTFIELD.localized
        self.mobileTextField.title = EMAIL_OR_MOB_NO_TEXTFIELD.localized
        self.navigationTitle.text = RESET_PASS.localized
        self.mobileTextField.delegate = self
        
    }

    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ =  self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
        if self.mobileTextField.text == "" {
            showToastWithMessage(msg: Please_enter_Email_or_Mobile_number_or_Username.localized)
            return
        }
        var params = JSONDictionary()
        
        let text = self.mobileTextField.text!
        
        if isValidEmail(testStr: text){
            
            params["email"] = text as AnyObject?
            params["login_flag"] = "2" as AnyObject?
            
            
        }else if isValidatePhone(str: text){
            
            params["mobile_number"] = text as AnyObject?
            params["login_flag"] = "3" as AnyObject?
            
        }
        else if isValidateUsername(str: text){
            params["user_name"] = text as AnyObject?
            params["login_flag"] = "1" as AnyObject?
        }else{
            params["user_name"] = text as AnyObject?
            params["login_flag"] = "1" as AnyObject?
        }
        
        showLoader()
        
        forgotPasswordAPI(params: params) { (success, msg, data) in
            hideLoader()
            if success{
                showToastWithMessage(msg: Reset_password_link_has_been_sent_to_your_registered_email_address.localized)
                setEvent(eventName: FirebaseEventName.password_sent, params: ["eventId": "forgot password" as NSObject])

            }else{
                showToastWithMessage(msg: msg)
                setEvent(eventName: FirebaseEventName.wrong_userid, params: ["eventId": "forgot password" as NSObject])

            }
        }
    }
}



extension ResetPasswordVC: UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delayWithSeconds(0.01) {
            self.data["email"] = textField.text! as AnyObject?
        }
        return true
    }

}
