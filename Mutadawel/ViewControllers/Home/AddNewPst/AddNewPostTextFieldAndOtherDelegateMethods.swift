//
//  AddNewPostTextFieldAndOtherDelegateMethods.swift
//  Mutadawel
//
//  Created by Appinventiv on 18/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import AVFoundation
import Photos


//MARK:- UITextfield delegate datasource
//MARK:- =====================================================

extension AddNewPostVC: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let indexPath = textField.tableViewIndexPath(tableView: self.addPostTableView) else {
            return false
        }
        
        if isValidNumber(str: string){
            return false
        }
        
        delayWithSeconds(0.01) {
            
            if self.addPostType == .Forcast{
                
                //                if self.chooseExpect == .Stock{
                
                if indexPath.row == 0{
                    
                    self.forecastDetail["stock"]  = textField.text as AnyObject
                }
                    
                else if indexPath.row == 1{
                    
                    if let expectCell = textField.tableViewCell() as? ExpectPriceCell {
                        
                        if textField === expectCell.durationTextField{
                            
                            self.forecastDetail["duration"] = textField.text as AnyObject
                            
                        }else{
                            
                            if textField.tag == 100{
                                
                                //=================
                                var precentage2 = ""
                                
                                if string.isEmpty
                                {
                                    precentage2 = String(textField.text!.characters.dropLast())
                                }
                                else
                                {
                                    precentage2 = textField.text!+string
                                }
                                
                                if precentage2.characters.count > 5{
                                    
                                    self.forecastDetail["forecast_price"] = textField.text as AnyObject
                                    self.forecastDetail["price"] = textField.text as AnyObject
                                    self.addPostTableView.reloadData()
                                    
                                }else{
                                    
                                    self.forecastDetail["forecast_price"] = textField.text as AnyObject
                                    self.forecastDetail["price"] = textField.text as AnyObject
                                    
                                }
                            }
                        }
                    }
                }
                
            } else {
                
                switch indexPath.row {
                    
                case 0:
                    
                    self.forecastDetail["stock"]  = textField.text as AnyObject
                    
                case 1,2:
                    
                    if let expectCell = textField.tableViewCell() as? ExpectPriceCell{
                        if indexPath.row == 1{
                            
                            if textField === expectCell.durationTextField{
                                self.forecastDetail["condition1"] = textField.text as AnyObject
                                
                            }
                        }else{
                            
                            if textField === expectCell.durationTextField{
                                self.forecastDetail["condition2"] = textField.text as AnyObject
                                
                            }
                        }
                    }
                    
                default:
                    fatalError("textField delegate")
                }
            }
        }
        return true
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 100{
            
            self.forecastDetail["forecast_price"] = textField.text as AnyObject?
            
            self.addPostTableView.reloadData()
        }
        
    }
    
    
}


//MARK:- UITextView delegate
//MARK:- =====================================================

extension AddNewPostVC: UITextViewDelegate{
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location == 0 && text == " " {
            
            return false
        }
        
        delayWithSeconds(0.01) {
            
            self.forecastDetail["caption"] = textView.text as AnyObject
            
        }
        
        if self.addPostType == .General{
            
            if textView.text.count > 300{
                
                return false
            }else{
                return true
            }
        }else{
            
            if textView.text.count > 150{
                
                return false
            }else{
                return true
            }
        }
    }
}



//MARK:- UIImagePicker delegate
//MARK:- =====================================================


extension AddNewPostVC :UIImagePickerControllerDelegate , UIAlertViewDelegate , UINavigationControllerDelegate , UIPopoverControllerDelegate {
    
    
    func OpenActionSheet(sender : UIButton){
        
        let alert:UIAlertController = UIAlertController(title: CHOOSE_IMAGE.localized, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: CAMERA.localized, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openCamera()
            setEvent(eventName: FirebaseEventName.camera_click, params: ["eventId": self.eventId as NSObject])
            
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
        
        let settingsAction = UIAlertAction(title: SETTINGS.localized , style: .destructive) { (_) -> Void in
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
    func alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
    {
        //Photo Library not available - Alert
        let cameraUnavailableAlertController = UIAlertController (title: Photo_Library_Unavailable.localized, message: Please_check_to_see_if_device_settings_does_not_allow_photo_library_access.localized, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: SETTINGS.localized, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url as URL)
            }
        }
        let cancelAction = UIAlertAction(title: OKAY.localized , style: .default, handler: nil)
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
        showLoader()
        self.addPostTableView.reloadData()
        self.uploadTOS3Image(index: 1, image: self.selectedImage!)
    }
}

//MARK:- Stocklist delegate
//MARK:- =====================================================

extension AddNewPostVC: SetStockDelegate{
    
    func setStock(info: AllStockListModel) {
        
        self.forecastDetail["stock_id"]  =  info.stock_id ?? ""
        self.forecastDetail["symbol"] = info.symbol
        self.forecastDetail["stock"]  = info.name
        
        getStockPrice()
        
        self.addPostTableView.reloadData()
    }
    
    func getStockPrice(){
        
        var params = JSONDictionary()
        
        if let symbol =  self.forecastDetail["symbol"] {
            
            params["stockSymbol"] = symbol as AnyObject?
            params["stockId"] = self.forecastDetail["stock_id"] as AnyObject?
            
        }
        
        
        
        showLoader()
        
        //MARK: stockPriceAPI
        
        stockPriceAPI(params: params) { (success, msg , data) in
            
            hideLoader()
            
            if success{
                
                
                print_debug(object: data)
                
                guard let current = data?["current"] else {return}
                
                let c_price = current.doubleValue.roundTo(places: 4)
                
                self.forecastDetail["stock_price"]  = "\(String(describing: c_price))" as AnyObject?
                self.addPostTableView.reloadData()
                
            }
        }
    }
    
}
