//
//  LoginVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class LoginVC: MutadawelBaseVC {

    //MARK:- =========================================
    //MARK:- IBOutlets
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    
    //MARK:- =========================================
    //MARK:- View life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewStup()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        var tapGasture =  UITapGestureRecognizer()
        tapGasture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification:Notification!) -> Void in
            
            self.view.addGestureRecognizer(tapGasture)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil,
                                               
                                               queue: OperationQueue.main) {_ in
                                                
                                                self.view.removeGestureRecognizer(tapGasture)
                                                
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    
    func dismissKeyboard(_sender: AnyObject){
        
        self.view.endEditing(true)
    }
    
    func initialViewStup(){
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            self.userNameTextField.textAlignment = .right
            self.passwordTextField.textAlignment = .right
        }else{
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back"), for: .normal)
            self.userNameTextField.textAlignment = .left
            self.passwordTextField.textAlignment = .left
        }
        self.navigationTitle.text = SIGN_IN.localized
        self.signInBtn.layer.cornerRadius = 2
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.signInBtn.setTitle(SIGN_IN.localized, for: UIControlState.normal)
        self.signupBtn.setTitle(SIGN_UP.localized, for: UIControlState.normal)
        self.forgotPassBtn.setTitle(FORGOT_PASS_BTN.localized, for: UIControlState.normal)
        self.userNameTextField.placeholder = EMAIL_OR_MOB_NO_TEXTFIELD.localized
        self.passwordTextField.placeholder = PASSWORD.localized
        self.userNameTextField.selectedTitle = EMAIL_OR_MOB_NO_TEXTFIELD.localized
        self.userNameTextField.title = EMAIL_OR_MOB_NO_TEXTFIELD.localized
        self.passwordTextField.selectedTitle = PASSWORD.localized
        self.passwordTextField.title = PASSWORD.localized
        self.backBtn.rotateBackImage()

        if sharedAppdelegate.appLanguage == .Arabic{
            self.userNameTextField.textAlignment = .right
            self.passwordTextField.textAlignment = .right

        }else{
            self.userNameTextField.textAlignment = .left
            self.passwordTextField.textAlignment = .left
        }
    }
    
    //MARK:- =========================================
    //MARK:- IBActions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)

        _ = self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)

        if !self.userNameTextField.hasText{
            sharedAppdelegate.nvc.view.makeToast(Enter_User_Name.localized)
            return
        }
        
        if !self.passwordTextField.hasText{
            sharedAppdelegate.nvc.view.makeToast(Enter_Password.localized)
            return
        }
        
        if (self.passwordTextField.text?.characters.count)! < 8{
            showToastWithMessage(msg: Password_must_be_more_than_7_characters.localized)
            return
        }
        if (self.passwordTextField.text?.characters.count)! > 20{
            showToastWithMessage(msg: Password_should_not_be_more_than_20_characters.localized)
            return
        }

        var params = JSONDictionary()
        
        params["password"] = self.passwordTextField.text! as AnyObject?
        
        let text = self.userNameTextField.text!
        
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
        
        if sharedAppdelegate.deviceToken != nil{
            
            params["device_token"] = sharedAppdelegate.deviceToken! as AnyObject?
            
        }else{
            
            params["device_token"] = "12345" as AnyObject?
        }
        
        params["device_id"] = UIDevice.current.identifierForVendor?.uuidString as AnyObject?
        
        params["platform"] = "2" as AnyObject?
        
        print_debug(object: params)
        
        showLoader()
        
        loginAPI(params: params) { (success, msg, data) in
            print_debug(object: data)
            hideLoader()
            if success{
				
                _ = UserData(withJson: data!)
                gotoHome()
                setEvent(eventName: FirebaseEventName.success_Login, params: ["eventId": "sign in" as NSObject])
				
            }else{
				
                showToastWithMessage(msg: msg)
                setEvent(eventName: FirebaseEventName.wrong_userid_or_pass, params: ["eventId": "sign in" as NSObject])
				
            }
        }
    }
    
    
    @IBAction func forgotBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ResetPasswordID") as! ResetPasswordVC
        self.navigationController?.pushViewController(obj, animated: true)
        setEvent(eventName: FirebaseEventName.forgot_pass, params: ["eventId": "sign in" as NSObject])

        
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)

        let signupScene = preLoginStoryboard.instantiateViewController(withIdentifier: "SignUpID") as! SignUpVC
        self.navigationController?.pushViewController(signupScene, animated: true)
        setEvent(eventName: FirebaseEventName.signup, params: ["eventId": "sign up" as NSObject])

    }

}


extension LoginVC: UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField === self.passwordTextField{
            
            if isValidNumber(str: string){
                return false
            }
        }
        return true

    }
}
