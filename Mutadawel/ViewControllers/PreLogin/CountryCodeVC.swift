//
//  CountryCodeVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 29/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SetContryCodeDelegate {
    func setCountryCode(country_info: JSONDictionary)
}

class CountryCodeVC: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var countryCodeTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: SkyFloatingLabelTextField!

    
    var countryInfo = JSONDictionaryArray()
    var filteredCountryList = JSONDictionaryArray()
    var delegate:SetContryCodeDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup(){
    
        self.countryCodeTableView.delegate = self
        self.countryCodeTableView.dataSource = self
        self.searchBar.delegate = self
        self.backBtn.rotateBackImage()
        self.readJson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func readJson() {
        
        let file = Bundle.main.path(forResource: "countryData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        print_debug(object: data)
        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! JSONDictionaryArray
        
        self.countryInfo = jsonData!
        self.filteredCountryList = jsonData!
        self.countryCodeTableView.reloadData()
        print_debug(object: jsonData)
        
    }

    
    @IBAction func backbtnTap(_ sender: UIButton) {
        _ = sharedAppdelegate.nvc.popViewController(animated: true)
    }

    
}

extension CountryCodeVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        

        delayWithSeconds(0.01) {
            print_debug(object: textField.text!)

            let filter = self.countryInfo.filter({ ($0["CountryEnglishName"] as? String ?? "").localizedCaseInsensitiveContains(textField.text!)
        })
            print_debug(object: filter)
            self.filteredCountryList = filter
            
            if textField.text == ""{
                self.filteredCountryList = self.countryInfo
            }
            self.countryCodeTableView.reloadData()

        }
        return true
    }
    
}

extension CountryCodeVC: UITableViewDelegate,UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCountryList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let info = self.filteredCountryList[indexPath.row]
        cell.populateView(info: info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.filteredCountryList[indexPath.row]

        self.delegate.setCountryCode(country_info: info)
        sharedAppdelegate.nvc.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}


class CountryCodeCell: UITableViewCell {
    
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func populateView(info: JSONDictionary){
        
        guard let code = info["CountryCode"] else{return}
        guard let name = info["CountryEnglishName"] as? String else{return}
        self.countryCode.text = "\(name)(+\(code))"
        guard let img = info["CountryFlag"] as? String else{return}
            self.countryFlag.image = UIImage(named: img)

    }
}
