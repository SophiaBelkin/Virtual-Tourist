//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/18/21.
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
    @NSManaged public var creationDate: Date?
    @NSManaged public var pin: NSSet?

}

// MARK: Generated accessors for pin
extension Pin {

    @objc(addPinObject:)
    @NSManaged public func addToPin(_ value: Photo)

    @objc(removePinObject:)
    @NSManaged public func removeFromPin(_ value: Photo)

    @objc(addPin:)
    @NSManaged public func addToPin(_ values: NSSet)

    @objc(removePin:)
    @NSManaged public func removeFromPin(_ values: NSSet)

}

extension Pin : Identifiable {

}
