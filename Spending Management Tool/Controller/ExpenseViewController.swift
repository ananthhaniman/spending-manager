//
//  ExpenseViewController.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-18.
//

import UIKit
import CoreData
import EventKit

class ExpenseViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,DetailViewProtocol {
    
    
    
    
    
    @IBOutlet weak var expenseTableCardView: CardView!
    
    
    @IBOutlet weak var piChartView: PieChartView!
    

    
    
    
    @IBOutlet weak var budgetLabel: UILabel!
    
    @IBOutlet weak var spentLabel: UILabel!
    
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var categoryTitlelabel: UILabel!
    
    @IBOutlet weak var expenseTableView: UITableView!
    @IBOutlet weak var newExpensebutton: UIButton!
    
    @IBOutlet weak var mainViewFrame: UIView!
    var categoryObj: Category!
    
    var mainViewDelegate:MainViewProtocol?
    
    
    var expenses:[Expense] = []
    var pieData:[DataPoint] = []
    
    var spent:Double = 0
    var totalBudget:Double = 0
    

    @IBOutlet weak var expenseTableViewHeight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "ExpenseTableCell", bundle: nil)
        
        expenseTableView.register(nib, forCellReuseIdentifier: "ExpenseCell")
        expenseTableView.dataSource = self
        expenseTableView.delegate = self
        hideScreen()
        
        
        
        
        
    }
    
    
    func refreshPieChart() {
//        datas.append(DataPoint(text: "total", value: getReminingPercentage(amount: total, total: total), color: UIColor.random))
        pieData.append(DataPoint(text: "remaining", value: getReminingPercentage(amount: totalBudget-spent, total: totalBudget), color: UIColor.gray))
        piChartView.dataPoints = pieData
    }
    
    
    func getReminingPercentage(amount: Double, total: Double) -> Float {
        let result:Float = Float((amount * 100)/total)
        let convert:Float = result/10
        
        return convert
    }
    
    
    func hideScreen() {
        if categoryObj == nil {
            mainViewFrame.subviews.forEach { $0.isHidden = true }
        }else{
            mainViewFrame.subviews.forEach { $0.isHidden = false }
        }
    }
    
    func fetchExpenseList() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        expenses = []
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", "category", categoryObj!)
        fetchRequest.predicate = predicate
        do {
            expenses = try context.fetch(fetchRequest)
            pieData = []
            expenses.forEach { (Expense) in
                pieData.append(DataPoint(text: Expense.description, value: getReminingPercentage(amount: Expense.amount, total: spent), color: UIColor.random))
            }
            expenseTableView.reloadData()
            refreshPieChart()
        } catch {
            print("not retriving expense list")
        }
    }
    
    func config(category: Category?) {
        categoryObj = category
        if (category != nil) {
            categoryTitlelabel.text = category?.name
            budgetLabel.text = "\(String(category!.budget)) LKR"
            fetchExpenseList()
            calculateAmount()
        }
        hideScreen()
    }
    
    
    @IBAction func onDeleteCategory(_ sender: UIButton) {
        let alertMessage = UIAlertController(title: "Delete Category", message: "Are you sure want to delete this category ?", preferredStyle: UIAlertController.Style.alert)
        alertMessage.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: { (action: UIAlertAction!) in
            self.deleteCategory()
            } ))
        alertMessage.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertMessage, animated: true, completion: nil)
        
    }
    
    
    func deleteCategory() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(categoryObj)
        do {
            try context.save()
            mainViewDelegate?.refresh()
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to delete the Category. please try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func deleteExpense(index: IndexPath) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        categoryObj.removeFromExpense((expenses[index.row]))
        context.delete(expenses[index.row])
        if expenses[index.row].reminder && (expenses[index.row].eventIdentifier != "none" && (expenses[index.row].eventIdentifier != nil) ) {
            let eventStore = EKEventStore()
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                    self.deleteEvent(eventStore, eventIdentifier: self.expenses[index.row].eventIdentifier!)
                })
            } else {
                self.deleteEvent(eventStore, eventIdentifier: self.expenses[index.row].eventIdentifier!)
            }
        }
        do {
            try context.save()
            expenses.remove(at: index.row)
            self.expenseTableView.deleteRows(at: [index], with: .fade)
            calculateAmount()
            refreshPieChart()
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to delete the Expense. please try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentExpense = expenses[indexPath.row]
        let expenseCell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell",for: indexPath) as! ExpenseTableCell
        let currentColour:UIColor = pieData[indexPath.row].color
        expenseCell.config(title: currentExpense.note ?? "", amount: currentExpense.amount, reminder: currentExpense.reminder, occur: currentExpense.occurrancy, dueDate: currentExpense.dueDate ?? Date(),totalBudget: categoryObj.budget,colour: currentColour)
        
        
        return expenseCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditExpense", sender: expenses[indexPath.row])
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteExpense(index: indexPath)
        }
        
    
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCategory" {
            let vc = (segue.destination as! UINavigationController).topViewController as! EditCategoryController
            vc.categoryObj = categoryObj
            vc.expenseDelegate = self
            vc.categoryObj = categoryObj
        }
        
        if segue.identifier == "AddExpense" {
            let vc = (segue.destination as! UINavigationController).topViewController as! AddExpenseController
            vc.expenseViewDelegate = self
            vc.categoryObj = categoryObj
            vc.spent = spent
            vc.totalBudget = totalBudget
        }
        
        if segue.identifier == "EditExpense" {
            if let indexPath = expenseTableView.indexPathForSelectedRow {
                let vc = (segue.destination as! UINavigationController).topViewController as! EditExpenseController
                vc.categoryObj = categoryObj
                vc.expenseObj = expenses[indexPath.row]
                vc.expenseViewDelegate = self
            }
            
        }
        
        
    }
    
    func refresh() {
        fetchExpenseList()
        expenseTableView.reloadData()
        calculateAmount()
        hideScreen()
        
                
    }
    
    func refreshMain() {
        mainViewDelegate?.refresh()
    }
    
    
    
    
    
    func calculateAmount() {
        var spent:Double = 0
        var remain: Double = 0
        expenses.forEach { (Expense) in
            spent += Expense.amount
        }
        remain = categoryObj.budget - spent
        spentLabel.text = "\(spent) LKR"
        remainingLabel.text = "\(remain) LKR"
        self.spent = spent
        self.totalBudget = categoryObj.budget
        
    }
    
    
}
