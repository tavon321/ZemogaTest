//
//  PostsController.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

final class PostsController: UITableViewController {
    
    private let viewModel: PostViewModel
    
    private lazy var dataSource = makeDataSource()
    
    var cellControllers = [PostCellController]() {
        didSet {
            reloadData()
        }
    }
    
    init?(coder: NSCoder, viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:image:)` to initialize an `ImageViewController` instance.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = binded(UIRefreshControl())
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        viewModel.loadPosts()
    }
    
    @objc func refresh() {
        viewModel.loadPosts()
    }
    
    func reloadData() {
        let cellControllers = cellControllers.sorted(by: { leftProfile, rightProfile in
            let isLeftFavorite = leftProfile.post.isFavorite ?? false
            let isRightFavorite = rightProfile.post.isFavorite ?? false
            return isLeftFavorite  && !isRightFavorite
        })
        update(with: cellControllers)
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    enum Section: String {
        case posts
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, PostCellController> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, controller in
                return controller.view(tableView: tableView, for: indexPath)
            }
        )
    }
    
    func update(with controllers: [PostCellController], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PostCellController>()
        let section = Section.posts
        
        snapshot.appendSections([section])
        snapshot.appendItems(controllers, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellControllers[indexPath.row].onTap?()
    }
}
