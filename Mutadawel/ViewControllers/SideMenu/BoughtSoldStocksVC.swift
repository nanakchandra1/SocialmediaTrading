//
//  BoughtSoldStocksVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class BoughtSoldStocksVC: UIViewController {

    @IBOutlet weak var stockListTableView: UITableView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var stockList = [MyStockListModel]()
    var OtherUser = otherUser.no
    var otherUserID = ""
    var fromdate = ""
    var todate = ""
    var isSold = true
    var url = ""
    var currentPage = 0

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
        self.backBtn.rotateBackImage()
        
        if isSold{
            url = EndPoint.soldStockListURL
            self.navigationTitle.text = SOLD.localized
        }else{
            url = EndPoint.boughtStockListURL
            self.navigationTitle.text = BUYING_SUCCEEDED.localized
        }
        self.getMyStockList()
    }
    
    func getMyStockList(){
        
        var params = JSONDictionary()
        
        params["userId"] = otherUserID
        params["pageNumber"] = self.currentPage
        
        if self.currentPage == 0{
            
            showLoader()
            
        }
        myBoughtStockListAPI(params: params, url: self.url) { (success, msg, data) in
            
            hideLoader()
            if success{
                
                if !data!.isEmpty{
                    
                    if self.currentPage == 0{
                        
                        self.stockList = data!.map({ (posts) -> MyStockListModel in
                            MyStockListModel(withData: posts)
                        })

                    }else{
                        
                        for res in data!{
                            
                            let postData = MyStockListModel(withData: res)
                            self.stockList.append(postData)
                            
                        }
                    }

//                    self.stockList = data!
                    
                }
                
            }
            
            self.showNodata()
            self.stockListTableView.reloadData()
            
        }
    }
    
    
    func showNodata(){
        
        if self.stockList.isEmpty{
            
            self.stockListTableView.backgroundView = makeLbl(view: self.stockListTableView, msg: data_not_available.localized)
            self.stockListTableView.backgroundView?.isHidden = false
            
        }else{
            
            self.stockListTableView.backgroundView?.isHidden = true
        }
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        sharedAppdelegate.nvc.popViewController(animated: true)
    }


}


//MARK:- TableView Delegate and datasource
//MARK:- =============================================

extension BoughtSoldStocksVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoughtStockListCell", for: indexPath) as! BoughtStockListCell
        
        let data = self.stockList[indexPath.row]
        
        cell.popuLateCell(userInfo: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
            let endScrolling = scrollView.contentOffset.y + scrollView.contentSize.height
            if endScrolling > scrollView.contentSize.height {
                
                self.currentPage += 1
                
                //TODO:- becouse the the API send the same data that sent again
                self.getMyStockList()
                
            }
    }

}

//MARK:- ===================================
//MARK:- tableview cell classes


class BoughtStockListCell: UITableViewCell {
    
    
    @IBOutlet weak var stockHolderName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var buyLbl: UILabel!
    @IBOutlet weak var currentPriceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var profitLostLbl: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buyLbl.text = BUY.localized
        self.currentPriceLbl.text = CURRENT_PRICE.localized
        self.quantityLbl.text = QUANTITY.localized
        self.profitLostLbl.text = PROFIT_AND_LOST.localized
        self.selectionStyle = .none
        
    }
    
    func popuLateCell(userInfo: MyStockListModel){
        
        
        if let stock_name = userInfo.stock_name {
            self.stockHolderName.text = STOCK.localized + " : " + "\(stock_name)"
            
        }
        
        if let date = userInfo.soldDate {
            self.dateLbl.text = date
            
        }
        
        if let quantity = userInfo.amount {
            self.quantityLbl.text = TOTAL.localized + " : " + "\(quantity)"
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
        
        if let current_price = userInfo.price {
            self.buyLbl.text = PRICE.localized + " : " + "\(current_price)"
        }
        
        if let buy = userInfo.quantity {
            self.currentPriceLbl.text = QUANTITY.localized + " : " + "\(buy)"
        }
        
        self.profitLostLbl.isHidden = true
        
    }
}
