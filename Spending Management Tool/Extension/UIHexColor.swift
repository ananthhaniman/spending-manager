//
//  UIHexColor.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-18.
//

import Foundation
import UIKit

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    
    convenience init(hexCode hexString: String, alpha:CGFloat = 1.0) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

                if (cString.hasPrefix("#")) {
                    cString.remove(at: cString.startIndex)
                }

                if ((cString.count) == 6) {
                    Scanner(string: cString).scanHexInt32(&rgbValue)
                }

                self.init(
                    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                    alpha: alpha
                )
        }
    
    static var random: UIColor {
            return UIColor(red: .random(in: 0...1),
                           green: .random(in: 0...1),
                           blue: .random(in: 0...1),
                           alpha: 1.0)
        }
}
