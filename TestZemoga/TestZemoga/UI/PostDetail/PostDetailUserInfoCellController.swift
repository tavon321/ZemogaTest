//
//  PostDetailUserInfoCellController.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

final class PostDetailUserInfoCellController: PostDetailCellController {

    let userInfo: UserInfo
    
    internal init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    func view(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: PostDetailUserInfoCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.nameLabel.text = userInfo.name
        cell.emailLabel.text = userInfo.email
        cell.phoneLabel.text = userInfo.phone
        cell.websiteLabel.text = userInfo.website.absoluteString
        
        return cell
    }
    
    static func == (lhs: PostDetailUserInfoCellController, rhs: PostDetailUserInfoCellController) -> Bool {
        rhs.userInfo == lhs.userInfo
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userInfo)
    }
}
