//
//  ViewController.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-14.
//

import UIKit
import CoreData

class MainViewController: UITableViewController,NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate, MainViewProtocol {
    
    
    func refresh() {
        refreshCategory()
    }
    

    @IBOutlet var categoryTableView: UITableView!
    
    
    
    
    
    
    var categories:[Category] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupDemoCategory()
        let nib = UINib(nibName: "CategoryTableCell", bundle: nil)
        fetchCategoryList()
        categoryTableView.register(nib, forCellReuseIdentifier: "CategoryTabelCell")
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCategory = categories[indexPath.row]
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryTabelCell",for: indexPath) as! CategoryTableCell
        categoryCell.config(title: currentCategory.name ?? "none", budget: currentCategory.budget, note: currentCategory.note ?? "none", colour:UIColor.init(hexCode: currentCategory.colour ?? "#ffffff"))
        
        return categoryCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let splitVC = self.splitViewController, let detailVC = splitVC.viewControllers[1] as? ExpenseViewController {
            detailVC.config(category: categories[indexPath.row])
            detailVC.mainViewDelegate = self
        }
    }
    
    
    func fetchCategoryList() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        categories = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        do {
            categories = try context.fetch(fetchRequest) as! [Category]
            if (categories.count != 0) {
                if let splitVC = self.splitViewController, let detailVC = splitVC.viewControllers[1] as? ExpenseViewController {
                    detailVC.config(category: categories[0])
                    detailVC.mainViewDelegate = self
                }
            }
        } catch {
            print("not retriving category list")
        }
    }
    
    
    
    
    func refreshCategory() {
        fetchCategoryList()
        categoryTableView.reloadData()
                
        if (categories.count != 0) {
            if let splitVC = self.splitViewController, let detailVC = splitVC.viewControllers[1] as? ExpenseViewController {
                detailVC.config(category: categories[0])
                detailVC.mainViewDelegate = self
            }
        }else{
            if let splitVC = self.splitViewController, let detailVC = splitVC.viewControllers[1] as? ExpenseViewController {
                detailVC.config(category: nil)
                detailVC.mainViewDelegate = self
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCategory" {
            let vc = (segue.destination as! UINavigationController).topViewController as! AddCategoryController
            vc.mainViewDelegate = self
        }
        
    }
    
    
    
    @IBAction func sortCategory(_ sender: UIButton) {
        if categories.count >= 0 {
            categories.sort { $0.name! < $1.name! }
            categoryTableView.reloadData()
        }
        
    }
    


}











