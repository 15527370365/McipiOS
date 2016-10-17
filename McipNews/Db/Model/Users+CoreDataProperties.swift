//
//  Users+CoreDataProperties.swift
//  McipNews
//
//  Created by MAC on 16/4/26.
//  Copyright © 2016年 MAC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Users {

    @NSManaged var exitTime: String?
    @NSManaged var loginTime: String?
    @NSManaged var token: String?
    @NSManaged var userid: String?
    @NSManaged var image:String?
}
