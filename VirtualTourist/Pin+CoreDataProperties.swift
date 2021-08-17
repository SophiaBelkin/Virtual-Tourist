//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/16/21.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?

}

extension Pin : Identifiable {

}
