//
//  DBNews+CoreDataProperties.swift
//  newsApp
//
//  Created by Georgy Bodrov on 15.10.2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//
//

import Foundation
import CoreData


extension DBNews {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<DBNews> {
        return NSFetchRequest<DBNews>(entityName: "DBNews")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var urlArticle: String?
    @NSManaged public var urlImage: String?

}


