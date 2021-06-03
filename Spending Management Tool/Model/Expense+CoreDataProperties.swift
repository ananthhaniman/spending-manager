//
//  Expense+CoreDataProperties.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-19.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var dueDate: Date?
    @NSManaged public var note: String?
    @NSManaged public var occurrancy: Int32
    @NSManaged public var reminder: Bool
    @NSManaged public var eventIdentifier: String?
    @NSManaged public var category: Category?

}

extension Expense : Identifiable {

}
