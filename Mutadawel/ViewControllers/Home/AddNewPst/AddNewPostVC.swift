//
//  AddNewPostVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Photos

enum AddPostType {
    
    case General , Forcast,  Condition
    
}

enum ChooseExpextType{
    
    case Stock , Forex
    
}

enum ChooseTimeType{
    
    case From , To, Within1, Within2
    
}

enum BuySellType{
    
    case Buy , Sell
    
}

enum PopUpType{
    
    case Market , Sell, TypeName
    
}
enum WithinCondition{
    
    case Within1 , Within2
    
}



class AddNewPostVC: MutadawelBaseVC {
    
    //MARK:- IBOutlets
    //MARK:- ====================================
    
    @IBOutlet weak var currentPriceLabel: UILabel!
	
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var addPostTableView: UITableView!
    @IBOutlet weak var selectPostTypeBGView: UIView!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var expectView: UIView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var generalLbl: UILabel!
    @IBOutlet weak var generalImg: UIImageView!
    @IBOutlet weak var generalBtn: UIButton!
    @IBOutlet weak var expectBtn: UIButton!
    @IBOutlet weak var expectImg: UIImageView!
    @IBOutlet weak var expectLbl: UILabel!
    @IBOutlet weak var conditionImg: UIImageView!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var conditionBtn: UIButton!
    @IBOutlet weak var chooseExpectBgView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var stockBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var forexBtn: UIButton!
    
    @IBOutlet weak var datePickerPopUpView: UIView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lonTermBtn: UIButton!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet var dropDownView: UIView!
    
    let eventId = "add new post"
    
    var errorFlag = 0
	
	
    //MARK:- Properties
    //MARK:- ====================================

	var percentageForExpectation :Double  = 1.24;
	
    var addPostType = AddPostType.Forcast
//    var chooseExpect = ChooseExpextType.Stock
    var selectedImage : UIImage?
    var picker:UIImagePickerController? = UIImagePickerController()
    var forecastDetail = JSONDictionary()
    var chooseTimeType = ChooseTimeType.From
    var buy_sell = BuySellType.Buy
    var popUp_type = PopUpType.Market
    var within_type = WithinCondition.Within1
    var isUpload = false
    var forcastPriceDetail = ForexPriceAPIModel()
    var delegate : TimeLineDelegate!
    
    
    //MARK:- View life cycle
    //MARK:- ====================================

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification:Notification!) -> Void in
            
            self.view.addGestureRecognizer(tapGesture)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { _ in
                                                
                self.view.removeGestureRecognizer(tapGesture)
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        self.hideDatePicker()
        self.addPostTableView.reloadData()
        self.view.endEditing(true)
//        if let view = touches.first?.view {
//            if view == self.chooseExpectBgView && !self.chooseExpectBgView.subviews.contains(view) {
//                self.hideDatePicker()
//                self.addPostTableView.reloadData()
//            }
//        }
    }
    
    //MARK:- IBActions
    //MARK:- =====================================================
    
    @IBAction func crossBtnTapped(_ sender: UIButton) {
        
        sharedAppdelegate.nvc.popViewController(animated: true)
        
    }
    
    @IBAction func generalBtnTaaped(_ sender: UIButton) {
        self.dropDownView.removeFromSuperview()

        self.datePicker.minimumDate = Date()
        self.forecastDetail.removeAll()
        self.addPostType = .General
        self.generalLbl.textColor = AppColor.appButtonColor
        self.generalImg.image = UIImage(named: "ic_add_new_post_general_select")
        self.expectLbl.textColor = UIColor.darkGray
        self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_deselect")
        self.conditionLbl.textColor = UIColor.darkGray
        self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_deselect")
        self.addPostTableView.reloadData()
    }
    
    @IBAction func expectBtnTaaped(_ sender: UIButton) {
        
        self.dropDownView.removeFromSuperview()
        self.addPostType = .Forcast
        self.selectedImage = nil
        self.datePicker.minimumDate = Date()
        self.forecastDetail.removeAll()
        self.generalLbl.textColor = UIColor.darkGray
        self.generalImg.image = UIImage(named: "ic_add_new_post_general_deselect")
        self.expectLbl.textColor = AppColor.appButtonColor
        self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_select")
        self.conditionLbl.textColor = UIColor.darkGray
        self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_deselect")
        self.hideDatePicker()
        self.addPostTableView.reloadData()

    }
    
    @IBAction func conditionBtnTaaped(_ sender: UIButton) {
        self.dropDownView.removeFromSuperview()

        self.datePicker.minimumDate = Date()
        self.addPostType = .Condition
        self.selectedImage = nil
        self.forecastDetail.removeAll()
        self.generalLbl.textColor = UIColor.darkGray
        self.generalImg.image = UIImage(named: "ic_add_new_post_general_deselect")
        self.expectLbl.textColor = UIColor.darkGray
        self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_deselect")
        self.conditionLbl.textColor = AppColor.appButtonColor
        self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_select")
        self.hideDatePicker()
        self.addPostTableView.reloadData()

    }
    
    
    
    @IBAction func stockBtnTapped(_ sender: UIButton) {
        
            self.forecastDetail.removeAll()
            if self.addPostType == .Forcast{
                self.generalLbl.textColor = UIColor.darkGray
                self.generalImg.image = UIImage(named: "ic_add_new_post_general_deselect")
                self.expectLbl.textColor = AppColor.appButtonColor
                self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_select")
                self.conditionLbl.textColor = UIColor.darkGray
                self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_deselect")
            }else if self.addPostType == .Condition{
                self.generalLbl.textColor = UIColor.darkGray
                self.generalImg.image = UIImage(named: "ic_add_new_post_general_deselect")
                self.expectLbl.textColor = UIColor.darkGray
                self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_deselect")
                self.conditionLbl.textColor = AppColor.appButtonColor
                self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_select")
            }
        
        self.hideDatePicker()
        self.addPostTableView.reloadData()
        
    }
    
    
    @IBAction func forexBtnTapped(_ sender: UIButton) {
        
        self.forecastDetail.removeAll()
        if self.addPostType == .Forcast{
            self.generalLbl.textColor = UIColor.darkGray
            self.generalImg.image = UIImage(named: "ic_add_new_post_general_deselect")
            self.expectLbl.textColor = AppColor.appButtonColor
            self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_select")
            self.conditionLbl.textColor = UIColor.darkGray
            self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_deselect")
        }else if self.addPostType == .Condition{
            self.generalLbl.textColor = UIColor.darkGray
            self.generalImg.image = UIImage(named: "ic_add_new_post_general_deselect")
            self.expectLbl.textColor = UIColor.darkGray
            self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_deselect")
            self.conditionLbl.textColor = AppColor.appButtonColor
            self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_select")
        }
        self.forecastDetail["buy_sell"] = BUY.localized as AnyObject
        self.forecastDetail["buyOrsell"] = 1 as AnyObject

        self.hideDatePicker()
        self.addPostTableView.reloadData()
    }
    
    
    @IBAction func photoBtnTap(_ sender: UIButton) {
        
        self.OpenActionSheet(sender: sender)
    }
    
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        
        self.selectFromToTime()
        self.hideDatePicker()
        
    }
    
    
    @IBAction func shortTermBtnTapped(_ sender: UIButton) {
        
        self.dropDownView.removeFromSuperview()
        if self.popUp_type == .TypeName{
            self.forecastDetail["type"] = 1 as AnyObject
            self.forecastDetail["type_name"] = Short_Time.localized as AnyObject
        }else if self.popUp_type == .Sell{
            self.forecastDetail["buyOrsell"] = "1" as AnyObject
            self.buy_sell = .Buy
            if let ask = self.forecastDetail["Ask"]{
                self.forecastDetail["price"] = ask as AnyObject
            }
        }
        
        self.addPostTableView.reloadData()
    }
    
    
    
    @IBAction func LongTermBtnTapped(_ sender: UIButton) {
        
        self.dropDownView.removeFromSuperview()
        if self.popUp_type == .TypeName{
            self.forecastDetail["type"] = 2 as AnyObject
            forecastDetail["type_name"] = Long_Time.localized as AnyObject

        }else if self.popUp_type == .Sell{
            self.forecastDetail["buyOrsell"] = 2 as AnyObject
            self.buy_sell = .Sell
            if let bid = self.forecastDetail["Bid"]{
                self.forecastDetail["price"] = bid
            }
        }
        self.addPostTableView.reloadData()
        
        
    }
    

}

extension AddNewPostVC{
    
    func uploadTOS3Image(index:Int,image:UIImage) {
        
        //print_debug("index====\(index)===state=====\(state)===\(self.arraytype)")
        let BUCKET_NAME = "tridder"
        
        let name = "ios_\(Date().timeIntervalSince1970*1000)"
        let BUCKET_DIRECTORY = "ios/\(name).jpeg"
        let path = NSTemporaryDirectory().stringByAppendingPathComponent(path: name)
        let data = UIImageJPEGRepresentation(image, 0.3)
        
        do {
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print_debug(object:error)
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
            if let error = task.error as NSError?{
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch (errorCode) {
                        case .cancelled, .paused:
                            DispatchQueue.main.async(execute: { () -> Void in
                            })
                            break;
                            
                        default:
                            print_debug(object:"upload() failed: [\(error)]")
                            break;
                        }
                    } else {
                        print_debug(object:"upload() failed: [\(error)]")
                    }
                } else {
                    print_debug(object:"upload() failed: [\(error)]")
                }
            }
            if let exception = task.exception {
                print_debug(object:"upload() failed: [\(exception)]")
            }
            if task.result != nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let url = "https://s3-us-west-2.amazonaws.com/\(BUCKET_NAME)/\(BUCKET_DIRECTORY)"
                    self.forecastDetail["image"] = url as AnyObject
                    self.isUpload = true
                    hideLoader()
                })
            }
            return "" as AnyObject
        })
    }
}



//MARK:- =================================
//MARK:- Tableview cell Classes

class StockCell: UITableViewCell{
    
    @IBOutlet weak var currentPriceFixedLbl: UILabel!
    @IBOutlet weak var stockTextFiels: SkyFloatingLabelTextField!
    @IBOutlet weak var indicatorImg: UIImageView!
    
    @IBOutlet weak var stockPriceLbl: UILabel!
    @IBOutlet weak var stockPriceTextField: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.stockTextFiels.textAlignment = .right

        }else{
            
            self.stockTextFiels.textAlignment = .left

        }
        
        self.stockTextFiels.placeholder = STOCK.localized
        self.stockTextFiels.selectedTitle = STOCK.localized
        self.stockTextFiels.title = STOCK.localized
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stockTextFiels.placeholder = ""
        self.stockTextFiels.text = ""
        self.stockPriceLbl.text = " "
    }
}


class ExpectPriceCell: UITableViewCell{
    
    @IBOutlet weak var percentageArrow: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var durationBtn: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var durationIndicatorImg: UIImageView!
    @IBOutlet weak var donationIndicatoerUp: UIImageView!
    @IBOutlet weak var priceIndicatorImg: UIImageView!
    @IBOutlet weak var priceIndiUp: UIImageView!
	
	
	var info = JSONDictionary()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.durationTextField.textAlignment = .right
            self.priceTextField.textAlignment = .right
            
        }else{
            
            self.durationTextField.textAlignment = .left
            self.priceTextField.textAlignment = .left
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.durationTextField.placeholder = ""
        self.durationTextField.text = ""
        self.priceTextField.placeholder = ""
        self.priceTextField.text = ""
        
    }
	
	
	@IBAction func priceTextFieldChanging(_ sender: UITextField) {
		
			
		self.percentageLabel.setNeedsDisplay()
		
		
	}
	
	
}


class CommentCell: UITableViewCell{
    
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textView.text = nil
        
    }
    
}

class SendBtnCell: UITableViewCell{
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var sendbtn: UIButton!
    @IBOutlet weak var sendLbl: UILabel!
    @IBOutlet var sendImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sendbtn.isEnabled = false
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.sendLbl.textAlignment = .left
            self.sendImage.contentMode = .right
            self.sendImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        }else{
            
            self.sendLbl.textAlignment = .right
            self.sendImage.contentMode = .left

        }
        self.sendLbl.text = SEND.localized
    }
}



class ImageViewCell: UITableViewCell{
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var crossButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

