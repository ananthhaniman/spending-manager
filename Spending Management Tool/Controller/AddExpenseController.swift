//
//  AddExpenseController.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-19.
//

import UIKit
import CoreData
import EventKit

class AddExpenseController: UITableViewController {
    
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtDueDate: UIDatePicker!
    @IBOutlet weak var calenderReminder: UISwitch!
    @IBOutlet weak var Occur: UISegmentedControl!
    
    var eventIdentifier:String = "none"
    
    
    var expenses: [NSManagedObject] = []
    
    
    var expenseViewDelegate: DetailViewProtocol?
    
    var categoryObj:Category?
    
    
    var spent:Double = 0
    var totalBudget:Double = 0
    
    
    override func viewDidLoad() {
        
    }
    
    func validateFields() -> Bool {
        if !(txtAmount.text?.isEmpty)! && !(txtNote.text?.isEmpty)!{
            return true
        }
        return false
    }
    
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        if validateFields() {
            
            if validateCalculation(amount: Double(txtAmount.text!)!) {
                let endDate:Date = txtDueDate.date
                let expenseTitle:String = txtNote.text!
                let catName = self.categoryObj?.name!
                
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                let eventStore = EKEventStore()
                if calenderReminder.isOn {
                    if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                        eventStore.requestAccess(to: .event, completion: {
                            granted, error in
                            self.eventIdentifier = self.createEvent(eventStore, title: "\(expenseTitle) - \(catName!)", dueDate: endDate)
                        })
                    } else {
                        self.eventIdentifier = self.createEvent(eventStore, title: "\(expenseTitle) - \(catName!)", dueDate: endDate)
                    }
                    
                }
                
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Expense", in: context)!
                
                var expenseObj = NSManagedObject()
                
                expenseObj = NSManagedObject(entity: entity, insertInto: context)
                
                expenseObj.setValue(Double(txtAmount.text ?? ""), forKeyPath: "amount")
                expenseObj.setValue(txtDueDate.date, forKeyPath: "dueDate")
                expenseObj.setValue(txtNote.text, forKeyPath: "note")
                expenseObj.setValue(Occur.selectedSegmentIndex, forKeyPath: "occurrancy")
                expenseObj.setValue(calenderReminder.isOn, forKeyPath: "reminder")
                expenseObj.setValue(self.eventIdentifier, forKey: "eventIdentifier")
                
                categoryObj?.addToExpense((expenseObj as! Expense))
                
                do {
                    try context.save()
                    expenses.append(expenseObj)
                    expenseViewDelegate?.refresh()
                } catch _ as NSError {
                    let alert = UIAlertController(title: "Error", message: "Unable to create New Category. please try again", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                dismiss(animated: true, completion: nil)
            }else{
                let alertMessage = UIAlertController(title: "Error", message: "This amount higher than your budget. ", preferredStyle: UIAlertController.Style.alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
            }
            
            
           
            
        }else{
            let alertMessage = UIAlertController(title: "Error", message: "Required details are missing!. Please fill the required fields.", preferredStyle: UIAlertController.Style.alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    
    
    // Creates an event in the EKEventStore
    func createEvent(_ eventStore: EKEventStore, title: String, dueDate: Date) -> String {
        let event = EKEvent(eventStore: eventStore)
        var identifier = ""
        
        event.title = title
        event.startDate = dueDate
        event.endDate = dueDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        
        if Occur.selectedSegmentIndex == 1 {
            
            let recurrenceRule = EKRecurrenceRule.init(
                            recurrenceWith: .daily,
                            interval: 1,
                            daysOfTheWeek: [EKRecurrenceDayOfWeek.init(EKWeekday.saturday)],
                            daysOfTheMonth: nil,
                            monthsOfTheYear: nil,
                            weeksOfTheYear: nil,
                            daysOfTheYear: nil,
                            setPositions: nil,
                            end: nil
                            )

            event.recurrenceRules = [recurrenceRule]
        }
        
        if Occur.selectedSegmentIndex == 2 {
            
            let recurrenceRule = EKRecurrenceRule.init(
                recurrenceWith: .weekly,
                            interval: 1,
                            daysOfTheWeek: [EKRecurrenceDayOfWeek.init(EKWeekday.saturday)],
                            daysOfTheMonth: nil,
                            monthsOfTheYear: nil,
                            weeksOfTheYear: nil,
                            daysOfTheYear: nil,
                            setPositions: nil,
                            end: nil
                            )

            event.recurrenceRules = [recurrenceRule]
        }
        
        if Occur.selectedSegmentIndex == 3 {
            
            let recurrenceRule = EKRecurrenceRule.init(
                recurrenceWith: .monthly,
                            interval: 7,
                            daysOfTheWeek: [EKRecurrenceDayOfWeek.init(EKWeekday.saturday)],
                            daysOfTheMonth: nil,
                            monthsOfTheYear: nil,
                            weeksOfTheYear: nil,
                            daysOfTheYear: nil,
                            setPositions: nil,
                            end: nil
                            )

            event.recurrenceRules = [recurrenceRule]
        }
        
        
        
        
        
        do {
            try eventStore.save(event, span: .thisEvent)
            identifier = event.eventIdentifier
        } catch {
            let alert = UIAlertController(title: "Error", message: "Calendar event could not be created!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return identifier
    }
    
    
    
    func validateCalculation(amount: Double) -> Bool {
        let currentTotal = spent + amount
        print(currentTotal)
        if currentTotal > totalBudget {
            return false
        }else{
            return true
        }
        
    }
    
}

