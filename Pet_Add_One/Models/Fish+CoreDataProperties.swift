//
//  Fish+CoreDataProperties.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 12/2/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//
//

import Foundation
import CoreData


extension Fish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fish> {
        return NSFetchRequest<Fish>(entityName: "Fish")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var type: String?
    @NSManaged public var score: Int16
    @NSManaged public var uuid: UUID?

}
