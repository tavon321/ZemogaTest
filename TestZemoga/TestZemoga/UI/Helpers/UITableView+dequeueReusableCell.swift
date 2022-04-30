//
//  UITableView+dequeueReusableCell.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}
