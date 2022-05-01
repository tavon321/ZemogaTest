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
        clipsToBounds = true
        layer.cornerRadius = layer.bounds.size.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(systemName: "trash"), for: .normal)
        backgroundColor = .red
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
