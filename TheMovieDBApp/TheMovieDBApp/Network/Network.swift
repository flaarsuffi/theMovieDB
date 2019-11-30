//
//  Network.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 25/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import Foundation
import Alamofire


protocol MovieProviderDelegate: class {
    
    func successLoadMovies(movies: Movies)
    func errorLoadMovies(error: Error?)
}

class Network {
    
    weak var delegate: MovieProviderDelegate?
        
    func loadMovies(page: Int) {
        
        let urlString: String = "https://api.themoviedb.org/3/movie/popular?api_key=00559cb014aa0981cea2137c43e84b2e&language=pt-BR&page=\(page)"
        
        if let url:URL = URL(string: urlString) {
           
            Alamofire.request(url, method: .get).responseJSON { (response) in
                
                if response.response?.statusCode == 200 {
                    do {
                        
//                        let model:Movies = try JSONDecoder().decode(Movies.self, from:  response.data ?? Data())
                        let model = try JSONDecoder().decode(Movies.self, from: response.data ?? Data())
                        
                        print(model)
                        self.delegate?.successLoadMovies(movies: model)
                        
                    } catch  let error{
                        print( error)
                        self.delegate?.errorLoadMovies(error: error)
                    }
                }else {
                
                    print(response.error ?? "")
                    self.delegate?.errorLoadMovies(error: response.error)
                }
            }
                
            }
        
    }

}


