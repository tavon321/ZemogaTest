//
//  PostDetailCommentsCellController.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

final class PostDetailCommentsCellController: PostDetailCellController {

    let comment: Comment
    
    internal init(comment: Comment) {
        self.comment = comment
    }
    
    func view(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: PostDetailCommentsCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.title.text = comment.body
        
        return cell
    }
    
    static func == (lhs: PostDetailCommentsCellController, rhs: PostDetailCommentsCellController) -> Bool {
        rhs.comment == lhs.comment
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
    }
}
