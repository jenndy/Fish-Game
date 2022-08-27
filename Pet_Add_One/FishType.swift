//
//  FishType.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 12/1/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import Foundation
import UIKit

enum MediaType: Int {
    case fish, whale, blowfish
    static let allValues = [fish, whale, blowfish]
    
    func title() -> String {
        switch self {
        case .fish:
            return "Fish"
        case .whale:
            return "Whale"
        case .blowfish:
            return "Blowfish"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .fish:
            return UIImage(named: "type_fish")
        case .whale:
            return UIImage(named: "type_whale")
        case .blowfish:
            return UIImage(named: "type_blowfish")
        }
    }
}

