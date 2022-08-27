//
//  Fish+CoreDataClass.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 12/2/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//
//

import Foundation
import CoreData

@objc(Fish)
public class Fish: NSManagedObject {

    override public func awakeFromInsert() {
        if self.uuid == nil {
            self.uuid = UUID()
        }
    }
}
