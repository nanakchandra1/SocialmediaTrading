//
//  MyStockListVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

enum otherUser{
    
    case yes
    case no
}

class MyStockListVC: MutadawelBaseVC {

    
    @IBOutlet weak var stockListTableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var stockListLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    var stockList = [MyStockListModel]()
    var OtherUser = otherUser.no
    var otherUserID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialSetup(){
    
        self.stockListTableView.delegate = self
        self.stockListTableView.dataSource = self
        self.stockListTableView.estimatedRowHeight = 100
        self.bgView.layer.cornerRadius = 3
        self.stockListLbl.text = MY_STOCK_LIST.localized
        self.closeBtn.setTitle(CLOSE.localized, for: UIControlState.normal)
        
        self.getMyStockList()
    }

    func getMyStockList(){
        
        var params = JSONDictionary()
        if OtherUser == otherUser.no{
            
            params["userId"] = CurrentUser.user_id as AnyObject?
            
        }else if OtherUser == otherUser.yes{
            
            params["userId"] = otherUserID as AnyObject?
        }
        showLoader()
        myStockListAPI(params: params) { (success, msg, data) in
            hideLoader()
            if success{
                print_debug(object: data!)
                
                self.stockList = data!.map({ (stock) -> MyStockListModel in
                    
                    MyStockListModel(withData: stock)
                })
            }
            
            self.stockListTableView.reloadData()

        }
    }

    @IBAction func closeBtnTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK:- TableView Delegate and datasource
//MARK:- =============================================

extension MyStockListVC: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockListCell", for: indexPath) as! StockListCell
        
        let data = self.stockList[indexPath.row]
        
        cell.popuLateCell(userInfo: data)
        cell.buyBtn.addTarget(self, action: #selector(buyBtnTapped), for: .touchUpInside)
        cell.sellBtn.addTarget(self, action: #selector(sellBtnTapped), for: .touchUpInside)
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
    
    
    func buyBtnTapped(_ sender: UIButton) {
        
        let cell = sender.tableViewCell() as! StockListCell
        guard let indexpath = self.stockListTableView.indexPath(for: cell) else {
            return
        }
        gotoTrade(stockInfo : self.stockList[indexpath.row])
        self.dismiss(animated: true, completion: nil)
        cell.buyBtn.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6745098039, blue: 0.9725490196, alpha: 1)
        cell.sellBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

    }
    
    func sellBtnTapped(_ sender: UIButton){
        
        let cell = sender.tableViewCell() as! StockListCell
        guard let indexpath = self.stockListTableView.indexPath(for: cell) else {
            return
        }
        gotoTrade(stockInfo : self.stockList[indexpath.row])
        self.dismiss(animated: true, completion: nil)
        cell.buyBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        cell.sellBtn.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6745098039, blue: 0.9725490196, alpha: 1)
    }
}
//MARK:- ===================================
//MARK:- tableview cell classes


class StockListCell: UITableViewCell {
    
    
    @IBOutlet weak var stockHolderName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var buyLbl: UILabel!
    @IBOutlet weak var currentPriceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var buySellBuy: UIView!
    @IBOutlet weak var sellBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var profitLostLbl: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buyLbl.text = BUY.localized
        self.currentPriceLbl.text = CURRENT_PRICE.localized
        self.quantityLbl.text = QUANTITY.localized
        self.profitLostLbl.text = PROFIT_AND_LOST.localized
        
        self.buyBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        self.sellBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

    }
    
    func popuLateCell(userInfo: MyStockListModel){
        
        
        if let stock_name = userInfo.stock_name {
            self.stockHolderName.text = STOCK.localized + " : " + "\(stock_name)"

        }
        
        if let date = userInfo.date {
            self.dateLbl.text = date
            
        }

        if let quantity = userInfo.quantity {
            self.quantityLbl.text = QUANTITY.localized + " : " + "\(quantity)"
        }
        
        if let profit_loss = userInfo.profit_loss {
            self.profitLostLbl.text = PROFIT_AND_LOST.localized + " : " + "\(abs(profit_loss))"
			
			if profit_loss > 0 {
				
				self.profitLostLbl.textColor = #colorLiteral(red: 0.1347165, green: 0.7058018718, blue: 0.2161980555, alpha: 1)
				
			}else if profit_loss < 0 {
			
				self.profitLostLbl.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
			}else{
				
				self.profitLostLbl.textColor = UIColor.gray
			}
        }
        
        if let current_price = userInfo.current_price {
            self.currentPriceLbl.text = CURRENT_PRICE.localized + " : " + "\(current_price)"
        }
        
        if let buy = userInfo.buy {
            self.buyLbl.text = BUY.localized + " : " + "\(buy)"
        }

        self.buyBtn.setTitle(BUY.localized, for: UIControlState.normal)
        self.sellBtn.setTitle(SELL.localized, for: UIControlState.normal)
        self.buyBtn.layer.cornerRadius = 2
        self.sellBtn.layer.cornerRadius = 2
        self.orLbl.text = OR.localized

    
    }
}
