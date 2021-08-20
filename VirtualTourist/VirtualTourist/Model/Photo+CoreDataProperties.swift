//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/19/21.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var pin: Pin?

}

extension Photo : Identifiable {

}
