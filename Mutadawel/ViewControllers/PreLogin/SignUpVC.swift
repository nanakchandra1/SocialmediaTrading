//
//  SignUpVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Photos
import Crashlytics

class SignUpVC: MutadawelBaseVC,TTTAttributedLabelDelegate {
    
    //MARK:- =======================================
    //MARK:- IBOUTLETS
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var phoneNoTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var terms_ConditionLabel: TTTAttributedLabel!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
	@IBOutlet weak var helpBtn: UIButton!
	@IBOutlet weak var langFlag: UIImageView!
	@IBOutlet weak var changeLangBtnView: UIView!
	@IBOutlet weak var changeLangBtn: UIButton!
	@IBOutlet weak var countryCodeLineView: UIView!
    //MARK:- =======================================
    //MARK:- Properties
    
    var selectedImage : UIImage?
    var picker:UIImagePickerController? = UIImagePickerController()
    var userDataDict = [String:String]()
    var isUpload = false
    var maxNo = 9
    var minNo = 9

    
    //MARK:- View life cycle methods
    //MARK:- ===================================

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialViewStup()
		
		if sharedAppdelegate.appLanguage == .English{
			
			let img = #imageLiteral(resourceName: "saudi-arabia")
			self.langFlag.image = img
			self.changeLangBtn.setTitle("العربية", for: UIControlState.normal)
			
		}else{
			
			let img = #imageLiteral(resourceName: "united-states")
			self.langFlag.image = img
			self.changeLangBtn.setTitle("English", for: UIControlState.normal)
		}
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    //MARK:-  metrhods
    //MARK:- ===================================

    
    func initialViewStup(){
        
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.terms_ConditionLabel.text = TERMS_AND_CONDITIONS.localized
		self.helpBtn.setTitle(" \(SUPPORT.localized) ", for: .normal)
        self.signUpBtn.layer.cornerRadius = 2
        self.profilePic.layer.cornerRadius = self.profilePic.layer.frame.width/2
        self.profilePic.layer.masksToBounds = true
        self.terms_ConditionLabel.delegate = self
        self.picker?.delegate = self
        let str:NSString = self.terms_ConditionLabel.text! as NSString
        let range : NSRange = str.range(of: T_C.localized)
        self.terms_ConditionLabel.addLink(to: NSURL(string: "abc")! as URL!, with: range)
        self.setLocalizedString()
        self.backBtn.rotateBackImage()
        self.nameTextField.keyboardType = .default
//        self.terms_ConditionLabel.linkAttributes = [
//            NSForegroundColorAttributeName: AppColor.appButtonColor,
//            NSUnderlineStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleDouble.rawValue)
//        ]
        self.userDataDict["countrycode"] = "+966"
        self.countryCodeTextField.text = "+966"

        self.userNameTextField.delegate = self
        self.nameTextField.delegate = self
        self.countryCodeTextField.delegate = self
        self.phoneNoTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

    }
    
    
    private func setLocalizedString(){
        
        self.userNameTextField.placeholder = USER_NAME.localized
        self.userNameTextField.title = USER_NAME.localized
        self.userNameTextField.selectedTitle = USER_NAME.localized
        self.nameTextField.placeholder = NAME.localized
        self.nameTextField.title = NAME.localized
        self.nameTextField.selectedTitle = NAME.localized
        self.phoneNoTextField.placeholder = MOBILE_NO.localized
        self.phoneNoTextField.title = MOBILE_NO.localized
        self.phoneNoTextField.selectedTitle = MOBILE_NO.localized
        self.emailTextField.placeholder = EMAIL.localized
        self.emailTextField.title = EMAIL.localized
        self.emailTextField.selectedTitle = EMAIL.localized
        self.passwordTextField.placeholder = PASSWORD.localized
        self.passwordTextField.title = PASSWORD.localized
        self.passwordTextField.selectedTitle = PASSWORD.localized
        self.signUpBtn.setTitle(SIGN_UP.localized, for: UIControlState.normal)
        self.navigationTitle.text = SIGN_UP.localized
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            self.userNameTextField.textAlignment = .right
            self.nameTextField.textAlignment = .right
            self.userNameTextField.textAlignment = .right
            self.passwordTextField.textAlignment = .right
            self.countryCodeTextField.textAlignment = .right
            self.phoneNoTextField.textAlignment = .right
            self.emailTextField.textAlignment = .right
            
        }else{
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back"), for: .normal)
            self.userNameTextField.textAlignment = .left
            self.nameTextField.textAlignment = .left
            self.userNameTextField.textAlignment = .left
            self.passwordTextField.textAlignment = .left
            self.countryCodeTextField.textAlignment = .left
            self.phoneNoTextField.textAlignment = .left
            self.emailTextField.textAlignment = .left
            
        }

    }
    // attriuted label didselect method
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "TermsAndConditionsID") as! TermsAndConditionsVC
        obj.navTitleStr = T_C.localized
        obj.action = "2"
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        setEvent(eventName: FirebaseEventName.term_cond, params: ["eventId": "sign up" as NSObject])

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
			
			UIView.appearance().semanticContentAttribute = .forceLeftToRight
			
			
			userDefaults.setValue(App_Language_name.english, forKey: UserDefaultsKeys.APP_LANGUAGE)
			
		}else{
			
			UIView.appearance().semanticContentAttribute = .forceRightToLeft
			
			
			userDefaults.setValue(App_Language_name.arabic, forKey: UserDefaultsKeys.APP_LANGUAGE)
			
		}
		
		Crashlytics.sharedInstance().crash()
		
	}
	
	
    
    //MARK:- IBActions
    //MARK:- ===================================

	@IBAction func changeLang(_ sender: Any) {
		
		if sharedAppdelegate.appLanguage == .English{
			
			showAlert(isEnglish: false)
			
		}else{
			
			showAlert(isEnglish: true)
		}
	}
	
    @IBAction func countryCodeBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "CountryCodeID") as! CountryCodeVC
        obj.delegate = self
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)

    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)

        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func profilePicTapped(_ sender: UIButton) {
        self.view.endEditing(true)

        self.OpenActionSheet(sender: sender)

    }
    
	@IBAction func helpBtnTapped(_ sender: Any) {
		
		let obj = mainStoryboard.instantiateViewController(withIdentifier: "helpID") as! helpVC
		
		self.navigationController?.pushViewController(obj, animated: true)
	}
    
    @IBAction func signUpBtntapped(_ sender: UIButton) {
        self.view.endEditing(true)

        guard let name = self.userDataDict["name"] else{
            showToastWithMessage(msg: Please_enter_the_Name.localized)
            return
        }
        guard let username = self.userDataDict["username"] else{
            showToastWithMessage(msg: Please_enter_the_UserName.localized)
            return
        }
        
        if username.characters.count < 5{
            
            showToastWithMessage(msg: username_must_5_char.localized)
            
            return

        }
        
        guard isValidateUsername(str: username) else{
        
            showToastWithMessage(msg: Please_enter_valid_UserName.localized)
            return
            
        }
        
        guard let code = self.userDataDict["countrycode"] else{
            showToastWithMessage(msg: Please_enter_Country_Code.localized)
            
            return
        }
        
        
        guard let phone = self.userDataDict["phone"] else{
            showToastWithMessage(msg: Please_enter_the_Mobile_Number.localized)
            
            return
        }
        
        if phone.characters.count < self.minNo{
            
            showToastWithMessage(msg: mobile_validation.localized)
            return
        }

        guard let email = self.userDataDict["email"] else{
            showToastWithMessage(msg: Please_enter_the_Email_Address.localized)

            return
        }
        guard isValidEmail(testStr: self.userDataDict["email"]!) else{
            showToastWithMessage(msg: Please_enter_valid_Email_Address.localized)
            setEvent(eventName: FirebaseEventName.wrong_email, params: ["eventId": "sign up" as NSObject])

            return
        }
        guard let password = self.userDataDict["password"] else{
            showToastWithMessage(msg: Please_enter_the_Password.localized)
            setEvent(eventName: FirebaseEventName.wrong_pass, params: ["eventId": "sign up" as NSObject])

            return
        }
        if password.characters.count < 8{
            showToastWithMessage(msg: Password_must_be_more_than_7_characters.localized)
            return
        }
        if password.characters.count > 20{
            showToastWithMessage(msg: Password_should_not_be_more_than_20_characters.localized)
            return
        }
        
        var params = JSONDictionary()
        params["name"] = name
        params["country_code"] = code
        params["mobile_number"] = phone
        params["email"] = email
        params["password"] = password
        params["user_name"] = username
        params["platform"] = "2"
        params["device_token"] = sharedAppdelegate.deviceToken ?? "12345"
        params["device_id"] = UIDevice.current.identifierForVendor?.uuidString

        
        if let url = self.userDataDict["profile_pic"] {
            
            params["profile_pic"] = url

        }else{
            setEvent(eventName: FirebaseEventName.no_image, params: ["eventId": "sign up" as NSObject])

        }

        
        
        showLoader()
        
        signUpAPI(params: params) { (success, msg, data) in
            
            if success{
                
                _ = UserData(withJson: data!)
                
                showToastWithMessage(msg: msg)
                
                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseMarketID") as! ChooseMarketVC
                
                obj.openMode = 1
                
                self.navigationController?.pushViewController(obj, animated: true)
                
                setEvent(eventName: FirebaseEventName.success_register, params: ["eventId": "sign up" as NSObject])

                chatSetup()
                
            }else{
                
                showToastWithMessage(msg: msg)
            }
        }
        
    }
}


//MARK:- Setcountry code delegate
//MARK:- ===================================

extension SignUpVC: SetContryCodeDelegate{

    func setCountryCode(country_info: JSONDictionary) {
        guard let code = country_info["CountryCode"] else{return}
        self.countryCodeTextField.text = "+\(code)"
        self.userDataDict["countrycode"] = "+\(code)"
        guard let img = country_info["CountryFlag"] as? String else{return}
        self.countryFlag.image = UIImage(named: img)
        guard let maxNo = country_info["Max NSN"] else{return}
        self.maxNo = Int("\(maxNo)")!
        guard let minNo = country_info["Min NSN"] else{return}
        self.minNo = Int("\(minNo)")!

    }
}



//MARK:- UITextfield delegate metrhods
//MARK:- ===================================


extension SignUpVC: UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.containsEmoji {
            return false
        }
        if textField === self.phoneNoTextField{
            if isValidNumber(str: string){
                return false
            }

        }
        
        if textField === self.passwordTextField{
            if isValidNumber(str: string){
                return false
            }
            
        }

        delayWithSeconds(0.01) {
            if textField === self.nameTextField{
                if (textField.text?.characters.count)! > 30{
                }else{
                    self.userDataDict["name"] = textField.text
                }
                
            }
            if textField === self.userNameTextField{
                self.userDataDict["username"] = textField.text
            }
            if textField === self.countryCodeTextField{
                self.userDataDict["countrycode"] = textField.text
            }
            if textField === self.phoneNoTextField{
                self.userDataDict["phone"] = textField.text
            }
            if textField === self.emailTextField{
                self.userDataDict["email"] = textField.text
            }
            if textField === self.passwordTextField{
                self.userDataDict["password"] = textField.text
            }
        }
        return validateInfo(textField: textField, string: string, range: range)
        
    }
    
    
    func validateInfo(textField :UITextField,string : String,range:NSRange) -> Bool {
        
        if range.length == 1 {
            
            return true
            
        }
        
        if textField == self.phoneNoTextField{
            if let _ = textField.text {
                
                if textField.text!.characters.count  >= self.maxNo {
                    
                    return false
                    
                } else {
                    
                    return true
                    
                }
            }
        }else if textField === self.passwordTextField{
            
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 20 // Bool

        
        }else{
        
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 30 // Bool

        }
        
        return true
    }
}



//MARK:- UIImage Picker delegate metrhods
//MARK:- ===================================

extension SignUpVC :UIImagePickerControllerDelegate , UIAlertViewDelegate , UINavigationControllerDelegate , UIPopoverControllerDelegate {
    
    func OpenActionSheet(sender : UIButton){
        
        let alert:UIAlertController = UIAlertController(title: CHOOSE_IMAGE.localized, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: CAMERA.localized, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: GALLERY.localized, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: CANCEL.localized, style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            self.present(alert, animated: true, completion: nil)
        }else{
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
                
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
        }
        else
        {
            alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
        }
    }
    
    
    //MARK:- CAMERA & GALLERY NOT ALLOWING ACCESS - ALERT
    func alertToEncourageCameraAccessWhenApplicationStarts()
    {
        //Camera not available - Alert
        let internetUnavailableAlertController = UIAlertController (title: Camera_Unavailable.localized, message: Please_check_to_see_if_it_is_disconnected_or_in_use_by_another_application.localized, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: SETTINGS.localized, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url as URL)
                
                //                DispatchQueue.main.asynchronously() {
                //                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: OKAY.localized, style: .default, handler: nil)
        internetUnavailableAlertController .addAction(settingsAction)
        internetUnavailableAlertController .addAction(cancelAction)
        
        self.present(internetUnavailableAlertController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    func alertToEncouragePhotoLibraryAccessWhenApplicationStarts(){
        //Photo Library not available - Alert
        let cameraUnavailableAlertController = UIAlertController (title: Photo_Library_Unavailable.localized, message: Please_check_to_see_if_device_settings_does_not_allow_photo_library_access.localized, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: SETTINGS.localized, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url as URL)
            }
        }
        
        let cancelAction = UIAlertAction(title: OKAY.localized, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(settingsAction)
        cameraUnavailableAlertController .addAction(cancelAction)
        
        self.present(cameraUnavailableAlertController, animated: true, completion: nil)
        
        
    }
    
    func openCamera(){
        
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
       
        switch authorizationStatus {
            
        case .notDetermined:
            
            // permission dialog not yet presented, request authorization
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                          completionHandler: { (granted:Bool) -> Void in
                                            if granted {
                                            }
                                            else {
                                            }
            })
            
        case .authorized:
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                
                picker!.sourceType = UIImagePickerControllerSourceType.camera
                
                picker?.allowsEditing = true
                
                self.present(picker!, animated: true, completion: nil)
                
            }else{
                
                openGallary()
            }
            
        case .denied, .restricted:
            
            alertToEncourageCameraAccessWhenApplicationStarts()
            
        }
    }
    
    
    func openGallary() {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            
            picker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker?.allowsEditing = true
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.selectedImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        self.profilePic.image = self.selectedImage
        showLoader()
        self.uploadTOS3Image(index: 1, image: self.selectedImage!)
    }
    
}



//MARK:- Upload image on S3 Server
//MARK:- ==========================================

extension SignUpVC{

    func uploadTOS3Image(index:Int,image:UIImage) {
        
        //print_debug("index====\(index)===state=====\(state)===\(self.arraytype)")
        let BUCKET_NAME = "tridder"
        
        let name = "ios_\(Date().timeIntervalSince1970*1000)"
        let BUCKET_DIRECTORY = "ios/\(name).jpeg"
        let path = NSTemporaryDirectory().stringByAppendingPathComponent(path: name)
        let data = UIImageJPEGRepresentation(image, 0.7)
        
        do {
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print_debug(object: error)
            //showToastWithMessage(msg: error as! String)
            hideLoader()
        }
        
        let url = NSURL(fileURLWithPath: path)
        
        let uploadRequest            = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket        = BUCKET_NAME
        uploadRequest?.acl           = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.key           = BUCKET_DIRECTORY
        uploadRequest?.body          = url as URL!
        
        //self.uploadRequests.append(uploadRequest)
        
        let transferManager = AWSS3TransferManager.default()
        transferManager?.upload(uploadRequest).continue(with: AWSExecutor.mainThread(), with:{(task) -> AnyObject in
            if let error = task.error as? NSError{
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch (errorCode) {
                        case .cancelled, .paused:
                            DispatchQueue.main.async(execute: { () -> Void in
                            })
                            break;
                            
                        default:
                            print_debug(object: "upload() failed: [\(error)]")
                            break;
                        }
                    } else {
                        print_debug(object: "upload() failed: [\(error)]")
                    }
                } else {
                    print_debug(object: "upload() failed: [\(error)]")
                }
            }
            if let exception = task.exception {
                print_debug(object: "upload() failed: [\(exception)]")
            }
            if task.result != nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let url = "https://s3-us-west-2.amazonaws.com/\(BUCKET_NAME)/\(BUCKET_DIRECTORY)"
                    self.userDataDict["profile_pic"] = url
                    self.isUpload = true
                    hideLoader()

                    
                })
            }
            return "" as AnyObject
        })
    }
}
