//
//  PostCellController.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

final class PostCellController: Hashable {

    var post: Post
    
    public var onTap: (() -> Void)?
    public var onFavoriteTap: (() -> Void)?
    public var onDeleteTap: ((PostCellController) -> Void)?
    
    internal init(post: Post) {
        self.post = post
    }
    
    func view(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: PostCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.title.text = post.title
        cell.subtitle.text = post.body
        cell.favoriteButton.isSelected = post.isFavorite ?? false
        
        cell.onFavoriteButtonTap = { [weak self] isSelected in
            self?.post.isFavorite = isSelected
            self?.onFavoriteTap?()
        }
        
        cell.onDeleteButtonTap = { [weak self] in
            guard let self = self else { return }
            self.onDeleteTap?(self)
        }
        
        return cell
    }
    
    static func == (lhs: PostCellController, rhs: PostCellController) -> Bool {
        rhs.post == lhs.post
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(post)
    }
}
