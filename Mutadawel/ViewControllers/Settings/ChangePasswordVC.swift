//
//  ChangePasswordVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 21/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ChangePasswordVC: MutadawelBaseVC {
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var currentPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var retypeNewPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func initialSetup(){
        self.saveBtn.layer.cornerRadius = 2
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.saveBtn.setTitle(SAVE_BTN.localized, for: UIControlState.normal)
        self.currentPassTextField.placeholder = CURRENT_PASSWORD.localized
        self.newPassTextField.placeholder = NEW_PASSWORD.localized
        self.retypeNewPassTextField.placeholder = RE_TYPE_PASSWORD.localized
        self.navigationTitle.text = CHANGE_PASSWORD.localized
        
        self.backBtn.rotateBackImage()
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.currentPassTextField.textAlignment = .right
            self.newPassTextField.textAlignment = .right
            self.retypeNewPassTextField.textAlignment = .right
            
        }else{
            
            self.currentPassTextField.textAlignment = .left
            self.newPassTextField.textAlignment = .left
            self.retypeNewPassTextField.textAlignment = .left
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if !self.currentPassTextField.hasText{
            showToastWithMessage(msg: Please_enter_Current_Password.localized)
            return
        }else{
            if (self.currentPassTextField.text?.characters.count)! < 8 {
                showToastWithMessage(msg: Password_must_be_more_than_7_characters.localized)
                return
                
            }else if (self.currentPassTextField.text?.characters.count)! > 20{
                showToastWithMessage(msg: Password_should_not_be_more_than_20_characters.localized)
                return
            }
        }
        
        if !self.newPassTextField.hasText{
            showToastWithMessage(msg: Please_enter_New_Password.localized)
            return
            
        }else{
            if (self.newPassTextField.text?.characters.count)! < 8 {
                showToastWithMessage(msg: Password_must_be_more_than_7_characters.localized)
                return
                
            }else if (self.newPassTextField.text?.characters.count)! > 20{
                showToastWithMessage(msg: Password_should_not_be_more_than_20_characters.localized)
                return
            }
        }
        
        if !self.retypeNewPassTextField.hasText{
            showToastWithMessage(msg: Please_enter_Confirm_Password.localized)
            return
        }else{
            if (self.retypeNewPassTextField.text?.characters.count)! < 8 {
                showToastWithMessage(msg: Password_must_be_more_than_7_characters.localized)
                return
                
            }else if (self.retypeNewPassTextField.text?.characters.count)! > 20{
                showToastWithMessage(msg: Password_should_not_be_more_than_20_characters.localized)
                return
            }
            
        }
        
        if self.newPassTextField.text != self.retypeNewPassTextField.text{
            
            showToastWithMessage(msg: pass_validation.localized)
            return
            
        }
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        params["current_password"] = self.currentPassTextField.text!
        params["new_password"] = self.newPassTextField.text!
        params["confirm_password"] = self.retypeNewPassTextField.text!
        
        print_debug(object: params)
        showLoader()
        changePasswordAPI(params: params) { (success, msg, data) in
            hideLoader()
            showToastWithMessage(msg: msg)
            if success{
                self.currentPassTextField.text = ""
                self.newPassTextField.text = ""
                self.retypeNewPassTextField.text = ""
            }
        }
    }
    
    
    //    userId
    //    current_password
    //    new_password
    //    confirm_password
}



