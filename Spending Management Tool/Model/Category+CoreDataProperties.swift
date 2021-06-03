//
//  Category+CoreDataProperties.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-19.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var budget: Double
    @NSManaged public var colour: String?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var expense: NSSet?

}

// MARK: Generated accessors for expense
extension Category {

    @objc(addExpenseObject:)
    @NSManaged public func addToExpense(_ value: Expense)

    @objc(removeExpenseObject:)
    @NSManaged public func removeFromExpense(_ value: Expense)

    @objc(addExpense:)
    @NSManaged public func addToExpense(_ values: NSSet)

    @objc(removeExpense:)
    @NSManaged public func removeFromExpense(_ values: NSSet)

}

extension Category : Identifiable {

}
