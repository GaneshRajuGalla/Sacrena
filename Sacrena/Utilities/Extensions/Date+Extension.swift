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
        return dateFormatter.string(from: self)
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}
