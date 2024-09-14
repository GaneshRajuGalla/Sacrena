//
//  Date+Extension.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import Foundation

enum DateFormatStyle {
    case timeOnly // "h:mm a"
    
    var format: String {
        switch self {
        case .timeOnly:
            return "h:mm a"
        }
    }
}

extension Date {
    func formattedString(using style: DateFormatStyle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = style.format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}
