//
//  Cell.swift
//  CellFun
//
//  Created by Spencer Symington on 2024-04-28.
//

import Foundation
import Combine
import SpriteKit
import SwiftUI

class Cell {
    let type: CellType
    var velocity = CGVector.zero
    init(type: CellType, velocity: CoreFoundation.CGVector = CGVector.zero) {
        self.type = type
        self.velocity = velocity
    }
}
