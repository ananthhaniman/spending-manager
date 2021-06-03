//
//  CategoryTableCell.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-16.
//

import UIKit

class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var cellbox: UIView!
    
    
    var categoryTitle:String!
    var categoryBudget:Double!
    var categoryNote:String!
    var categoryColour:UIColor!
    
    
        
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellbox.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected){
            cellbox.layer.borderWidth = 3
            cellbox.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            cellbox.layer.borderWidth = 0
            cellbox.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        

        // Configure the view for the selected state
    }
    
    func config(title:String, budget:Double, note:String, colour: UIColor){
        self.title.text = title
        self.budget.text = "\(budget) LKR"
        self.note.text = note
        self.cellbox.backgroundColor = colour
    }
    
}
