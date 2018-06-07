//
//  SubscriptionVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SubscriptionVC: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cashTypeLbl: UILabel!
    @IBOutlet weak var cashvalueLbl: UILabel!
    @IBOutlet weak var stockLbl: UILabel!
    @IBOutlet weak var stockValueLbl: UILabel!
    @IBOutlet weak var addMoneyLbl: UIButton!
    @IBOutlet weak var addMoreMoneyBgView: UIView!
    @IBOutlet weak var addMoneyPopUpView: UIView!
    @IBOutlet weak var addMoreMoneyLbl: UILabel!
    @IBOutlet weak var payToLbl: UILabel!
    @IBOutlet weak var paidAmountLbl: SkyFloatingLabelTextField!
    @IBOutlet weak var showAmntLbl: UILabel!
    @IBOutlet weak var payMentBtn: UIButton!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var myDonationView: UIView!
    @IBOutlet weak var myDonationLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var donationBtn: UIButton!
    
    var sideMenuState = ProfileState.None
    var walletInfo = MyWalletModel()
    var pickOption:[Double] = [10, 20, 30, 50, 100, 300, 500]
    var walletAmount:Double = 0
    var selectedAmount:Double = 0
    var coins:Double = 0
    let eventId = "wallet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.cashTypeLbl.textAlignment = .left
            self.stockLbl.textAlignment = .left
            self.paidAmountLbl.textAlignment = .right
            
        }else{
            
            self.cashTypeLbl.textAlignment = .right
            self.stockLbl.textAlignment = .right
            self.paidAmountLbl.textAlignment = .left
            
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if let view = touches.first?.view {
            if view == self.addMoreMoneyBgView && !self.addMoreMoneyBgView.subviews.contains(view) {
                self.addMoreMoneyBgView.isHidden = true
            }
        }
    }

    
    private func initialSetup(){
        
        self.descriptionLbl.text =  Waalet_dummy_text.localized
        self.navigationTitle.font = setNavigationTitleFont()
        self.addMoneyPopUpView.layer.cornerRadius = 3
        self.payMentBtn.layer.cornerRadius = 2
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.addMoreMoneyBgView.isHidden = true
        self.stockValueLbl.text = ""
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.showsSelectionIndicator = true
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
       // pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: 150, height: 175))
        pickerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.paidAmountLbl.inputView = pickerView
        self.paidAmountLbl.inputAccessoryView = toolBar

        
        
        if self.sideMenuState == .SideMenu{
        
            self.backBtn.setImage(ButtonImg.burgerBtn, for: UIControlState.normal)
            
        }else{
            
            if sharedAppdelegate.appLanguage == .Arabic{
                self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            }else{
                self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back"), for: .normal)
            }
        }
        self.navigationTitle.text = WALLET.localized
        self.cashTypeLbl.text = CASH.localized
        self.stockLbl.text = STOCKS.localized
        self.addMoneyLbl.setTitle(ADD_MORE_MONEY.localized, for: .normal)
        self.myDonationLbl.text = MY_DONATION.localized
        self.payToLbl.text = PAY_TO.localized
        self.payMentBtn.setTitle(PAYMENT_BTN.localized, for: .normal)
        self.addMoreMoneyLbl.text = ADD_MORE_MONEY.localized
        self.getUserWallet()
        
    }

    
    
    func getUserWallet(){
		
            var params = JSONDictionary()
        
            params["userId"] = CurrentUser.user_id as AnyObject?
        
            showLoader()
        
            walletAPI(params: params) { (success, msg, data) in
                
                hideLoader()
                if success{
                    
                    self.walletInfo = MyWalletModel(withData: data!)
                    
                    if let cash = self.walletInfo.cash {
                        
                        self.walletAmount = cash
                        self.cashvalueLbl.text = "SR \(cash)"

                    }
                    if let stock = self.walletInfo.stock{
                        
                        self.stockValueLbl.text = "SR \(stock)"
                        
                    }
                    
                    if let coins = self.walletInfo.coins{
                        
                        self.coins = coins
                        let amount = coins * self.pickOption[0]
                        self.selectedAmount = amount
                        self.showAmntLbl.text = "\(VERSUS.localized) SR \(amount)"
                        
                }
                    if let total_donation = self.walletInfo.total_donation {
                        
                        self.amountLbl.text = "SR \(total_donation)"
                        
                    }
            }
        }
    }
    
    
    func addMoreMoney(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id as AnyObject?
        params["amount"] = self.selectedAmount as AnyObject?

        showLoader()
        
        addMoreMoneyAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                self.addMoreMoneyBgView.isHidden = true

                self.walletAmount = self.walletAmount + self.selectedAmount
                
                self.cashvalueLbl.text = "SR \(self.walletAmount)"
                
                if let coins = self.walletInfo.coins{
                    self.coins = coins
                    let amount = coins * self.pickOption[0]
                    self.selectedAmount = 0
                    self.showAmntLbl.text = "\(VERSUS.localized) SR \(amount)"
                    
                }

                showToastWithMessage(msg: msg)
        
            }
        }
    }

    
    func donePicker() {
        
        _  = self.paidAmountLbl.resignFirstResponder()
        
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if sideMenuState == .None{
            
            _ = self.navigationController?.popViewController(animated: true)

        }else{
            
            if sharedAppdelegate.appLanguage == .English{
                
                openLeft()
                
            }else{
                
                openRight()
                
            }
        }
    }

    @IBAction func addMoneyTapped(_ sender: UIButton) {
        
        showToastWithMessage(msg: coming_soon.localized)

//        self.paidAmountLbl.text = "SR \(self.pickOption[0])"
//        let amount = self.coins * self.pickOption[0]
//        self.selectedAmount = amount
//        self.showAmntLbl.text = "\(VERSUS.localized) SR \(amount)"
//        self.addMoreMoneyBgView.isHidden = false

    }

    @IBAction func stockTapped(_ sender: UIButton) {
		
        setEvent(eventName: FirebaseEventName.click_on_stock, params: ["eventId": self.eventId as NSObject])

        let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyStockListID") as! MyStockListVC
		
        popUp.modalPresentationStyle = .overCurrentContext
		
        self.present(popUp, animated: true, completion: nil)

    }
    
    @IBAction func payMentBtnTapped(_ sender: UIButton) {
        
        showToastWithMessage(msg: coming_soon.localized)
        setEvent(eventName: FirebaseEventName.click_on_add_more_money, params: ["eventId": self.eventId as NSObject])

        //self.addMoreMoney()

    }
    
    
    @IBAction func payToTapped(_ sender: UIButton) {
        
        
    }

    
    @IBAction func donationBtnTapped(_ sender: UIButton) {
        showToastWithMessage(msg: coming_soon.localized)

        setEvent(eventName: FirebaseEventName.click_on_my_donation, params: ["eventId": self.eventId as NSObject])

//        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "DonationListID") as! DonationListVC
//        
//        popUp.modalPresentationStyle = .overCurrentContext
//        
//        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
        
    }
    
}

extension SubscriptionVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return pickOption[row]
    //    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?  {
        let titleData = "SR \(pickOption[row])"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont.init(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        return myTitle
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        self.paidAmountLbl.text = "SR \(pickOption[row])"
        
        if let coins = self.walletInfo.coins{
            
            let amount = coins * pickOption[row]
            
            self.selectedAmount = amount

            self.showAmntLbl.text = "\(VERSUS.localized) SR \(amount)"
            
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        
        return 200
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        
        return 35
        
    }
}
