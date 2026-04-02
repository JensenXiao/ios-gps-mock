//
//  Item.swift
//  O.Paperclip
//
//  Created by Mason Yen on 3/2/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
