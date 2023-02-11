//
//  SongsView.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import UIKit

class SongsView: UITableViewController {
    fileprivate var songs: [Song]? = Song.mockSongs

    override func viewDidLoad() {
        super.viewDidLoad()
        // delegation signing
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Songs.cell)
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Songs.cell, for: indexPath)
        var context = cell.defaultContentConfiguration()
        context.text = songs?[indexPath.row].title ?? "There no one tracks!"
        cell.contentConfiguration = context

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
