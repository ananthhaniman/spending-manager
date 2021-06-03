//
//  EditExpenseController.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-19.
//

import UIKit
import CoreData
import EventKit

class EditExpenseController: UITableViewController {
    
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtDueDate: UIDatePicker!
    @IBOutlet weak var calenderReminder: UISwitch!
    @IBOutlet weak var Occur: UISegmentedControl!
    
    
    var eventIdentifier:String = "none"
    
    
    var expenses: [NSManagedObject] = []
    
    
    var expenseViewDelegate: DetailViewProtocol?
    
    var categoryObj:Category?
    
    var expenseObj:Expense?
    
    
 
    
    
    
    override func viewDidLoad() {
        
        if expenseObj != nil {
            txtNote.text = expenseObj?.note
            txtAmount.text = String(expenseObj!.amount)
            txtDueDate.setDate(expenseObj?.dueDate ?? Date.today(), animated: false)
            calenderReminder.setOn(expenseObj?.reminder ?? false, animated: false)
            Occur.selectedSegmentIndex = Int(expenseObj?.occurrancy ?? 0)
            
        }
        
        
    }
    
    func validateFields() -> Bool {
        if !(txtAmount.text?.isEmpty)! && !(txtNote.text?.isEmpty)!{
            return true
        }
        return false
    }
    
    
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        if validateFields() {
            
            
            let endDate:Date = txtDueDate.date
            let expenseTitle:String = txtNote.text!
            let catName = self.categoryObj?.name!
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let eventStore = EKEventStore()
            if calenderReminder.isOn {
                if expenseObj?.eventIdentifier != "none" {
                    if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                        eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                            self.deleteEvent(eventStore, eventIdentifier:self.expenseObj?.eventIdentifier ?? "none")
                        })
                    } else {
                        self.deleteEvent(eventStore, eventIdentifier:self.expenseObj?.eventIdentifier ?? "none")
                    }
                    
                }
                if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                    eventStore.requestAccess(to: .event, completion: {
                        granted, error in
                        self.eventIdentifier = self.createEvent(eventStore, title: "\(expenseTitle) - \(catName!)", dueDate: endDate)
                    })
                } else {
                    self.eventIdentifier = self.createEvent(eventStore, title: "\(expenseTitle) - \(catName!)", dueDate: endDate)
                }
                
            }else{
                if expenseObj?.eventIdentifier != "none" {
                    if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                        eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                            self.deleteEvent(eventStore, eventIdentifier:self.expenseObj?.eventIdentifier ?? "none")
                        })
                    } else {
                        self.deleteEvent(eventStore, eventIdentifier:self.expenseObj?.eventIdentifier ?? "none")
                    }
                }
            }
            
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Expense", in: context)!
            
            var expenseObject = NSManagedObject()
            
            expenseObject = (expenseObj)!
            
            expenseObject.setValue(Double(txtAmount.text ?? ""), forKeyPath: "amount")
            expenseObject.setValue(txtDueDate.date, forKeyPath: "dueDate")
            expenseObject.setValue(txtNote.text, forKeyPath: "note")
            expenseObject.setValue(Occur.selectedSegmentIndex, forKeyPath: "occurrancy")
            expenseObject.setValue(calenderReminder.isOn, forKeyPath: "reminder")
            expenseObject.setValue(self.eventIdentifier, forKey: "eventIdentifier")
            
            categoryObj?.addToExpense((expenseObject as! Expense))
            
            do {
                try context.save()
                expenses.append(expenseObject)
                expenseViewDelegate?.refresh()
            } catch _ as NSError {
                let alert = UIAlertController(title: "Error", message: "Unable to create New Category. please try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            dismiss(animated: true, completion: nil)
           
            
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
    
    
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if eventToRemove != nil {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
                
            } catch {
                let alert = UIAlertController(title: "Error", message: "Calendar event could not be deleted!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
}

