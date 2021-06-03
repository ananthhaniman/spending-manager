//
//  ColourButton.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-17.
//

import UIKit

class ColourButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        self.layer.cornerRadius = 5
        
        
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.layer.borderWidth = 3
                self.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }else{
                self.layer.borderWidth = 0
            }
        }
    }
    

    
    
}
