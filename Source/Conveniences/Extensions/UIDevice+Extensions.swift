//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

/**
 *  TODO: Pieced together from a few answers posted here:
 *  http://stackoverflow.com/questions/26028918/ios-how-to-determine-the-current-iphone-device-model-in-swift
 *  See also: https://github.com/dennisweissmann/DeviceKit
 */

enum ScreenSize: String, EnumCollection {
    case threeDotFive   = "3.5 inch"
    case four           = "4 inch"
    case fourDotSeven   = "4.7 inch"
    case fiveDotFive    = "5.5 inch"
    case fiveDotEight   = "5.8 inch"
    case sevenDotNine   = "7.9 inch"
    case nineDotSeven   = "9.7 inch"
    case twelveDotNine  = "12.9 inch"
    case undefined      = "?unknown?"

    static var current: ScreenSize {
        return UIDevice.current.type.size
    }

    /**
      This is a less reliable means of determining screensize
      and should only be used to improve simulator behavior.
     */
    fileprivate static var fromUIScreen: ScreenSize {
        //TODO: handle landscape orientation
        let height = UIScreen.main.bounds.height

        let size: ScreenSize

        switch height {
        case 480:  size = .threeDotFive
        case 568:  size = .four
        case 667:  size = .fourDotSeven
        case 736:  size = .fiveDotFive
        case 768:  size = .nineDotSeven  //could also be .sevenDotNine!!
        case 812:  size = .fiveDotEight
        case 1024: size = .twelveDotNine
        default:   size = .undefined
        }

        return size
    }
}

enum Model: String, EnumCollection {
    case simulator = "simulator/sandbox"
    case iPod1          = "iPod Touch 1"
    case iPod2          = "iPod Touch 2"
    case iPod3          = "iPod Touch 3"
    case iPod4          = "iPod Touch 4"
    case iPod5          = "iPod Touch 5"
    case iPod6          = "iPod Touch 6"

    case iPad2          = "iPad 2"
    case iPad3          = "iPad 3"
    case iPad4          = "iPad 4"

    case iPadAir1       = "iPad Air 1"
    case iPadAir2       = "iPad Air 2"

    case iPadMini1      = "iPad Mini 1"
    case iPadMini2      = "iPad Mini 2"
    case iPadMini3      = "iPad Mini 3"
    case iPadMini4      = "iPad Mini 4"

    case iPadPro9inch   = "iPad Pro (9 inch)"
    case iPadPro12inch  = "iPad Pro (12 inch)"

    case iPhone4        = "iPhone 4"
    case iPhone4S       = "iPhone 4S"
    case iPhone5        = "iPhone 5"
    case iPhone5S       = "iPhone 5S"
    case iPhone5C       = "iPhone 5C"
    case iPhone6        = "iPhone 6"
    case iPhone6plus    = "iPhone 6 Plus"
    case iPhone6S       = "iPhone 6S"
    case iPhone6Splus   = "iPhone 6S Plus"
    case iPhoneSE       = "iPhone SE"
    case iPhone7        = "iPhone 7"
    case iPhone7plus    = "iPhone 7 Plus"
    case iPhone8        = "iPhone 8"
    case iPhone8plus    = "iPhone 8 Plus"
    case iPhoneX        = "iPhone X"

    case appleTV4        = "Apple TV 4"

    case unrecognized   = "?unrecognized?"

    var size: ScreenSize {
        switch self {
        case .iPod1, .iPod2, .iPod3, .iPod4:
            return ScreenSize.threeDotFive
        case .iPod5, .iPod6, .iPhone4, .iPhone4S, .iPhone5, .iPhone5S,
             .iPhone5C, .iPhoneSE:
            return ScreenSize.four
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            return ScreenSize.fourDotSeven
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            return ScreenSize.fiveDotFive
        case .iPhoneX:
            return ScreenSize.fiveDotEight
        case .iPadMini1, .iPadMini2, .iPadMini3, .iPadMini4:
            return ScreenSize.sevenDotNine
        case .iPad2, .iPad3, .iPad4, .iPadAir1, .iPadAir2, .iPadPro9inch:
            return ScreenSize.nineDotSeven
        case .iPadPro12inch:
            return ScreenSize.twelveDotNine
        case .simulator:
            return ScreenSize.fromUIScreen
        case .appleTV4, .unrecognized:
            return ScreenSize.undefined
        }
    }
}

extension UIDevice {
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,

            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPod7,1"   : .iPod6,

            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,

            "iPad4,1"   : .iPadAir1,
            "iPad4,2"   : .iPadAir2,

            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,

            "iPad6,3"   : .iPadPro9inch,
            "iPad6,4"   : .iPadPro9inch,
            "iPad6,7"   : .iPadPro12inch,
            "iPad6,8"   : .iPadPro12inch,

            "AppleTV5,3": .appleTV4,

            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,3" : .iPhone7,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,4" : .iPhone8,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,6" : .iPhoneX
        ]

        if let model = modelMap[identifier] {
            return model
        }
        return Model.unrecognized
    }
}
