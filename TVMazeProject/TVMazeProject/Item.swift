//
//  Item.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 29/02/24.
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
