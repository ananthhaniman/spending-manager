//
//  AddCategoryController.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-17.
//

import UIKit
import CoreData


class AddCategoryController: UITableViewController {
    
    
    @IBOutlet weak var txtCategoryName: UITextField!
    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    
    
    @IBOutlet weak var color1: ColourButton!
    @IBOutlet weak var color2: ColourButton!
    @IBOutlet weak var color3: ColourButton!
    @IBOutlet weak var color4: ColourButton!
    @IBOutlet weak var color5: ColourButton!
    @IBOutlet weak var color6: ColourButton!
    
    var colorButtons:[ColourButton]!
    var flagColor:UIColor?
    
    
    var categories: [NSManagedObject] = []
    
    var mainViewDelegate: MainViewProtocol?
    

    
    
    
    override func viewDidLoad() {
        colorButtons = [color1,color2,color3,color4,color5,color6]
    }
    
    
    func validateFields() -> Bool {
        if !(txtCategoryName.text?.isEmpty)! && !(txtBudget.text?.isEmpty)! && !(txtNote.text?.isEmpty)! && !(flagColor == nil){
            return true
        }
        return false
    }
    
    
    
    @IBAction func onSaveCategory(_ sender: UIBarButtonItem) {
        if validateFields() {
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)!
            
            var categoryObj = NSManagedObject()
            
            categoryObj = NSManagedObject(entity: entity, insertInto: context)
            
            categoryObj.setValue(txtCategoryName.text, forKeyPath: "name")
            categoryObj.setValue(Double(txtBudget.text ?? ""), forKeyPath: "budget")
            categoryObj.setValue(txtNote.text, forKeyPath: "note")
            categoryObj.setValue(flagColor?.hexString, forKeyPath: "colour")
            
            do {
                try context.save()
                categories.append(categoryObj)
                mainViewDelegate?.refresh()
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
    
    
    
    
    
    
    
    
    
    
    

    @IBAction func colorButtonOnClick(_ sender: ColourButton) {
        flagColor = sender.backgroundColor
        colorButtons.forEach { (ColourButton) in
            if ColourButton.backgroundColor == sender.backgroundColor {
                ColourButton.isSelected = true
            }else{
                ColourButton.isSelected = false
            }
        }
        
    }
    
    
    
    
    
}
