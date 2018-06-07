//
//  NSDate+Extension.swift
//  Tasty
//
//  Created by Vitaliy Kuzmenko on 17/10/14.
//  http://github.com/vitkuzmenko
//  Copyright (c) 2014 Vitaliy Kuz'menko. All rights reserved.
//

import Foundation

func NSDateTimeAgoLocalizedStrings(_ key: String) -> String {
    let resourcePath: String?

    if let frameworkBundle = Bundle(identifier: "com.kevinlawler.NSDateTimeAgo") {
        // Load from Framework
        resourcePath = frameworkBundle.resourcePath
    } else {
        // Load from Main Bundle
        resourcePath = Bundle.main.resourcePath
    }

    if resourcePath == nil {
        return ""
    }

    let path = URL(fileURLWithPath: resourcePath!).appendingPathComponent("NSDateTimeAgo.bundle")
    guard let bundle = Bundle(url: path) else {
        return ""
    }

    return NSLocalizedString(key, tableName: "NSDateTimeAgo", bundle: bundle, comment: "")
}

extension Date {
    
    // shows 1 or two letter abbreviation for units.
    // does not include 'ago' text ... just {value}{unit-abbreviation}
    // does not include interim summary options such as 'Just now'
    public var timeAgoSimple: String {
        let components = self.dateComponents()

        if components.year! > 0 {
            return self.string(fromFormat: "%%d%@yr", withValue: components.year!)
        }

        if components.month! > 0 {
            return self.string(fromFormat: "%%d%@mo", withValue: components.month!)
        }

        // TODO: localize for other calanders
        if components.day! >= 7 {
            let value = components.day!/7
            return self.string(fromFormat: "%%d%@w", withValue: value)
        }

        if components.day! > 0 {
            return self.string(fromFormat: "%%d%@d", withValue: components.day!)
        }

        if components.hour! > 0 {
            return self.string(fromFormat: "%%d%@h", withValue: components.hour!)
        }

        if components.minute! > 0 {
            return self.string(fromFormat: "%%d%@m", withValue: components.minute!)
        }

        if components.second! > 0 {
            return self.string(fromFormat: "%%d%@s", withValue: components.second! )
        }

        return ""
    }

    
    public var timeAgo: String {
        
        let components = self.dateComponents()

        if components.year! > 0 {
            if components.year! < 2 {
                return "Last year".localized
            } else {
                return self.string(fromFormat: "%%d %@years ago", withValue: components.year!)
            }
        }

        if components.month! > 0 {
            if components.month! < 2 {
                return "Last month".localized
            } else {
                return self.string(fromFormat: "%%d %@months ago", withValue: components.month!)
            }
        }

        // TODO: localize for other calanders
        if components.day! >= 7 {
            let week = components.day!/7
            if week < 2 {
                return "Last week".localized
            } else {
                return self.string(fromFormat: "%%d %@weeks ago", withValue: week)
            }
        }

        if components.day! > 0 {
            if components.day! < 2 {
                return "Yesterday".localized
            } else  {
                return self.string(fromFormat: "%%d %@days ago", withValue: components.day!)
            }
        }

        if components.hour! > 0 {
            if components.hour! < 2 {
                return "An hour ago".localized
            } else  {
                return self.string(fromFormat: "%%d %@hours ago", withValue: components.hour!)
            }
        }

        if components.minute! > 0 {
            if components.minute! < 2 {
                return"A minute ago".localized
            } else {
                return self.string(fromFormat: "%%d %@minutes ago", withValue: components.minute!)
            }
        }

        if components.second! > 0 {
            
            return "Just now".localized

//            if components.second! < 5 {
//                return NSDateTimeAgoLocalizedStrings("Just now")
//            } else {
//                return self.string(fromFormat: "%%d %@seconds ago", withValue: components.second!)
//            }
        }
        
        return ""
    }

    fileprivate func dateComponents() -> DateComponents {
        return Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: self, to: Date())
    }

    fileprivate func string(fromFormat format: String, withValue value: Int) -> String {
        let localeFormat = String(format: format, getLocaleFormatUnderscores(withValue: Double(value)))
        return String(format: localeFormat.localized, value)
    }
    
    fileprivate func getLocaleFormatUnderscores(withValue value: Double) -> String {
        guard let localeCode = Locale.preferredLanguages.first else {
            return ""
        }
        
        // Russian (ru) and Ukrainian (uk)
        if localeCode.hasPrefix("ar") || localeCode.hasPrefix("en") {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10

            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }

            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return ""
            }

            if Y == 1 && XY != 11 {
                return ""
            }
        }
        
        return ""
    }
    
}

