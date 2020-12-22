//
//  DataInfo+CoreDataProperties.swift
//  
//
//  Created by 정창규 on 2020/11/16.
//
//

import Foundation
import CoreData


extension DataInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataInfo> {
        return NSFetchRequest<DataInfo>(entityName: "DataInfo")
    }

    @NSManaged public var amount: Float
    @NSManaged public var category: String?
    @NSManaged public var contents: String?
    @NSManaged public var date: Date?

}
