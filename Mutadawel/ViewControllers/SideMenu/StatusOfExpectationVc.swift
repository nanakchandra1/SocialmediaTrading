//
//  StatusOfExpectationVc.swift
//  Mutadawel
//
//  Created by ApInventiv Technologies on 02/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import GraphKit

class StatusOfExpectationVc: UIViewController {
    
    @IBOutlet weak var expectationTableView: UITableView!
    
    @IBOutlet weak var navigationTitle: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    let titleArray = [POSTS.localized , CORRECT.localized , FAILED.localized , WALLET_NET_VALUE.localized ]
    var forecastStatusInfo = StatusOfExpectationModel()
    var userId : Int!
    var rightForcast = [Any]()
    var wrongForecast = [Any]()
    var post = [Any]()
    var netValue = [Any]()
    var showgraph = [Any]()
    var indexPath = IndexPath()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.backBtn.rotateBackImage()
        self.navigationTitle.text = STATUS_OF_FORECAST.localized
        self.expectationTableView.delegate = self
        self.expectationTableView.dataSource = self

        self.getforecaststatus()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        
        _  = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func showNodata(){
        
        if self.forecastStatusInfo.post.isEmpty && self.forecastStatusInfo.right.isEmpty && self.forecastStatusInfo.wrong.isEmpty && self.forecastStatusInfo.net_value.isEmpty{
            
            self.expectationTableView.backgroundView = makeLbl(view: self.expectationTableView, msg: data_not_available.localized)
            
            self.expectationTableView.backgroundView?.isHidden = false
            
        }else{
            
            self.expectationTableView.backgroundView?.isHidden = true
            
        }
        
    }
    
    
    func getforecaststatus(){
        
        var params = JSONDictionary()
        
        params["userId"] = self.userId as AnyObject?
        
        showLoader()
        
        forecastStatusAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                print_debug(object: data!)
                
                self.forecastStatusInfo = StatusOfExpectationModel(withData: data!)
                
                self.expectationTableView.reloadData()
            }
            
            self.showNodata()
        }
    }

}


//MARK:- ================================================
//MARK:- UItable view delegate and datasource

extension StatusOfExpectationVc: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusOfExpectationCell", for: indexPath) as! StatusOfExpectationCell
        
        self.indexPath = indexPath

        switch indexPath.row {
        case 0:
                self.showgraph = self.forecastStatusInfo.post ?? []


        case 1:
                self.showgraph = self.forecastStatusInfo.right ?? []

        case 2:
                self.showgraph = self.forecastStatusInfo.wrong ?? []

        case 3:
            
                self.showgraph = self.forecastStatusInfo.net_value ?? []

        default:
            fatalError()
        }
        
        if indexPath.row == 0{
            cell.shadowView1.isHidden = true
        }else{
            cell.shadowView1.isHidden = false
        }
        
        cell.nameLbl.text = self.titleArray[indexPath.row]
        cell.graphView.dataSource = self
        cell.graphView.draw()
        cell.graphView.reset()
        cell.graphView.draw()
        cell.graphView.startFromZero = false
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
}

//MARK:- Graph view gelegate datasource methods
//MARK:- =======================================

extension StatusOfExpectationVc: GKLineGraphDataSource {
    
    func numberOfLines() -> Int {
        
        if self.indexPath.row == 0{
            return 2

        }else{
            return 1

        }
        
    }
    
    
    func colorForLine(at index: Int) -> UIColor! {
        
        switch self.indexPath.row {
            
        case 0:
            let colourArr = [AppColor.blue, AppColor.appButtonColor]
            
            return colourArr[index]

        case 1:

            let colourArr = [AppColor.blue]
            
            return colourArr[index]
            
        default:
            
            let colourArr = [AppColor.appButtonColor]
            
            return colourArr[index]
        }
        
    }
    
    
    func valuesForLine(at index: Int) -> [Any]! {
        
        if self.indexPath.row == 0{
            
            let lineDrawArr: Array = [self.forecastStatusInfo.right ?? [0,0],self.forecastStatusInfo.wrong ?? [0,0]]
            
            return lineDrawArr[index]

        }else{
            let lineDrawArr: Array = [self.showgraph,self.showgraph]
            
            return lineDrawArr[index]

        }
        
    }
    
    
//    func animationDurationForLine(at index: Int) -> CFTimeInterval {
//        
//        let animationArr = [1.6,]
//        
//        return animationArr[index]
//        
//    }
    
    func titleForLine(at index: Int) -> String! {
        
        return ""
        
    }
    
}


class StatusOfExpectationCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var graphView: GKLineGraph!
    @IBOutlet weak var shadowView1: UIView!
    @IBOutlet weak var shadowView2: UIView!
    
    override func awakeFromNib() {
        
        self.graphView.lineWidth = 2.0
        self.nameLbl.textColor = AppColor.blue
        self.graphView.margin = 0.0
        
    }
    
    func setupView(){
        
        self.shadowView2.dropShadow()
        
        self.shadowView1.dropShadow()

    }
}
