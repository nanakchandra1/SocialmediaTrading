//
//  PriceIndicatorVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class PriceIndicatorVC: MutadawelBaseVC {
    
    @IBOutlet weak var currentPriceValueLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var stockNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var quntityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var indexNameSelectBtn: UIButton!
    @IBOutlet weak var showPriceIndicatorBtn: UIButton!
    
    let eventId = "price indicator"
    
    var priceIndicatorInfo = StringDictionary()
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
        
        descriptionLbl.text = Price_Indicator_dummy_text.localized
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.submitBtn.layer.cornerRadius = 2
        self.submitBtn.layer.shadowOpacity = 0.3
        self.submitBtn.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.submitBtn.layer.shadowRadius = 1.2
        self.stockNameTextField.delegate = self
        self.quntityTextField.delegate = self
        self.quntityTextField.keyboardType = .decimalPad
        self.showPriceIndicatorBtn.layer.cornerRadius = 2
        self.showPriceIndicatorBtn.layer.borderWidth = 3
        self.showPriceIndicatorBtn.layer.borderColor = self.submitBtn.layer.backgroundColor
        
        self.showPriceIndicatorBtn.setTitle("\(CURRENT_PRICE_INDICATOR.localized) \(LIST.localized)", for: .normal)
        
        if sharedAppdelegate.appLanguage == .Arabic
        {
            self.showPriceIndicatorBtn.setTitle("\(LIST.localized) \(CURRENT_PRICE_INDICATOR.localized)", for: .normal)
            self.stockNameTextField.textAlignment = .right
            self.quntityTextField.textAlignment = .right
            
            
        }else{
            
            self.showPriceIndicatorBtn.setTitle("\(CURRENT_PRICE_INDICATOR.localized) \(LIST.localized)", for: .normal)
            self.stockNameTextField.textAlignment = .left
            self.quntityTextField.textAlignment = .left
            
        }
        self.navigationTitle.text = PRICE_INDICATOR.localized
        self.submitBtn.setTitle(SUBMIT_BTN.localized, for: UIControlState.normal)
        self.stockNameTextField.placeholder = STOCK.localized
        self.quntityTextField.placeholder = PRICE.localized
        
    }
    
    
    
    @IBAction func stockBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "ListPopUpID") as! ListPopUpVC
        obj.delegate = self
        obj.markerType = .Stock
        obj.modalPresentationStyle = .overCurrentContext
        self.present(obj, animated: true, completion: nil)
        
    }
    
    @IBAction func currentPriceIndicator(_ sender: Any) {
        
        //showToastWithMessage(msg: "\(coming_soon.localized)")
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "currentPriceIndicatorID") as! currentPriceIndicatorVC
        
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if sharedAppdelegate.appLanguage == .English{
            openLeft()
        }else{
            openRight()
        }
        
        //_ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        guard let stock_id = self.priceIndicatorInfo["stock_id"] else{
            sharedAppdelegate.nvc.view.makeToast(Please_select_stock.localized)
            setEvent(eventName: FirebaseEventName.choose_stock_error, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        guard let symbol = self.priceIndicatorInfo["symbol"] else{
            sharedAppdelegate.nvc.view.makeToast(Please_select_stock.localized)
            return
        }
        guard let price = self.priceIndicatorInfo["price"] else{
            setEvent(eventName: FirebaseEventName.pleasea_choose_price_error, params: ["eventId": self.eventId as NSObject])
            
            sharedAppdelegate.nvc.view.makeToast(Please_add_a_price.localized)
            return
        }
        var params = JSONDictionary()
        params["stockId"] = stock_id
        params["symbol"] = symbol
        params["userId"] = CurrentUser.user_id!
        params["price"] = price 
        print_debug(object: params)
        showLoader()
        priceIndicatorAPI(params: params) { (success, msg, data) in
            hideLoader()
            if success{
                setEvent(eventName: FirebaseEventName.successful_submit, params: ["eventId": self.eventId as NSObject])
                
                //self.stockNameTextField.text = ""
                self.quntityTextField.text = ""
                showToastWithMessage(msg: price_indicator_success.localized)
                self.priceIndicatorInfo.removeAll()
            }
        }
    }
    
    
}



//MARK:- UITextfield delegate methods
//MARK:- ===========================

extension PriceIndicatorVC: SetStockDelegate{
    
    func setStock(info: AllStockListModel) {
        
        self.priceIndicatorInfo["stock"]  = info.name
        self.stockNameTextField.text = info.name
        if let id = info.stock_id{
            self.priceIndicatorInfo["stock_id"]  =  "\(id)"
        }
        
        if let symbol = info.symbol{
            self.priceIndicatorInfo["symbol"]  =  symbol
        }
        getStockPrice()
    }
    
    
    func getStockPrice(){
        
        var params = JSONDictionary()
        
        if let symbol =  self.priceIndicatorInfo["symbol"] {
            
            params["stockSymbol"] = symbol 
            params["stockId"] = self.priceIndicatorInfo["stock_id"]
            
        }
        
        
        
        showLoader()
        
        stockPriceAPI(params: params) { (success, msg , data) in
            
            hideLoader()
            
            if success{
                
                
                print_debug(object: data)
                
                guard let current = data?["current"] else {return}
                
                let c_price = current.doubleValue.roundTo(places: 4)
                self.currentPriceLabel.text = CURRENT_PRICE.localized
                self.currentPriceLabel.isHidden = false
                self.currentPriceValueLabel.isHidden = false
                self.currentPriceValueLabel.text  = "SR \(String(describing: c_price))"
                
                
                // self.stockpr.text = "SR \(String(describing: c_price))"
                //
                //                self.tradeDetail["current"] = "\(current)" as AnyObject?
                //
                //                guard let previous_price = data?["previous_price"] else{return}
                //
                //                self.tradeDetail["previous_price"] = "\(previous_price)" as AnyObject?
                //
                //                let delta = Double("\(current)")! - Double("\(previous_price)")!
                //
                //                let deltaPercentage = ((delta / 100 ) * Double("\(current)")!)
                //
                //                if delta >= 0 {
                //
                //                    self.stockPercentLbl.text = "SR \(delta.roundTo(places: 4))(\(deltaPercentage.roundTo(places: 4))%)"
                //
                //                    self.stockBtn.setImage(#imageLiteral(resourceName: "ic_home_uparrow"), for: .normal)
                //
                //
                //                }else{
                //
                //                    self.stockPercentLbl.text = "SR \(delta.roundTo(places: 4))(\(-deltaPercentage.roundTo(places: 4))%)"
                //                    
                //                    self.stockBtn.setImage(#imageLiteral(resourceName: "ic_home_downarrow"), for: .normal)
                //                }
            }
        }
    }
}


//MARK:- UITextfield delegate methods
//MARK:- ===========================

extension PriceIndicatorVC: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isValidNumber(str: string){
            return false
        }
        if (range.location == 0) && (string == " "){
            return false
        }
        delayWithSeconds(0.01) {
            if textField === self.quntityTextField{
                self.priceIndicatorInfo["price"] = textField.text
            }
        }
        return true
    }
}

