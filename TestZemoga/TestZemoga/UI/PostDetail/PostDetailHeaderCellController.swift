//
//  PostDetailHeaderCellController.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

final class PostDetailHeaderCellController: PostDetailCellController {

    let post: Post
    
    internal init(post: Post) {
        self.post = post
    }
    
    func view(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: PostDetailHeaderCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.subtitle.text = post.body
        
        return cell
    }
    
    static func == (lhs: PostDetailHeaderCellController, rhs: PostDetailHeaderCellController) -> Bool {
        rhs.post == lhs.post
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(post)
    }
}
