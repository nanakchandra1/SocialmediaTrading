//
//  AddNewPostDelegateMethods.swift
//  Mutadawel
//
//  Created by Appinventiv on 18/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation


//MARK:- =================================
//MARK:- Tableview delegate datasource

extension AddNewPostVC:  UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.addPostType == .General{
            
            return 3
            
        }else if self.addPostType == .Forcast{
            return 5
        }else{
            return 6
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.addPostType == .General{
            
            if indexPath.row == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.seperatorView.isHidden = true
                cell.textView.placeholder = HAPPENING.localized
                cell.textView.font = cell.textView.font.withSize(16)
                if let text = self.forecastDetail["caption"]{
                    cell.textView.text = "\(text)"
                }
                cell.textView.delegate = self
                return cell
                
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
                cell.crossButton.addTarget(self, action: #selector(removeImagebtnTapped), for: .touchUpInside)
                if self.selectedImage != nil{
                    cell.imageViewOutlet.image = self.selectedImage
                }
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendBtnCell", for: indexPath) as! SendBtnCell
                cell.sendbtn.isEnabled = true
                cell.sendbtn.addTarget(self, action: #selector(addForecastInfo), for: .touchUpInside)
                return cell
            }
        }else if self.addPostType == .Forcast{
            
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockCell
                
                if let stock = self.forecastDetail["stock"]{
                    cell.stockTextFiels.text = "\(stock)"
                }else{
                    cell.stockTextFiels.placeholder = STOCK.localized
                }
                if let stockPrice = self.forecastDetail["stock_price"]{
                    cell.stockPriceLbl.text = "SR \(stockPrice)"
                    cell.stockPriceLbl.isHidden = false
                    cell.currentPriceFixedLbl.text = CURRENT_PRICE.localized
                    cell.currentPriceFixedLbl.isHidden = false
                    
                }else{
                    //cell.stockPriceTextField.placeholder = PRICE.localized
                    cell.stockPriceLbl.isHidden = true
                    cell.currentPriceFixedLbl.isHidden = true
                }
                
                
                cell.stockTextFiels.delegate = self
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpectPriceCell", for: indexPath) as! ExpectPriceCell
                
                cell.durationIndicatorImg.isHidden = true
                cell.donationIndicatoerUp.isHidden = true
                cell.durationTextField.keyboardType = UIKeyboardType.numberPad
                cell.priceTextField.keyboardType = UIKeyboardType.decimalPad
                cell.priceIndicatorImg.isHidden = true
                cell.priceIndiUp.isHidden = true
                cell.priceBtn.isHidden = true
                cell.durationBtn.isHidden = true
                cell.priceTextField.delegate = self
                
                if let fromTime = self.forecastDetail["duration"]{
                    cell.durationTextField.text = "\(fromTime)"
                }else{
                    cell.durationTextField.text = ""
                    cell.durationTextField.placeholder = DURATION_FORECAST.localized
                }
                
                if let toTime = self.forecastDetail["price"]{
                    cell.priceTextField.text = "\(toTime)"
                    
                }else{
                    
                    cell.priceTextField.text = ""
                    cell.priceTextField.placeholder = FORECAST_PRICE.localized
                    //TODO : change FORECAST_PRICE localized
                    
                }
                
                if  let stockprice =  self.forecastDetail["stock_price"] ,
                    let forecastprice =  self.forecastDetail["forecast_price"]{
                    
                    let stockp = Double((stockprice as AnyObject).doubleValue)
                    
                    let forecastp = Double((forecastprice as AnyObject).doubleValue)
                    
                    cell.percentageLabel.isHidden = false
                    
                    cell.percentageArrow.isHidden = false
                    
                    if stockp > forecastp{
                        
                        cell.percentageArrow.image =  UIImage(named:"red-arrow")
                        
                        let num = Double(stockp)-Double(forecastp)
                        
                        let num2 = num/Double(stockp)*100.0
                        
                        percentageForExpectation = num2
                        
                        cell.percentageLabel.text="\(num2.roundTo(places: 4))"+"%"
                        if (num2 > 25){
                            
                            errorFlag = 1
                            
                        }else{
                            
                            errorFlag = 0
                        }
                        
                        cell.percentageLabel.textColor = UIColor.red
                        
                    }else{
                        
                        cell.percentageArrow.image =  UIImage(named:"green-arrow")
                        
                        let num = Double(forecastp)-Double(stockp)
                        
                        let num2 = num/Double(stockp)*100.0
                        
                        percentageForExpectation = num2
                        
                        cell.percentageLabel.text="\(num2.roundTo(places: 4))"+"%"
                        if (num2 > 25){
                            errorFlag = 1
                        }else{
                            errorFlag = 0
                        }
                        
                        cell.percentageLabel.textColor = UIColor.green
                        
                    }
                }
                
                cell.durationTextField.delegate = self
                cell.priceTextField.delegate = self
                
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.seperatorView.isHidden = false
                cell.textView.placeholder = COMMENT.localized
                
                if let text = self.forecastDetail["caption"] as? String{
                    cell.textView.text = text
                }
                
                cell.textView.delegate = self
                
                if errorFlag==1{
                    cell.errorMsgLabel.isHidden=false
                }else{
                    cell.errorMsgLabel.isHidden=true
                    
                }
                return cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
                cell.crossButton.addTarget(self, action: #selector(removeImagebtnTapped), for: .touchUpInside)
                //cell.imageViewOutlet.clipsToBounds = true
                if self.selectedImage != nil{
                    cell.imageViewOutlet.image = self.selectedImage
                }
                return cell
                
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendBtnCell", for: indexPath) as! SendBtnCell
                cell.sendbtn.addTarget(self, action: #selector(addForecastInfo), for: .touchUpInside)
                if errorFlag==1{
                    cell.sendbtn.isEnabled =
                    false
                }else{
                    cell.sendbtn.isEnabled=true
                    
                }
                return cell
                
            default:
                fatalError()
            }
            
        }else{
            
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockCell
                
                if let stock = self.forecastDetail["stock"]{
                    cell.stockTextFiels.text = "\(stock)"
                }else{
                    cell.stockTextFiels.text = ""
                    cell.stockTextFiels.placeholder = STOCK.localized
                }
                if let stockPrice = self.forecastDetail["stock_price"]{
                    cell.stockPriceLbl.text = "SR \(stockPrice)"
                    cell.stockPriceLbl.isHidden = false
                    cell.currentPriceFixedLbl.text = CURRENT_PRICE.localized
                    cell.currentPriceFixedLbl.isHidden = false
                    
                }else{
                    //cell.stockPriceTextField.placeholder = PRICE.localized
                    cell.stockPriceLbl.isHidden = true
                    cell.currentPriceFixedLbl.isHidden = true
                }
                
                cell.stockTextFiels.delegate = self
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpectPriceCell", for: indexPath) as! ExpectPriceCell
                
                cell.priceIndicatorImg.isHidden = true
                cell.priceIndiUp.isHidden = true
                cell.durationIndicatorImg.isHidden = true
                cell.donationIndicatoerUp.isHidden = true
                cell.durationTextField.keyboardType = UIKeyboardType.decimalPad
                cell.priceBtn.isHidden = false
                cell.durationBtn.isHidden = true
                
                cell.priceBtn.addTarget(self, action: #selector(priceBtnTapped(_:)), for: .touchUpInside)
                
                if let condition1 = self.forecastDetail["condition1"] {
                    cell.durationTextField.text = "\(condition1)"
                }else{
                    cell.durationTextField.text = ""
                    cell.durationTextField.placeholder = IF.localized
                }
                if let within1 = self.forecastDetail["within1"] {
                    cell.priceTextField.text = "\(within1)"
                }else{
                    cell.priceTextField.text = ""
                    cell.priceTextField.placeholder = WITHIN.localized
                }
                
                
                
                if  let stockprice =  self.forecastDetail["stock_price"] ,let conditionOne =  self.forecastDetail["condition1"]{
                    let stockp = Double((stockprice as AnyObject).doubleValue)
                    let forecastp = Double((conditionOne as AnyObject).doubleValue)
                    cell.percentageLabel.isHidden=true
                    cell.percentageArrow.isHidden=true
                    
                    
                    if stockp > forecastp{
                        
                        cell.percentageArrow.image =  UIImage(named:"red-arrow")
                        let num = Double(stockp)-Double(forecastp)
                        let num2 = num/Double(stockp)*100.0
                        
                        
                        cell.percentageLabel.text="\(num2.roundTo(places: 4))"+"%"
                        if (num2 > 25){
                            errorFlag = 1
                        }else{
                            errorFlag = 0
                        }
                        
                        cell.percentageLabel.textColor = UIColor.red
                    }else{
                        
                        cell.percentageArrow.image =  UIImage(named:"green-arrow")
                        let num = Double(forecastp)-Double(stockp)
                        let num2 = num/Double(stockp)*100.0
                        
                        percentageForExpectation = num2
                        
                        cell.percentageLabel.text="\(num2.roundTo(places: 4))"+"%"
                        if (num2 > 25){
                            errorFlag = 1
                        }else{
                            errorFlag = 0
                        }
                        
                        cell.percentageLabel.textColor = UIColor.green
                        
                    }
                }
                
                cell.durationTextField.delegate = self
                cell.priceTextField.delegate = self
                
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpectPriceCell", for: indexPath) as! ExpectPriceCell
                cell.priceIndicatorImg.isHidden = true
                cell.priceIndiUp.isHidden = true
                cell.durationIndicatorImg.isHidden = true
                cell.donationIndicatoerUp.isHidden = true
                cell.durationTextField.keyboardType = UIKeyboardType.decimalPad
                cell.priceBtn.isHidden = false
                cell.durationBtn.isHidden = true
                cell.priceBtn.addTarget(self, action: #selector(priceBtnTapped(_:)), for: .touchUpInside)
                
                if let condition2 = self.forecastDetail["condition2"]{
                    cell.durationTextField.text = "\(condition2)"
                }else{
                    cell.durationTextField.text = ""
                    cell.durationTextField.placeholder = THEN.localized
                }
                if let within2 = self.forecastDetail["within2"]{
                    cell.priceTextField.text = "\(within2)"
                    
                }else{
                    cell.priceTextField.text = ""
                    cell.priceTextField.placeholder = WITHIN.localized
                }
                
                
                
                if  let stockprice =  self.forecastDetail["stock_price"] ,let conditionTwo =  self.forecastDetail["condition2"]{
                    let stockp = Double((stockprice as AnyObject).doubleValue)
                    let forecastp = Double((conditionTwo as AnyObject).doubleValue)
                    cell.percentageLabel.isHidden=true
                    cell.percentageArrow.isHidden=true
                    
                    
                    if stockp > forecastp{
                        
                        cell.percentageArrow.image =  UIImage(named:"red-arrow")
                        let num = Double(stockp)-Double(forecastp)
                        let num2 = num/Double(stockp)*100.0
                        
                        percentageForExpectation = num2
                        
                        cell.percentageLabel.text="\(num2.roundTo(places: 4))"+"%"
                        if (num2 > 25){
                            errorFlag = 1
                        }else{
                            errorFlag = 0
                        }
                        
                        cell.percentageLabel.textColor = UIColor.red
                    }else{
                        
                        cell.percentageArrow.image =  UIImage(named:"green-arrow")
                        let num = Double(forecastp)-Double(stockp)
                        let num2 = num/Double(stockp)*100.0
                        
                        percentageForExpectation = num2
                        
                        cell.percentageLabel.text="\(num2.roundTo(places: 4))"+"%"
                        if (num2 > 25){
                            errorFlag = 1
                        }else{
                            errorFlag = 0
                        }
                        
                        cell.percentageLabel.textColor = UIColor.green
                        
                    }
                }
                
                cell.durationTextField.delegate = self
                cell.priceTextField.delegate = self
                
                return cell
                
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.seperatorView.isHidden = false
                cell.textView.placeholder = COMMENT.localized
                
                if let text = self.forecastDetail["caption"] as? String{
                    cell.textView.text = text
                }
                cell.textView.delegate = self
                return cell
            case 4:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
                cell.crossButton.addTarget(self, action: #selector(removeImagebtnTapped), for: .touchUpInside)
                if self.selectedImage != nil{
                    cell.imageViewOutlet.image = self.selectedImage
                }
                return cell
                
                
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendBtnCell", for: indexPath) as! SendBtnCell
                cell.sendbtn.addTarget(self, action: #selector(addForecastInfo), for: .touchUpInside)
                
//                if errorFlag==1{
//                    cell.sendbtn.isEnabled =
//                    false
//                }else{
//                    cell.sendbtn.isEnabled=true
//                    
//                }
                
                return cell
                
                
            default:
                fatalError()
            }

        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        if self.addPostType != .General{
            
            if indexPath.row == 0{
                
                let listPopUp = self.storyboard?.instantiateViewController(withIdentifier: "ListPopUpID") as? ListPopUpVC
                
                listPopUp?.delegate = self
                
                
                listPopUp?.modalPresentationStyle = .overCurrentContext
                
                self.present(listPopUp!, animated: true, completion: nil)
                
            }
            
            if addPostType == .Forcast{
                

            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.addPostType == .General{
            if indexPath.row == 1{
                if self.selectedImage == nil{
                    return 0
                }else{
                    return 300
                }
            }
            return 100
            
        }else if self.addPostType == .Forcast{
            switch indexPath.row {
            case 0,1:
                return 50
            case 2:
                return 70
            case 3:
                if self.selectedImage == nil{
                    return 0
                }else{
                    return 300
                }
            case 4:
                return 70
            default:
                return 70
            }

        }else{
            switch indexPath.row {
            case 0,1,2,3:
                return 50
                
            case 4:
                if self.selectedImage == nil{
                    return 0
                }else{
                    return 300
                }
                
            case 5:
                return 70
            default:
                return 70
            }

        }
    }
    
    
    
    func durationBtnTapped(_ sender: UIButton){
        self.view.endEditing(true)
        
        self.chooseTimeType = .From
        
        self.showDatePicker()
        
        self.datePicker.minimumDate = Date()
        
        self.forecastDetail["to_time"] = nil
        
        
    }
    
    
    
    func priceBtnTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.addPostTableView) else{return}
        
        if self.addPostType == .Forcast{

        }else if self.addPostType == .Condition{
            
            if indexPath.row == 1  {
                
                
                self.view.endEditing(true)
                
                self.within_type = .Within1
                
                self.chooseTimeType = .Within1
                
                self.showDatePicker()
                
            }else if indexPath.row == 2{
                
                
                self.view.endEditing(true)
                
                self.within_type = .Within2
                
                self.chooseTimeType = .Within2
                
                self.showDatePicker()
            }
        }
    }
}
