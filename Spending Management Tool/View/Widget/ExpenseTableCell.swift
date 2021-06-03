//
//  ExpenseTableCell.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-19.
//

import UIKit

class ExpenseTableCell: UITableViewCell {
    
    
    @IBOutlet weak var circleProgressView: CustomMiniProgressBar!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var reminderLabel: UILabel!
    
    
    var occurrancy:[String] = ["One Off","Daily","Weeky","Monthly"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(title:String, amount:Double, reminder:Bool, occur: Int32, dueDate: Date,totalBudget: Double,colour:UIColor){
        self.noteLabel.text = title
        self.amount.text = "\(amount) LKR"
        if reminder {
            reminderLabel.alpha = 1
        }else{
            reminderLabel.alpha = 0
        }
        
        if occur > 0 {
            self.dueDateLabel.text = "Due : \(occurrancy[Int(occur)]), \(getDate(dueDate))"
        }else{
            self.dueDateLabel.text = "Due : \(formatDate(dueDate))"
        }
        
        circleProgressView.color = colour
        
        
        let precent = getReminingPercentage(amount:  amount, total: totalBudget)
        circleProgressView.updateProgress(to: precent, animated: true)
        
        
        
        
    }
    
    public func formatDate(_ date: Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    public func getDate(_ date: Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    
    
    func getReminingPercentage(amount: Double, total: Double) -> Double {
        let result:Double = (amount * 100)/total
        let convert = result/100
        
        return convert
    }
}
