//
//  PostCell.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

final class PostCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var onButtonTap: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        onButtonTap?(favoriteButton.isSelected)
    }
}
