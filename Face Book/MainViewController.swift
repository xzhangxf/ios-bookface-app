//  MainViewController.swift
//  Face Book
//
//  Created by Xufeng Zhang on 16/10/25.
//

import UIKit

import UIKit

final class MainViewController: UITableViewController {

    private var allUsers: [User] = []
    private var users: [User] = []
    private var dataSource: UITableViewDiffableDataSource<Section, User>!
    private var limit = 20
    private var skip = 0
    private var total = Int.max
    private var isLoading = false
    private let faceCache = NSCache<NSNumber, UIImage>()

    private let spinner: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .large)
        v.hidesWhenStopped = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Face Book"
        view.backgroundColor = .systemBackground

        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseID)

        configureDataSource()
        configureSearch()
        configureSpinner()

        Task { await initialLoad() }
    }

    private func configureSpinner() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search name or email"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, User>(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, user in
                guard let self else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseID, for: indexPath) as! UserTableViewCell

                cell.configure(name: user.fullName, email: user.email, age: user.age)
                if let cached = self.faceCache.object(forKey: NSNumber(value: user.id)) {
                    cell.setImage(cached)
                } else {
                    cell.startImageLoading()
                    Task { [weak self, weak cell] in
                        guard let self else { return }
                        let image = await self.fetchRandomFaceImage()
                        if let img = image {
                            self.faceCache.setObject(img, forKey: NSNumber(value: user.id))
                        }
                        await MainActor.run {
                            if let visibleCell = tableView.cellForRow(at: indexPath) as? UserTableViewCell {
                                visibleCell.setImage(image)
                            } else {
                                cell?.setImage(image)
                            }
                        }
                    }
                }

                return cell
            }
        )
        dataSource.defaultRowAnimation = .fade
    }

    private func applySnapshot(_ items: [User], animating: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    private func fetchUsers(limit: Int, skip: Int) async throws -> UsersPage {
        let url = URL(string: "https://dummyjson.com/users?limit=\(limit)&skip=\(skip)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UsersPage.self, from: data)
    }

    private func fetchRandomFaceImage() async -> UIImage? {
        guard let url = URL(string: "https://100k-faces.vercel.app/api/random-image") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

    private func initialLoad() async {
        await setLoading(true)
        Task { await setLoading(false) }

        do {
            let page = try await fetchUsers(limit: limit, skip: 0)
            self.skip = page.skip + page.limit
            self.limit = page.limit
            self.total = page.total

            self.allUsers = page.users
            self.users = page.users
            applySnapshot(self.users, animating: false)
        } catch {
            print("Users initial load failed:", error)
        }
    }

    private func loadMoreIfNeeded() async {
        guard !isLoading, allUsers.count < total else { return }
        await setLoading(true)
        Task { await setLoading(false) }

        do {
            let page = try await fetchUsers(limit: limit, skip: skip)
            skip = page.skip + page.limit
            allUsers.append(contentsOf: page.users)

            if let q = currentQuery, !q.isEmpty {
                users = filter(allUsers, by: q)
            } else {
                users = allUsers
            }
            applySnapshot(users)
        } catch {
            print("Users pagination load failed:", error)
        }
    }

    private func setLoading(_ loading: Bool) {
        isLoading = loading
        if loading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }

    private var currentQuery: String? {
        searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func filter(_ list: [User], by query: String) -> [User] {
        let q = query.lowercased()
        return list.filter { u in
            u.fullName.lowercased().contains(q) || u.email.lowercased().contains(q)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let u = users[indexPath.row]
        let vc = UserDetailController(user: u)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height * 2 {
            Task { await loadMoreIfNeeded() }
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let q = currentQuery, !q.isEmpty {
            users = filter(allUsers, by: q)
        } else {
            users = allUsers
        }
        applySnapshot(users)
    }
}
