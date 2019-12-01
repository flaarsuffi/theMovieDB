//
//  HomeViewController.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 21/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var moviesListTableView: UITableView!
    
    var controller: MovieController?
    
    var moviesList: [Result] = []
    var page = 0
    var datacontroller = CoreDataManager()
    var favoriteMovies: [Movie] = [] {
        didSet {
            moviesListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesListTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        self.moviesListTableView.dataSource = self
        self.moviesListTableView.delegate = self
        
        self.controller = MovieController()
        self.controller?.delegate = self
        
        self.controller?.loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datacontroller.loadMovie { (movies) in
            self.favoriteMovies.removeAll()
            self.favoriteMovies = movies
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controller?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? MovieTableViewCell
        
        let movie = self.controller?.loadCurrentMovie(indexPath: indexPath)
        if favoriteMovies.filter({ $0.id == Int(movie!.id) }).count > 0  {
            cell?.setupCell(value: movie, index: indexPath.row, isFavorite: true)
        } else {
            cell?.setupCell(value: movie, index: indexPath.row, isFavorite: false)
        }
        
        
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.movie = self.controller?.loadCurrentMovie(indexPath: indexPath)
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (controller?.arrayMovies?.results?.count ?? 0) - 10 && (controller?.arrayMovies?.results?.count ?? 0) <= (controller?.arrayMovies?.totalPages ?? 1) * 20 {
            page += 1
            self.controller?.loadMovies(page: page)
            print("ok")
        }
    }
    
}

extension HomeViewController: MovieControllerDelegate {
    
    func successLoadMovies() {
        // reload tableView
        self.moviesListTableView.reloadData()
    }
    
    func errorLoadMovies(error: Error?) {
        // show alert error
    }
}


extension HomeViewController: MovieTableViewCellDelegate {
    
    func successAddFavorite(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let movieToSave = self.controller?.loadCurrentMovie(indexPath: indexPath)
        datacontroller.saveMovie(id: movieToSave?.id ?? 0, title: movieToSave?.originalTitle ?? "", overview: movieToSave?.overview ?? "", coverURL: movieToSave?.posterPath ?? "" )
        
        datacontroller.loadMovie { (movies) in
            self.favoriteMovies.removeAll()
            self.favoriteMovies = movies
        }
    }
}
