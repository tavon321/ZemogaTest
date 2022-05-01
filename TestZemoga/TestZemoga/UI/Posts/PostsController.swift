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
    
    lazy var button = DeleteButton()
    
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addRemoveAllButton()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellControllers[indexPath.row].onTap?()
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
    
    private func addRemoveAllButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalToConstant: 60),
        ])
        
        tableView.bringSubviewToFront(button)
        
        button.addTarget(self, action: #selector(deleteAllTapped), for: .touchUpInside)
    }
    
    @objc private func deleteAllTapped() {
        cellControllers.removeAll()
    }
}
    

// MARK: Datasource

extension PostsController {
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
    
}
