//
//  CardView.swift
//  Spending Management Tool
//
//  Created by Ananthamoorthy Haniman on 2021-05-17.
//

import UIKit

class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 2.5
        self.layer.shadowOpacity = 0.7
    }
    
    
    
}
