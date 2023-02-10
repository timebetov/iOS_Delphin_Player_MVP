//
//  SongsView.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import UIKit

class SongsView: UITableViewController {
    fileprivate let presenter = Presenter()
    fileprivate var songs = Song.mockSongs

    override func viewDidLoad() {
        super.viewDidLoad()
        // delegation signing
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Songs.cell)
        view.backgroundColor = .systemBackground
        title = K.Songs.title
    }
    
    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Songs.cell, for: indexPath)
        var context = cell.defaultContentConfiguration()
        context.text = songs[indexPath.row].title
        cell.contentConfiguration = context

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerView = PlayerView()
        let this = indexPath.row
        
        presenter.startPlaying(idx: this)
        
        present(playerView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
