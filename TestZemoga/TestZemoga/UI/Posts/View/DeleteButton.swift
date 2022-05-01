//
//  DeleteButton.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

class DeleteButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(UIImage(systemName: "trash"), for: .normal)
    }
}


