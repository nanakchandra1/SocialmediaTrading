//
//  currentPriceIndicatorVC.swift
//  Mutadawel
//
//  Created by MOMO on 9/21/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class currentPriceIndicatorVC: UIViewController {

	@IBOutlet weak var navigationView: UIView!
	@IBOutlet weak var NavigationLbl: UILabel!
	@IBOutlet weak var currentIndicatorTableView: UITableView!
	@IBOutlet weak var backBtn: UIButton!
	
	var indicatorDetailsArray = [CurrentPriceIndicatorModel]()
	var indicatorDictArr = [CurrentPriceIndicatorModel]()
	var indicatorDetails = CurrentPriceIndicatorModel()
	var priceIndicatorDate: String = ""
	
    override func viewDidLoad() {
		
        super.viewDidLoad()

		self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func initialSetup(){
		
		self.currentIndicatorTableView.delegate = self
		self.currentIndicatorTableView.dataSource = self
		
		
		self.currentIndicatorTableView.allowsSelection = false
		if sharedAppdelegate.appLanguage == .Arabic {
			
			let img = #imageLiteral(resourceName: "ic_sign_in_next")
			self.backBtn.setImage(img, for: .normal)
		}else{
			
			let img = #imageLiteral(resourceName: "ic_sign_in_back")
			self.backBtn.setImage(img, for: .normal)
		}
		self.NavigationLbl.text = CURRENT_PRICE_INDICATOR.localized
		self.getPriceIndicatorList()
	}
	
	func getPriceIndicatorList(){
		
		var params = JSONDictionary()
		params["userId"] = CurrentUser.user_id 
		
		priceIndicatorListAPI(params: params) { (success, msg, data) in
			
			if success{
				
                self.indicatorDictArr = data!.map({ (rideDetail) -> CurrentPriceIndicatorModel in
                    
                    CurrentPriceIndicatorModel(withData: rideDetail)
                })

				self.currentIndicatorTableView.reloadData()
				
			}else{
				
				showToastWithMessage(msg: msg)
			}
		}
	}
	
	
	func countRows() -> Int {
		
        let indicatorDet = CurrentPriceIndicatorModel()
		
		for dic in self.indicatorDictArr{
			
			if self.priceIndicatorDate != dic.priceIndicatorDate{
				
				self.priceIndicatorDate = dic.priceIndicatorDate
				indicatorDet.priceIndicatorDate = priceIndicatorDate
				self.indicatorDetailsArray.append(indicatorDet)
			}
			self.indicatorDetailsArray.append(dic)
		}
		return indicatorDetailsArray.count
	}
	
	@IBAction func backBtnTapped(_ sender: Any) {
		
		  _ = self.navigationController?.popViewController(animated: true)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension currentPriceIndicatorVC: UITableViewDelegate,UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.countRows()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		
		self.indicatorDetails = self.indicatorDetailsArray[indexPath.row]
		
		
	
		if (self.indicatorDetails.name_en ?? "").isEmpty {
		
			let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! dateCell
		
			if let date = self.indicatorDetails.priceIndicatorDate{
				
				self.priceIndicatorDate = date
			}
			
			cell.currentPriceDateLbl.text = self.priceIndicatorDate
			
			return cell
			
		}else{
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "indicatorCell", for: indexPath) as! indicatorCell
			
			if let status = self.indicatorDetails.priceIndicatorStatus{
				
				if status == 0{
					
					cell.statusColorView.layer.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
					cell.statusImage.image = PostStatusImages.watch
					
				}else if status == 1{
					
					cell.statusColorView.layer.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
					cell.statusImage.image = PostStatusImages.right_tick
					
				}else{
					
					cell.statusColorView.layer.backgroundColor = #colorLiteral(red: 0.741684556, green: 0.1100602821, blue: 0.1227148697, alpha: 1)
					cell.statusImage.image = PostStatusImages.cross
				}
			}
			
			if let name = self.indicatorDetails.name_en{
				
				cell.stockNameLabl.text = name
			}
			
			if let price = self.indicatorDetails.priceindicatorPrice{
				
				cell.psiceIndicatorPrice.text = "SAR \(price)"
			}
			
			
			return cell
		}
	}
}

class dateCell: UITableViewCell {
	
	@IBOutlet weak var currentPriceDateLbl: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		
	}
	
}

class indicatorCell: UITableViewCell {
	
	@IBOutlet weak var stockNameLabl: UILabel!
	@IBOutlet weak var psiceIndicatorPrice: UILabel!
	@IBOutlet weak var statusImage: UIImageView!
	@IBOutlet weak var statusColorView: UIView!
	@IBOutlet weak var requiredStockPrice: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.requiredStockPrice.text = REQUIRED_STOCK_PRICE.localized
		
	}
}
