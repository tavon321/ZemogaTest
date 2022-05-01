//
//  PostDetailController.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

protocol PostDetailCellController: Hashable {
    func view(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

final class PostDetailController: UITableViewController {
    
    private lazy var dataSource = makeDataSource()
    
    public var onViewLoaded: (() -> Void)?
    
    var headerCellController: PostDetailHeaderCellController? {
        didSet {
            updateSnapshot()
        }
    }
    
    var userInfoCellController: PostDetailUserInfoCellController? {
        didSet {
            updateSnapshot()
        }
    }
    
    var commentsCellControllers: [PostDetailCommentsCellController] = [] {
        didSet {
            updateSnapshot()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewLoaded?()
    }
    
}

// MARK: DataSource

extension PostDetailController {
    enum Section: String, CaseIterable {
        case header = "Description"
        case userInfo = "User"
        case comments = "Comments"
    }
    
    enum Cell: Hashable {
        case header(PostDetailHeaderCellController)
        case userInfo(PostDetailUserInfoCellController)
        case comments(PostDetailCommentsCellController)
    }
    
    // At this moment a switch works but this can be changed to a old dataSource to avoid the switch
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Cell> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, cell in
                switch cell {
                case .header(let controller):
                    return controller.view(tableView: tableView, for: indexPath)
                case .userInfo(let controller):
                    return controller.view(tableView: tableView, for: indexPath)
                case .comments(let controller):
                    return controller.view(tableView: tableView, for: indexPath)
                }
            }
        )
    }
    
    private func updateSnapshot(animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cell>()
        
        snapshot.appendSections(Section.allCases)
        if let controller = headerCellController {
            snapshot.appendItems([.header(controller)], toSection: .header)
        }
        if let controller = userInfoCellController  {
            snapshot.appendItems([.userInfo(controller)], toSection: .userInfo)
        }
        snapshot.appendItems(commentsCellControllers.compactMap({ .comments($0) }), toSection: .comments)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = Section.allCases[section]
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.text = section.rawValue
        return label
    }
    
}
