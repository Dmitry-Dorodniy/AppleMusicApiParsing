//
//  ViewController.swift
//  AppleMusicApiParsing
//
//  Created by Dmitry Dorodniy on 31.07.2022.
//

import UIKit

class ViewController: UIViewController {

    let networkDataFetcher = NetworkDataFetcher()
    var searchResponse: SearchResponse? = nil
//    таймер, чтобы отсрочить запрос пользователя, пока он его не ввёл полностью
    private var timer: Timer?

    @IBOutlet weak var table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }

    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false

    }

    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = track?.trackName
        cell.contentConfiguration = content
        return cell

    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=25"

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in

            self.networkDataFetcher.fetchTracks(urlString: urlString) { searchResponse in
                guard let searchResponse = searchResponse else {
                    return
                }
                self.searchResponse = searchResponse
                self.table.reloadData()
            }
//            self.networkService.request(urlSrting: urlString) { [weak self] result in
//                switch result {
//                case .success(let searchResponse):
//                    self?.searchResponse = searchResponse
//                    self?.table.reloadData()
//                    //                searchResponse.results.map { track in
//                    //                    print("track name: \(track.trackName)")
//                    //                }
//                case .failure(let error):
//                    print("error: \(error)")
//                }
//            }
        })
        print(searchText)
    }
}
