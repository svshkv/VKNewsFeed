//
//  Double+Extension.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import Foundation

extension Double
{
	func dateToString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ru_RU")
		dateFormatter.dateFormat = "d MMM 'в' HH:mm"
		let date = Date(timeIntervalSince1970: self)
		return dateFormatter.string(from: date)
	}
}
