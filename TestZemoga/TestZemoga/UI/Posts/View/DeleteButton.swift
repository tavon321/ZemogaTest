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
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        setImage(UIImage(systemName: "trash"), for: .normal)
        backgroundColor = .red
        tintColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        }
        
        super.touchesBegan(touches, with: event)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        super.touchesEnded(touches, with: event)
    }
}
