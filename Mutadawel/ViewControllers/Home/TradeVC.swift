//
//  TradeVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON


class TradeVC: MutadawelBaseVC {

    //MARK:- IBOutlets
    //MARK:- =================================
    @IBOutlet weak var stocksView: UIView!
    @IBOutlet weak var cashView: UIView!
	@IBOutlet weak var stocksLable: UILabel!
	@IBOutlet weak var cashLable: UILabel!
    @IBOutlet weak var currentStocksValueLbl: UILabel!
    @IBOutlet weak var availableCashLabel: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var stockNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var byeBtn: UIButton!
    @IBOutlet weak var bankSepraterView: UIView!
    @IBOutlet weak var sellBtn: UIButton!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var stockRateLbl: UILabel!
    @IBOutlet weak var stockPercentLbl: UILabel!
    @IBOutlet weak var stockBtn: UIButton!
    @IBOutlet weak var quantityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var quantitySeperatorView: UIView!
    
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    //MARK:- Properties
    //MARK:- =================================
    
    var tradeDetail = MyStockListModel()
    var isStocks = false
	var stockPrice : Double = 0.00
	var eventId = "Trade"
    
    //MARK:- View life cycle
    //MARK:- =================================

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            if UIApplication.shared.statusBarFrame.height > 20{
                
                self.topConstraint.constant = 70
                
            }else{
                self.topConstraint.constant = 15
                
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        
    }
    
    
    //MARK:- Private methods
    //MARK:- =================================

    
    private func initialSetup(){
        
        self.descriptionLbl.text = Trade_dummy_text.localized
        self.quantityTextField.keyboardType = .decimalPad
        if sharedAppdelegate.appLanguage == .Arabic
        {
//            self.arrowImageView.image = #imageLiteral(resourceName: "ic_settings_backarrow")
            self.stockNameTextField.textAlignment = .right
            self.quantityTextField.textAlignment = .right
            self.stockRateLbl.textAlignment = .left
            
        }else{
            
//            self.arrowImageView.image = #imageLiteral(resourceName: "ic_settings_nextarrow")
            self.stockNameTextField.textAlignment = .left
            self.quantityTextField.textAlignment = .left
            self.stockRateLbl.textAlignment = .right
            
        }
        self.byeBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        self.sellBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        self.byeBtn.layer.cornerRadius = 2
        self.sellBtn.layer.cornerRadius = 2
        self.submitBtn.layer.cornerRadius = 2
        self.stockNameTextField.delegate = self
        self.quantityTextField.delegate = self
        self.byeBtn.setTitle(BUY.localized, for: UIControlState.normal)
        self.sellBtn.setTitle(SELL.localized, for: UIControlState.normal)
        self.submitBtn.setTitle(SUBMIT_BTN.localized, for: UIControlState.normal)
        self.stockNameTextField.placeholder = STOCK.localized
        self.quantityTextField.placeholder = QUANTITY_NO.localized
        self.orLabel.text = OR.localized
        
        self.stockPercentLbl.text = "0.00(0.00%)"
        self.stockRateLbl.text = "SR 0"
        
        print_debug(object: self.tradeDetail)
        
        if let stock_name = self.tradeDetail.stock_name {
            
            self.stockNameTextField.text = "\(stock_name)"
            
        }
        if let quantity = self.tradeDetail.quantity {
            
            self.quantityTextField.text = "\(quantity)"
            
        }
        if let current_price = self.tradeDetail.current_price {
            
            self.stockRateLbl.text = "\(current_price)SR"
            
        }
        if self.isStocks{
            self.getStockPrice()
        }
        self.rateView.dropShadow()

		self.stocksLable.text = STOCKS.localized
		self.cashLable.text = CASH.localized
		
        getUserWallet()
        shadowView(myView:cashView);
        shadowView(myView:stocksView);
    }
	func shadowView(myView:UIView){
    //    let shadowSize : CGFloat = 5.0
        
    //    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
//                                                   y: -shadowSize / 2,
//                                                   width: myView.frame.size.width + shadowSize,
//                                                   height: myView.frame.size.height + shadowSize))
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowPath = UIBezierPath(rect: myView.bounds).cgPath
        myView.layer.shadowOpacity = 0.5
		
      //  myView.layer.shadowPath = shadowPath.cgPath
        
//        myView.layer.shadowColor = UIColor.gray.cgColor;
//        myView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        myView.layer.shadowOpacity = 1;
//        myView.layer.shadowRadius = 0.5;
    }
    
    func getUserWallet(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
      //  showLoader()
        
        walletAPI(params: params) { (success, msg, data) in
            
            if success{
                
                let wallet = UserWalletModel(withData: data!)
                
                if let cash = wallet.cash{
                    
                    self.availableCashLabel.text = "SR \(cash)"
                    
                }
                if let stock = wallet.stock{
                    
                    self.currentStocksValueLbl.text = "SR \(stock)"
                    
                }
                
                
            }
        }
    }
    
    func showAlert(msg: String){
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: No.localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Yes.localized, style: .default, handler: { (UIAlertAction) in
            self.saveTrade()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveTrade(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        params["stockId"] = self.tradeDetail.stock_id
        params["quantity"] = self.tradeDetail.quantity
        params["currentPrice"] = self.tradeDetail.current_price ?? ""
        params["stockSymbol"] = self.tradeDetail.symbol ?? ""
        
        guard let buy = self.tradeDetail.buyOrsell else{return}
        
        params["buyORsell"] = buy
        
        showLoader()
        saveTradeAPI(params: params) { (success, msg , data) in
            
            hideLoader()
            
            if success{
				
                self.getUserWallet()
				
                setEvent(eventName: FirebaseEventName.success_trade, params: ["eventId": "trade" as NSObject])
				
                if "\(buy)" == "1"{
					
                    showToastWithMessage(msg: Stock_has_been_bought_successfully.localized)

                    
                }else{
                    showToastWithMessage(msg: Stock_has_been_sold_successfully.localized)
                    
                }
                
                self.stockNameTextField.text = ""
                self.quantityTextField.text = ""
				self.stockPercentLbl.text = "0.00(0.00%)"
				self.stockRateLbl.text = "SR 0"
                self.sellBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                self.byeBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                self.tradeDetail = MyStockListModel()
                
            }else{
                
                showToastWithMessage(msg: msg)
                
            }
        }
		
		self.getUserWallet()
    }
    
    
    func getStockPrice(){
        
        var params = JSONDictionary()
        params["stockSymbol"] = self.tradeDetail.symbol ?? ""
        params["stockId"] = self.tradeDetail.stock_id ?? ""

        showLoader()
        
        stockPriceAPI(params: params) { (success, msg , data) in
            
            hideLoader()

            if success{
                
                let currentStockDetail = MyStockListModel(withData: data!)
                
//MARK: ========price teast=========
				//let c_price = 0.00
				self.stockPrice = currentStockDetail.current_price ?? 0
				
                self.stockRateLbl.text = "SR \(self.stockPrice)"
                
                self.tradeDetail.current_price = self.stockPrice
                
                self.tradeDetail.previous_price = currentStockDetail.previous_price ?? 0
                
                let delta = self.stockPrice - currentStockDetail.previous_price
                
                let deltaPercentage = ((delta / 100 ) * self.stockPrice)
                
                if delta >= 0 {
                    
                    self.stockPercentLbl.text = "SR \(delta.roundTo(places: 4))(\(deltaPercentage.roundTo(places: 4))%)"
                    
                    self.stockBtn.setImage(#imageLiteral(resourceName: "ic_home_uparrow"), for: .normal)
                    
                    
                }else{
                    
                    self.stockPercentLbl.text = "SR \(delta.roundTo(places: 4))(\(-deltaPercentage.roundTo(places: 4))%)"
                    
                    self.stockBtn.setImage(#imageLiteral(resourceName: "ic_home_downarrow"), for: .normal)
                }
            }
        }
    }
	
	
    
    //MARK:- IBActions
    //MARK:- =================================

	@IBAction func myStocksListBtn(_ sender: Any) {
		
		setEvent(eventName: FirebaseEventName.click_on_stock, params: ["eventId": self.eventId as NSObject])
		
		let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyStockListID") as! MyStockListVC
		
		popUp.modalPresentationStyle = .overCurrentContext
		
		self.present(popUp, animated: true, completion: nil)
		
	}
	
    @IBAction func stockBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "ListPopUpID") as! ListPopUpVC
        obj.delegate = self
        obj.markerType = .Stock
        obj.modalPresentationStyle = .overCurrentContext
        self.present(obj, animated: true, completion: nil)

    }
    
    
    @IBAction func biuyBtnTapped(_ sender: UIButton) {
		
		if stockPrice == 00.00 {
			showToastWithMessage(msg: message_for_trade_stock_price.localized)
		}else{
		
			self.view.endEditing(true)

			self.byeBtn.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6745098039, blue: 0.9725490196, alpha: 1)
        
			self.sellBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
			self.tradeDetail.buyOrsell = "1"
		}
    }
    
    
    @IBAction func sellBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)

        self.sellBtn.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6745098039, blue: 0.9725490196, alpha: 1)
        
        self.byeBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

        self.tradeDetail.buyOrsell = "2"
    }
    
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        guard let _ = self.tradeDetail.stock_id else{
            
            sharedAppdelegate.nvc.view.makeToast(Please_select_stock.localized)
            setEvent(eventName: FirebaseEventName.choose_stock_error, params: ["eventId": "trade" as NSObject])

            return
        }
        guard let _ = self.tradeDetail.quantity else{
            
            sharedAppdelegate.nvc.view.makeToast(Please_add_quantity.localized)
            setEvent(eventName: FirebaseEventName.choose_quantity_error, params: ["eventId": "trade" as NSObject])

            return
        }
        
        guard let buy_sell = self.tradeDetail.buyOrsell else{
            
            sharedAppdelegate.nvc.view.makeToast(Please_choose_buy_or_sell.localized)
            setEvent(eventName: FirebaseEventName.choose_by_or_sell_error, params: ["eventId": "trade" as NSObject])

            return
        }
        

        
            if "\(buy_sell)" == "1"{
                
                self.showAlert(msg: Are_you_sure_you_want_to_Buy_the_stock.localized)
                
            }else{
                
                self.showAlert(msg: Are_you_sure_you_want_to_Sell_the_stock.localized)
                
            }
		
		
	}
    
    
}


//MARK:- Set stock delegate methods
//MARK:- ===========================

extension TradeVC: SetStockDelegate{

    func setStock(info: AllStockListModel) {
        
        self.tradeDetail.stock  = info.name
                
        self.stockNameTextField.text = info.name ?? ""
        
        self.tradeDetail.stock_id  =  info.stock_id
        
        self.tradeDetail.symbol  =  info.symbol
        
        self.getStockPrice()

    }
}


//MARK:- UITextfield delegate methods
//MARK:- ===========================

extension TradeVC: UITextFieldDelegate{

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isValidNumber(str: string){
            
            return false
            
        }
        
        if ((range.location == 0) && (string == " ")) || ((range.location == 0) && (string == "0")){
            return false
        }
        
        delayWithSeconds(0.01) {
            if textField === self.quantityTextField{
                self.tradeDetail.quantity = Int(textField.text ?? "0") ?? 0
            }
        }
        
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        
        return newLength <= 8 // Bool

    }
}

