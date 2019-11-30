//
//  MovieDetailViewController.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 26/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieCoverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    
    var movie: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("https://image.tmdb.org/t/p/w185\(String(describing: movie?.posterPath ?? ""))")
        movieCoverImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185\(String(describing: movie?.posterPath ?? ""))"), completed: nil)
        titleLabel.text = movie?.originalTitle
        overviewTextView.text = movie?.overview
        
      
    }
    
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
     
        
    }


}
