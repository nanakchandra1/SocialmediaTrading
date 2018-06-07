//
//  UIVewExtention.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit


//MARK: extension for table TableView
extension UIView {
    
    func tableViewCell() -> UITableViewCell? {
        
        var tableViewcell : UIView? = self
        
        while(tableViewcell != nil) {
            
            if tableViewcell! is UITableViewCell {
                break
            }
            tableViewcell = tableViewcell!.superview
        }
        return tableViewcell as? UITableViewCell
        
    }
    
    
    func tableViewIndexPath(tableView: UITableView) -> NSIndexPath? {
        
        if let cell = self.tableViewCell() {
            return tableView.indexPath(for: cell) as NSIndexPath?
        }
        return nil
    }
    
    
    
    func collectionViewCell() -> UICollectionViewCell? {
        
        var collectionViewcell : UIView? = self
        
        while(collectionViewcell != nil) {
            
            if collectionViewcell! is UICollectionViewCell {
                break
            }
            collectionViewcell = collectionViewcell!.superview
        }
        return collectionViewcell as? UICollectionViewCell
        
    }
    
    
    func collectionViewIndexPath(collectionView: UICollectionView) -> NSIndexPath? {
        
        if let cell = self.collectionViewCell() {
            return collectionView.indexPath(for: cell) as NSIndexPath?
        }
        return nil
    }
    
    
    
    
    // add shadow of view
        func dropShadow() {
            
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 3
            self.layer.shouldRasterize = false
        }
	
		func dropShadowGray() {
		
		self.layer.masksToBounds = false
		self.layer.shadowColor = #colorLiteral(red: 0.3727298975, green: 0.485757947, blue: 0.5360805988, alpha: 1)
		self.layer.shadowOpacity = 0.7
		self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowRadius = 3
		self.layer.shouldRasterize = false
		
		}
}


extension String{
    
    var localized : String {
        if sharedAppdelegate.appLanguage  == AppLanguage.Arabic {
            return localizedString(lang: "ar")
        }
        else {
            return  localizedString(lang: "en")
        }
    }
    
    
    func localizedString(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }


}

//extension Double {
//    /// Rounds the double to decimal places value
//    mutating func roundToPlaces(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return round(self * divisor) / divisor
//    }
//}



//---------------------------------------------------------------------
// MARK: CLASS EXTENSION (NSDATE)
//---------------------------------------------------------------------

extension Date {
    
    static func getCurrentDate() -> Date {
        
        return convertDate(Date(), toFormat: "YYYY-MMM-dd")
    }
    
    static func convertDate(_ date:Date , toFormat format:String) -> Date {
        
        let currentDateString = Date.stringFromDate(date, format: format)
        
        return Date.dateFromString(currentDateString, format: format)
    }
    
    static func stringFromDate(_ date: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    static func stringFromTime(_ time: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateFormat = format
        
        return formatter.string(from: time)
    }
    
    static func dateFromString(_ date: String, format: String) -> Date {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return (formatter.date(from: date))!
    }
    
    static func timeFromString(_ date: String, format: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return (formatter.date(from: date))!
    }
    
    static func calculateAge(_ birthDate: Date) -> Int {
        
        let calendar = Calendar.current
        let ageComponents = (calendar as NSCalendar).components(.year, from: birthDate, to: Date(), options:NSCalendar.Options.matchStrictly)
        return ageComponents.year!
        
    }
    
    func calculateDaysBetweenTwoDates(date: Date,unit: Calendar.Component) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: unit, in: .era, for: date) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: unit, in: .era, for: self) else {
            return 0
        }
        return end - start
        
    }
    
    
    static func minimumAge() -> Date {
        
        let unitFlags: NSCalendar.Unit = [ .day, .month, .year]
        let now = Date()
        let gregorian = Calendar.current
        var dateComponents = (gregorian as NSCalendar).components(unitFlags, from: now)
        dateComponents.year = dateComponents.year! - 18
        
        return gregorian.date(from: dateComponents)!
    }
    
    
    static func maxAge() -> Date {
        
        let unitFlags: NSCalendar.Unit = [ .day, .month, .year]
        let now = Date()
        let gregorian = Calendar.current
        var dateComponents = (gregorian as NSCalendar).components(unitFlags, from: now)
        dateComponents.year = dateComponents.year! - 100
        
        return gregorian.date(from: dateComponents)!
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func isLessThanTime(_ timeToCompare:Date) -> Bool {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        
        let result = self.compare(timeToCompare)
        
        if(result == ComparisonResult.orderedDescending) {
            
            return false
            
        } else {
            
            return true
        }
    }
    
//    func relativeDateString () -> String {
//        
//        let units : NSCalendar.Unit = [.minute,.hour , .day , .weekOfYear , .month,.year]
//        
//        let components = (Calendar.current as NSCalendar).components(units, from: self, to: Date(), options: [])
//        
//        if (components.year! > 0) {
//            
//            return "\(setTime(components.year!)) \(Years_ago.localized)"
//            
//        } else if (components.month! > 0) {
//            
//            return "\(setTime(components.month!)) \(Months_ago.localized)"
//            
//        } else if (components.weekOfYear! > 0) {
//            
//            return "\(setTime(components.weekOfYear!)) \(Weeks_ago.localized)"
//            
//        } else if (components.day! > 0) {
//            
//                return "\(setTime(components.day!)) \(days_ago.localized)"
//                
//        } else if (components.hour! > 0){
//            
//            if (components.hour! == 1){
//                return "\(setTime(components.hour!)) \(hr_ago.localized)"
//
//            }else{
//                return "\(setTime(components.hour!)) \(hrs_ago.localized)"
//            }
//        }else if (components.minute! > 1){
//            
//            return "\(setTime(components.minute!)) \(mins_ago.localized)"
//
//        }else{
//            
//            return just_now.localized
//        }
//    }
}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    
    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
}

extension UIView
{
    func roundView()  {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}


extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000 ... 0x1F77F, // Emoticons
        0x2100 ... 0x27BF, // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F, // Variation Selectors
        0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

extension String {
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return !unicodeScalars.filter { $0.isEmoji }.isEmpty
    }
    
    var containsOnlyEmoji: Bool {
        
        return unicodeScalars.first(where: { !$0.isEmoji && !$0.isZeroWidthJoiner }) == nil
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}


