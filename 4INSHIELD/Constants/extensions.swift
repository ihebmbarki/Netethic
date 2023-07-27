//
//  extensions.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 12/4/2023.
//

import Foundation
import UIKit
import SDWebImage



//Colors
struct Colrs {
    static let redColor = UIColor(red: 239, green: 82, blue: 96, alpha: 1)
    static let bgColor = UIColor(red: 63/255, green: 99/255, blue: 169/255, alpha: 1)
    static let default_color = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00)
}
//Display
extension UIView {
    public func roundCorners(_ cornerRadius: CGFloat, borderWidth: CGFloat = 0) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
    }
}
//Image
extension UIImageView {
    
    func loadImage(_ urlString: String?, onSuccess: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else { return }
        
        var photoUrl = "https://webserver.dev.netethic.fr" + string
        
        guard let url = URL(string: photoUrl) else { return }
        
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }
    
    func loadParentImage(from urlString: String?, onSuccess: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let urlString = urlString, var url = URL(string: urlString) else { return }
        
        // Check if the URL scheme is "http", then replace it with "https"
        if url.scheme == "http" {
            url = URL(string: urlString.replacingOccurrences(of: "http://", with: "https://"))!
        }
        
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }

    
    func anchor(top:NSLayoutYAxisAnchor? = nil,
                left:NSLayoutXAxisAnchor? = nil,
                bottom:NSLayoutYAxisAnchor? = nil,
                right:NSLayoutXAxisAnchor? = nil,
                paddingTop:CGFloat = 0,
                paddingLeft:CGFloat = 0,
                paddingBottom:CGFloat = 0,
                paddingRight:CGFloat = 0,
                width:CGFloat? = nil,
                height:CGFloat? = nil
    ) {
        
        // activate programmatic auto layout
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

//Date
extension String {
    public enum DateFormatType {
        /// The ISO8601 formatted year "yyyy" i.e. 1997
        case isoYear
        /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
        case isoYearMonth
        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
        case isoDate
        /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
        case isoDateTime
        /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
        case isoDateTimeSec
        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
        case isoDateTimeMilliSec
        /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
        case dotNet
        /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
        case rss
        /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
        case altRSS
        /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
        case httpHeader
        /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
        case standard
        /// A custom date format string
        case custom(String)
        /// The local formatted date and time "yyyy-MM-dd HH:mm:ss" i.e. 1997-07-16 19:20:00
        case localDateTimeSec
        /// The local formatted date  "yyyy-MM-dd" i.e. 1997-07-16
        case localDate
        /// The local formatted  time "hh:mm a" i.e. 07:20 am
        case localTimeWithNoon
        /// The local formatted date and time "yyyyMMddHHmmss" i.e. 19970716192000
        case localPhotoSave
        case birthDateFormatOne
        case birthDateFormatTwo
        case messageRTetriveFormat
        case emailTimePreview
        var stringFormat:String {
            switch self {
                //handle iso Time
            case .birthDateFormatOne: return "dd/MM/YYYY"
            case .birthDateFormatTwo: return "dd-MM-YYYY"
            case .isoYear: return "yyyy"
            case .isoYearMonth: return "yyyy-MM"
            case .isoDate: return "yyyy-MM-dd"
            case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
            case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            case .dotNet: return "/Date(%d%f)/"
            case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
            case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
            case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
            case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
            case .custom(let customFormat): return customFormat
                //handle local Time
            case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
            case .localTimeWithNoon: return "hh:mm a"
            case .localDate: return "yyyy-MM-dd"
            case .localPhotoSave: return "yyyyMMddHHmmss"
            case .messageRTetriveFormat: return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            case .emailTimePreview: return "dd MMM yyyy, h:mm a"
            }
        }
    }
    func toDate(_ format: DateFormatType = .isoDate) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension UIView  {
    func addShadowView(width:CGFloat=0, height:CGFloat=1, Opacidade:Float=0.11, maskToBounds:Bool=false, radius:CGFloat=25, shadowRadius:CGFloat=12){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
}
