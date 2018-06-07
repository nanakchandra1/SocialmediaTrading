//
//  ContactUsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

enum ContactState {
    
    case Contact,Support
    
}


class ContactUsVC: MutadawelBaseVC {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var msgTextView: KMPlaceholderTextView!
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    var sideMenuState = ProfileState.None
    var contactState = ContactState.Contact
    let eventId = "contact us"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialViewStup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initialViewStup(){
        
        self.nameTextField.delegate = self
        self.msgTextView.delegate = self
        if self.contactState == .Contact{
            self.navigationTitle.text = CONTACT_US.localized
            self.msgTextView.placeholder = MESSAGE.localized
            self.sendMsgBtn.setTitle(SEND_MSG_BTN.localized, for: .normal)
            
        }else{
            
            self.navigationTitle.text = SUPPORT.localized
            self.msgTextView.placeholder = DESCRIBE_ISSUE.localized
            self.sendMsgBtn.setTitle(SUBMIT_BTN.localized, for: .normal)
            
            
        }
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        
        if self.sideMenuState == .None{
            self.backBtn.rotateBackImage()
        }else{
            self.backBtn.setImage(ButtonImg.burgerBtn, for: UIControlState.normal)
        }
        
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.nameTextField.textAlignment = .right
            self.msgTextView.textAlignment = .right
            
        }else{
            
            self.nameTextField.textAlignment = .left
            self.msgTextView.textAlignment = .left
            
        }
        self.nameTextField.placeholder = SUBJECT.localized
        self.nameTextField.selectedTitle = SUBJECT.localized
        self.nameTextField.title = SUBJECT.localized
        self.infoLbl.text = DESCRIPTION_LABEL.localized
    }
    
    
    
    func contactUsInfo(url: String){
        
        showLoader()
        var params = JSONDictionary()
        params["title"] = self.nameTextField.text!
        params["description"] = self.msgTextView.text!
        
        params["userId"] = CurrentUser.user_id 
        contactUsAPI(params: params,url: url) { (success, msg, data) in
            print_debug(object: data)
            hideLoader()
            if success{
                setEvent(eventName: FirebaseEventName.sent_message_successful, params: ["eventId": self.eventId as NSObject])
                
                self.nameTextField.text = ""
                self.msgTextView.text = ""
                showToastWithMessage(msg: Your_message_has_been_sent_successfully.localized)
                
            }else{
            }
        }
    }
    
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if self.sideMenuState == .None{
            
            _ = self.navigationController?.popViewController(animated: true)
            
        }else{
            
            if sharedAppdelegate.appLanguage == .English{
                
                openLeft()
                
            }else{
                
                openRight()
                
            }
        }
    }
    
    
    
    @IBAction func sendMsgBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if !nameTextField.hasText{
            
            showToastWithMessage(msg: Please_enter_the_subject.localized)
            
            return
            
        }
        
        if !msgTextView.hasText {
            
            if self.contactState == .Contact{
                
                showToastWithMessage(msg: Please_enter_the_message.localized)
                
            }else{
                
                showToastWithMessage(msg: DESCRIBE_ISSUE.localized)
                
            }
            
            return
        }
        
        if self.contactState == .Contact{
            
            self.contactUsInfo(url: EndPoint.contactUsURL)
            
        }else{
            
            self.contactUsInfo(url: EndPoint.supportUsURL)
            
        }
    }
    
}



extension ContactUsVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isSingleEmoji{
            return false
        }
        return true
        
    }
    
}

extension ContactUsVC: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.isSingleEmoji{
            
            return false
            
        }
        
        return true
        
    }
}
