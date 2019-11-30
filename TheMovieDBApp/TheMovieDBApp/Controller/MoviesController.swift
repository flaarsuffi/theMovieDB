//
//  MoviesController.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 25/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import Foundation

protocol MovieControllerDelegate: class {
    
    func successLoadMovies()
    func errorLoadMovies(error: Error?)
}

class MovieController {
    
    weak var delegate: MovieControllerDelegate?
    
    var provider: Network?
    
    var arrayMovies: Movies?
    
    func setupController(){
        self.provider = Network()
        self.provider?.delegate = self
    }
    
    func loadMovies(page: Int = 1) {
        self.setupController()
        self.provider?.loadMovies(page: page)
    }
    
    func numberOfRowsInSection() -> Int {
        return self.arrayMovies?.results?.count ?? 0
    }
    
    func loadCurrentMovie(indexPath: IndexPath) -> Result {
        
        return (self.arrayMovies?.results![indexPath.row])!
    }
}

extension MovieController: MovieProviderDelegate {
    func successLoadMovies(movies: Movies) {
        guard self.arrayMovies != nil else {
            self.arrayMovies = movies
            self.delegate?.successLoadMovies()
            return
        }
        self.arrayMovies?.results?.append(contentsOf: movies.results ?? [])
        self.delegate?.successLoadMovies()
    }
    
    
    func errorLoadMovies(error: Error?) {
        self.delegate?.errorLoadMovies(error: error)
    }
    
}
