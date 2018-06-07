//
//  MarketVC.swift
//  Mutadawel
//
//  Created by MOMO on 10/7/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MarketVC: UIViewController {

	@IBOutlet weak var navigationView: UIView!
	@IBOutlet weak var backBtn: UIButton!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.someEffects(view: self.navigationView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK:===== some graphic effects ====
	func someEffects(view: UIView){
		
		view.layer.shadowOffset = CGSize(width: 2, height: 2)
		view.layer.shadowOpacity = 0.3
		view.layer.shadowRadius = 1.2
		
	}
	
	@IBAction func backBtnAction(_ sender: Any) {
		
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
