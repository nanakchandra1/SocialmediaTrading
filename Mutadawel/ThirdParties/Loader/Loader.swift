//
//  Loader.swift
//  iHearU
//
//  Created by Appinventiv on 20/07/16.
//  Copyright © 2016 Appinventiv. All rights reserved.
//

import UIKit

class Loader {

    //StartLoader
    class func showLoader() {

        DispatchQueue.main.async { 
            ActivityLoader.start()

        }
        
    }
    
    class func hideLoader() {
        DispatchQueue.main.async {
            ActivityLoader.stop()
        }
    }
    
}

let ActivityLoader = LoaderClass()

 class LoaderClass : UIView {
    
    private let spinnerBackView = UIView()
    private let spinner = JTMaterialSpinner()
    
    var isLoading = false
    
    private override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight ))
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        self.isUserInteractionEnabled = true
        //let messageLabel = UILabel(frame: CGRect(x: 3, y: self.bounds.origin.y + 85, width: 194, height: 30))
        //messageLabel.textAlignment = NSTextAlignment.center
        //messageLabel.tag = 857364
        let spinnerBackViewWidth : CGFloat = 100
        let spinnerBackViewHeight : CGFloat = 100
        
        self.spinner.frame = CGRect(x: self.bounds.origin.x + 20, y: self.bounds.origin.y, width: 60, height: 60)
        self.spinner.circleLayer.lineWidth = 2.0
        self.spinner.circleLayer.strokeColor = AppColor.navigationBarColor.cgColor
        
        self.spinnerBackView.frame = CGRect(x: (screenWidth - spinnerBackViewWidth)/2,y: (screenHeight - spinnerBackViewHeight)/2, width: spinnerBackViewWidth, height: spinnerBackViewHeight)
           // CGRect((screenWidth - spinnerBackViewWidth)/2, (screenHeight - spinnerBackViewHeight)/2, spinnerBackViewWidth, spinnerBackViewHeight)
        self.spinnerBackView.backgroundColor = UIColor.clear //(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.spinnerBackView.layer.cornerRadius = 20.0
        self.spinnerBackView.clipsToBounds = true
        self.spinnerBackView.addSubview(self.spinner)
        //self.spinnerBackView.addSubview(messageLabel)
        self.addSubview(self.spinnerBackView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not Loading Properly")
    }
    
    func start() {
        if self.isLoading {
            return
        }
        sharedAppdelegate.window?.addSubview(self)
        self.spinner.beginRefreshing()
        self.isLoading = true
    }
    
    func stop() {
        self.spinner.endRefreshing()
        self.removeFromSuperview()
        self.isLoading = false
    }
}
