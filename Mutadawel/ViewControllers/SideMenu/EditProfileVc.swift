//
//  EditProfileVc.swift
//  Mutadawel
//
//  Created by ApInventiv Technologies on 02/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
import SwiftyJSON


class EditProfileVc: UIViewController {
    
    //MARK:- Properties
    //MARK:- ===================================
    
    var selectedImage : UIImage?
    var picker = UIImagePickerController()
    let eventId = "edit profile"
    
    //MARK:- IBOutlets
    //MARK:- ===================================
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var changePhotoBtn: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var backBtnTap: UIButton!
    @IBOutlet weak var bioTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var isUpload = false
    var imageUrl: String?
    
    
    
    //MARK:- view life cycle methods
    //MARK:- ===================================
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialSetup()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.userImageView.layer.cornerRadius =  self.userImageView.bounds.height / 2
        
        self.userImageView.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK:- private metrhods
    //MARK:- ===================================
    
    
    private func initialSetup(){
        
        self.nameTextField.delegate = self
        
        self.bioTextField.delegate = self
        
        self.picker.delegate = self
        
        if let name = CurrentUser.name , !name.isEmpty{
            
            self.nameTextField.text = CurrentUser.name!
        }else{
            self.nameTextField.text = ""

        }
        
        if let bio = CurrentUser.bio, !bio.isEmpty {
            
            self.bioTextField.text = CurrentUser.bio!
        }else{
         self.bioTextField.text = ""
        }
        
        self.backBtnTap.rotateBackImage()
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.nameTextField.textAlignment = .right
            
            self.bioTextField.textAlignment = .right
            
        }else{
            
            self.nameTextField.textAlignment = .left
            
            self.bioTextField.textAlignment = .left
            
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePhotoBtnTap))
        
        self.userImageView.addGestureRecognizer(tapGesture)
        
        
        self.nameTextField.placeholder = NAME.localized
        
        self.nameTextField.selectedTitle = NAME.localized
        
        self.nameTextField.title = NAME.localized
        
        self.bioTextField.placeholder = BIO.localized
        
        self.bioTextField.selectedTitle = BIO.localized
        
        self.bioTextField.title = BIO.localized
        
        self.saveBtn.setTitle(SAVE_BTN.localized, for: .normal)
        
        self.changePhotoBtn.setTitle(CHANGE_PROFILE_PHOTO.localized, for: .normal)
        
        self.navigationTitle.text = EDIT_PROFILE.localized
        
        if CurrentUser.profile_pic != nil{
            
        }
        
        if CurrentUser.profile_pic != nil{
            
            let imgUrl = URL(string: CurrentUser.profile_pic!)
            
            self.userImageView.sd_setImage(with: imgUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
            
            print_debug(object: imgUrl)
            
            self.userImageView.contentMode = .scaleToFill
            
            //self.userImageView.backgroundColor = AppColor.blue
            
        }
    }
    
    
    func editProfile(){
        
        if !self.nameTextField.hasText{
            showToastWithMessage(msg: Please_enter_the_Name.localized)
            return
        }
        
        var params = JSONDictionary()
        params["userId"] =  CurrentUser.user_id
        params["designation"] = self.bioTextField.text!
        params["name"] = self.nameTextField.text!
        
        if imageUrl != nil{
            params["profile_pic"] = self.imageUrl!
        }
        
        print_debug(object: params)
        
        showLoader()
        
        editProfileAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            showToastWithMessage(msg: Profile_has_been_updated_uccessfully.localized)
            
            if success{
                
                setEvent(eventName: FirebaseEventName.successful_edit_profile, params: ["eventId": self.eventId as NSObject])
                
//                _ = UserData(withJson: JSON(params))
                userDefaults.set(self.nameTextField.text, forKey: UserDefaultsKeys.NAME)
                userDefaults.set(self.nameTextField.text, forKey: UserDefaultsKeys.BIO)
                if self.imageUrl != nil{
                    userDefaults.set(self.imageUrl!, forKey: UserDefaultsKeys.PROFILE_PIC)
                }

                _ = sharedAppdelegate.nvc.popViewController(animated: true)
                
            }
        }
    }
    
    
    
    //MARK:- IBActions
    //MARK:- ===================================
    
    
    @IBAction func changePhotoBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)
        self.OpenActionSheet(sender: sender)
    }
    
    @IBAction func saveBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.editProfile()
    }
    
    
    @IBAction func backbtnTap(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        _ = sharedAppdelegate.nvc.popViewController(animated: true)
        
    }
}


//MARK:- UITextfield delegate metrhods
//MARK:- ===================================

extension EditProfileVc: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && string == " "{
            
            return false
        }
        
        if string.containsEmoji {
            return false
        }
        
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 30 // Bool
        
    }
}


//MARK:- UIImage pickerview delegate Methods
//MARK:- ===================================

extension EditProfileVc :UIImagePickerControllerDelegate , UIAlertViewDelegate , UINavigationControllerDelegate , UIPopoverControllerDelegate {
    
    
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
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            
        }else{
            
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
                
                picker.sourceType = UIImagePickerControllerSourceType.camera
                
                picker.allowsEditing = true
                
                self.present(picker, animated: true, completion: nil)
                
            }else{
                
                openGallary()
            }
            
        case .denied, .restricted:
            
            alertToEncourageCameraAccessWhenApplicationStarts()
            
        default: break
            
        }
        
    }
    
    
    
    func openGallary() {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
            
        }else{
            
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        self.selectedImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        
        self.userImageView.image = self.selectedImage
        
        showLoader()
        
        self.uploadTOS3Image(index: 1, image: self.selectedImage!)
        
    }
    
}



//MARK:- Upload image on S3 Server
//MARK:- ===================================


extension EditProfileVc{
    
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
            
            hideLoader()
            
        }
        
        let url = NSURL(fileURLWithPath: path)
        
        let uploadRequest           = AWSS3TransferManagerUploadRequest()
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
                    
                    self.imageUrl = url
                    
                    self.isUpload = true
                    
                    hideLoader()
                })
            }
            
            return "" as AnyObject
        })
    }
}
