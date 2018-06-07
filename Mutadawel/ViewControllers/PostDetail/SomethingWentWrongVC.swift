//
//  SomethingWentWrongVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 04/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

protocol TryAgainDelegate {
    
    func tryAgain()
}

class SomethingWentWrongVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var tryAganBtn: UIButton!
    @IBOutlet weak var horizentalCenterConstant: NSLayoutConstraint!
    @IBOutlet weak var verticalCenterConstant: NSLayoutConstraint!
    
    var delegate: TryAgainDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpViews(){
        
        
    }
    
    func animatedDisapper(_ complete: @escaping () -> Void){
        
        UIView.animate(withDuration: 0.3) {
            
            self.popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            self.view.alpha = 0
        }
        delay(0.2) {
            
            self.dismiss(animated: false, completion: nil)
            
        }
    }

    @IBAction func tryAgainTapped(_ sender: UIButton) {
        
        self.delegate.tryAgain()
        self.animatedDisapper {}
    }
}
