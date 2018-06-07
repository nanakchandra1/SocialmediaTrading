//
//  WalletNetValueVC.swift
//  Mutadawel
//
//  Created by MOMO on 9/21/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import GraphKit
import Charts

enum DateType {
	case From, To, Noun
}

class WalletNetValueVC: UIViewController {

	@IBOutlet weak var navigationView: UIView!
	@IBOutlet weak var backBtn: UIButton!
	@IBOutlet weak var graphContainer: UIView!
	@IBOutlet weak var walletNetValueLbl: UILabel!
	
	@IBOutlet weak var graph: LineChartView!
	//@IBOutlet weak var graph: GKLineGraph!
	
	@IBOutlet weak var datePickerView: UIView!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var datePickerDoneBtn: UIButton!
	
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var walletBalancLbl: UILabel!
	@IBOutlet weak var walletBalancValue: UILabel!
	@IBOutlet weak var totalSoldLbl: UILabel!
	@IBOutlet weak var totalSoldValue: UILabel!
	@IBOutlet weak var totalBoughtLbl: UILabel!
	@IBOutlet weak var totalBoughtValue: UILabel!
	
	@IBOutlet weak var fromDateView: UIView!
	@IBOutlet weak var toDateView: UIView!
	@IBOutlet weak var fromDateLbl: UILabel!
	@IBOutlet weak var toDateLbl: UILabel!
	@IBOutlet weak var fromDateBtn: UIButton!
	@IBOutlet weak var toDateBtn: UIButton!
	
	@IBOutlet weak var topOfTable: UIView!
	@IBOutlet weak var stockNameLbl: UILabel!
	@IBOutlet weak var topBoughtLbl: UILabel!
    @IBOutlet weak var topProfitLbl: UILabel!

	@IBOutlet weak var walletNetTableView: UITableView!
	
	@IBOutlet weak var leftFromDateConstraint: NSLayoutConstraint!
	
	var dateTybe = DateType.Noun
	var info = [Double]()
	var userID = ""
	var walletInfo = WalletInfoModel()
	var userInfo = WalletInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		initialViewSetup()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func initialViewSetup() {
		
		if sharedAppdelegate.appLanguage == .Arabic {
			
			let img = #imageLiteral(resourceName: "ic_sign_in_next")
			self.backBtn.setImage(img, for: .normal)
		}else{
			
			let img = #imageLiteral(resourceName: "ic_sign_in_back")
			self.backBtn.setImage(img, for: .normal)
		}
		
		self.walletNetValueLbl.text = "\(WALLET_NET_VALUE.localized)"
		self.walletBalancLbl.text = "\(WALLET_BALANCE.localized)"
		self.totalSoldLbl.text = "\(SOLD.localized)"
		self.totalBoughtLbl.text = "\(BOUGHT.localized)"
		self.stockNameLbl.text = "\(STOCK_NAME.localized)"
		self.topBoughtLbl.text = "\(BOUGHT.localized)"
        self.topProfitLbl.text = "\(PROFIT.localized)"

		
        let last3Month = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
		let fromDate = self.DateFormate(date: last3Month)
		let toDate = self.DateFormate(date: Date())
		
		self.fromDateLbl.text = " \(FROM.localized): \(fromDate)"
		self.toDateLbl.text = " \(TO.localized): \(toDate)"
		
		self.userInfo.fromDate = fromDate
		self.userInfo.toDate = toDate
		
		self.getWalletNetValue()
		
		self.walletNetTableView.delegate = self
		self.walletNetTableView.dataSource  = self
		
		self.datePickerView.layer.borderWidth = 2
		self.datePickerView.layer.borderColor = #colorLiteral(red: 0.3727298975, green: 0.485757947, blue: 0.5360805988, alpha: 1)
		self.datePickerDoneBtn.layer.borderColor = UIColor.black.cgColor
		self.datePickerDoneBtn.layer.borderWidth = 1
		
		self.navigationView.dropShadowGray()
		self.fromDateView.dropShadowGray()
		self.toDateView.dropShadowGray()
		self.headerView.dropShadowGray()
		self.topOfTable.dropShadowGray()
		
		self.topOfTable.layer.borderWidth = 0.5
		self.topOfTable.layer.borderColor = #colorLiteral(red: 0.3727298975, green: 0.485757947, blue: 0.5360805988, alpha: 1)
		
		self.leftFromDateConstraint.constant = (self.view.frame.size.width/2) - (244/2)
	}

	func setChart(dataPoints: JSONArray, values: JSONArray){
        guard !dataPoints.isEmpty && !values.isEmpty else {
            var dataEntries: [ChartDataEntry] = []
            
            
            let dataEntry = ChartDataEntry(x: 0, y: 0)
            dataEntries.append(dataEntry)
            
            let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Wallet Net Value")
            
            let lineChartData = LineChartData(dataSets: [lineChartDataSet])
            self.graph.data = lineChartData
            return
            
        }

        
		var dataEntries: [ChartDataEntry] = []
		
		for i in 0..<dataPoints.count{
			
			let dataEntry = ChartDataEntry(x: Double(i), y: values[i].doubleValue)
			dataEntries.append(dataEntry)
		}
        
		let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Wallet Net Value")
        
		let lineChartData = LineChartData(dataSets: [lineChartDataSet])
		self.graph.data = lineChartData
        
		lineChartDataSet.colors = [#colorLiteral(red: 0, green: 0.568627451, blue: 0.9176470588, alpha: 1)]
        lineChartDataSet.mode = LineChartDataSet.Mode.cubicBezier
		lineChartDataSet.drawCircleHoleEnabled = false
		lineChartDataSet.drawFilledEnabled = true
		lineChartDataSet.fillColor = UIColor.blue
        lineChartDataSet.valueTextColor = UIColor.white
        
	}
	
	func getWalletNetValue(){
		
		var params = JSONDictionary()
        
		params["userId"] = self.userID
        params["fromDate"] = self.userInfo.fromDate
        params["toDate"] = self.userInfo.toDate
        
		showLoader()
		
		walletNetValue(params: params) { (success, msg, data) in
			
			if success{
				
				self.walletInfo = WalletInfoModel(withData: data!)
				
				if let totalBought = self.walletInfo.totalBoughtAMount{
					
					self.totalBoughtValue.text = "\(totalBought.roundTo(places: 2)) SAR"
				}
				
				if let totalSold = self.walletInfo.totalSellAMount{
					
					self.totalSoldValue.text = "\(totalSold.roundTo(places: 2)) SAR"
				}
				
				if let totalWallet = self.walletInfo.walletnetValue{
					
					self.walletBalancValue.text = "\(totalWallet.roundTo(places: 2)) SAR"
				}
				
                self.setChart(dataPoints: self.walletInfo.label, values: self.walletInfo.values)
				self.walletNetTableView.reloadData()
				
			}else{
				showToastWithMessage(msg: msg)
			}
		}
	}
	
	func openAnimated() {
		
		let centerPoint = CGPoint(x: (self.view.frame.width/2) - (311/2), y:  250)
		
		let width = 311
		let height = 156
		
		let smallSize = CGSize(width: 0.0, height: 0.0)
		let originalSize = CGSize(width: width, height: height)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
			
			self.datePickerView.frame.origin = centerPoint
			self.datePickerView.frame.size = smallSize
			self.datePicker.isHidden = true
			
		}, completion: {(finished: Bool) -> Void in
			
			self.view.addSubview(self.datePickerView)
			
			UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
				
				self.datePickerView.frame.size = originalSize
				self.datePicker.isHidden = false
			}, completion: nil)
		})
	}
	
	func closeAnimated() {
		
		let width = 311
		let height = 156
		
		let smallSize = CGSize(width: 0.0, height: 0.0)
		let originalSize = CGSize(width: width, height: height)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
			
			self.datePickerView.frame.size = originalSize
			
		}, completion: {(finished: Bool) -> Void in
			
			UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
				
				self.datePickerView.frame.size = smallSize
				
			}, completion: nil)
		})
	}
	
	func DateFormate(date: Date) -> String{
		
		let dateFormater = DateFormatter()
		dateFormater.dateStyle = DateFormatter.Style.short
		dateFormater.locale = Locale(identifier: "en_DZ")
		dateFormater.dateFormat = "yyyy/MM/dd"
		let strDate = dateFormater.string(from: date)
		
		return strDate
	}
    
    func getDatefromString(withDate date: String) -> Date{
        
        let dateForematter = DateFormatter()
        dateForematter.dateFormat = "yyyy/MM/dd"
        let cur_date = dateForematter.date(from: date)
        return cur_date!
    }

	@IBAction func backBtnTapped(_ sender: Any) {
		
		_ = self.navigationController?.popViewController(animated: true)
	}

    @IBAction func formDateTapped(_ sender: Any) {
        
        self.dateTybe = DateType.From
        let fromDate = self.userInfo.fromDate ?? ""
        let toDate = self.userInfo.toDate ?? ""
        self.datePicker.date = self.getDatefromString(withDate: fromDate)
        self.datePicker.minimumDate = nil
        self.datePicker.maximumDate = self.getDatefromString(withDate: toDate)
        self.openAnimated()
    }
    
    
    @IBAction func toDateTapped(_ sender: Any) {
        
        self.dateTybe = DateType.To
        let toDate = self.userInfo.toDate ?? ""
        let fromDate = self.userInfo.fromDate ?? ""
        self.datePicker.minimumDate = self.getDatefromString(withDate: fromDate)
        self.datePicker.date = self.getDatefromString(withDate: toDate)
        self.datePicker.maximumDate = Date()
        self.openAnimated()
    }

	@IBAction func DoneTapped(_ sender: Any) {
		
		self.closeAnimated()
		
		let strDate = self.DateFormate(date: self.datePicker.date)
		
		if self.dateTybe == .From{
			
			self.fromDateLbl.text = " \(FROM.localized): \(strDate)"
			self.userInfo.fromDate = strDate
            self.getWalletNetValue()

		}else if self.dateTybe == .To{
			
			self.toDateLbl.text = " \(TO.localized): \(strDate)"
			self.userInfo.toDate = strDate
			self.getWalletNetValue()
			
		}
		//self.datePickerView.removeFromSuperview()
	}
    @IBAction func walletBalanceTapped(_ sender: Any) {
        
        let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyStockListID") as! MyStockListVC
        popUp.OtherUser = otherUser.yes
        popUp.otherUserID = self.userID
        popUp.modalPresentationStyle = .overCurrentContext
        
        self.present(popUp, animated: true, completion: nil)
    }
    
    
    @IBAction func soldBtnTapp(_ sender: UIButton) {
        
        let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "BoughtSoldStocksVC") as! BoughtSoldStocksVC
        popUp.otherUserID = self.userID
        popUp.isSold = true
        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
        
    }
    
    @IBAction func boughtBtnTapp(_ sender: UIButton) {
        let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "BoughtSoldStocksVC") as! BoughtSoldStocksVC
        popUp.otherUserID = self.userID
        popUp.isSold = false
        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
        
    }

}

extension WalletNetValueVC: UITableViewDelegate, UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.walletInfo.stockData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let data = self.walletInfo.stockData[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "walletStocksCell", for: indexPath) as! walletStocksCell
		
		if let stockName = data.stock_name{
			cell.stockNameLbl.text = stockName
		}
		
        cell.stockDateLbl.text = data.created_at ?? ""
        let share = data.share ?? 0
        
        cell.boughtStockLbl.text = "\(share) \(SHARES.localized)"

        let profit = data.profit ?? 0
        cell.profitLbl.text = "\(profit.roundTo(places: 2))"

        if profit > 0{
            
            cell.profitLbl.textColor = #colorLiteral(red: 0.01387665286, green: 0.7528751586, blue: 0.396196677, alpha: 1)
        }else{
            cell.profitLbl.textColor = #colorLiteral(red: 0.9546644101, green: 0.03709330306, blue: 0.09533545722, alpha: 1)
        }
		if let per = data.per{
			
			if per > 0 {
				
				cell.stockPrcentageLbl.text = "+\(per.roundTo(places: 2))%"
				cell.stockPrcentageLbl.textColor = #colorLiteral(red: 0.01387665286, green: 0.7528751586, blue: 0.396196677, alpha: 1)
			}else if per < 0{
				
				cell.stockPrcentageLbl.text = "\(per.roundTo(places: 2))%"
				cell.stockPrcentageLbl.textColor = #colorLiteral(red: 0.9546644101, green: 0.03709330306, blue: 0.09533545722, alpha: 1)
			}else{
			
				cell.stockPrcentageLbl.text = "\(Int(per))"
			}
		}
		
		return cell
	}
}

class walletStocksCell: UITableViewCell {
	
	@IBOutlet weak var stockNameLbl: UILabel!
	@IBOutlet weak var stockPrcentageLbl: UILabel!
    @IBOutlet weak var stockDateLbl: UILabel!
	@IBOutlet weak var boughtStockLbl: UILabel!
	@IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var profitLbl: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.stackView.layer.borderWidth = 1
		self.stackView.layer.borderColor = #colorLiteral(red: 0.3727298975, green: 0.485757947, blue: 0.5360805988, alpha: 1)
	}
}
