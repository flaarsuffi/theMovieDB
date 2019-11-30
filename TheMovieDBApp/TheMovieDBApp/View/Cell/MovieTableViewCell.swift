//
//  MovieTableViewCell.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 25/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import UIKit
import SDWebImage


protocol MovieTableViewCellDelegate: class {
    
    func successAddFavorite(index: Int)
    
}

class MovieTableViewCell: UITableViewCell {
    
    weak var delegate: MovieTableViewCellDelegate?
    private var currentMovie: Result?


    @IBOutlet weak var movieCoverImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    var buttonTappedAction : ((UITableViewCell) -> Void)?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.heartButton.tintColor = UIColor.white

    }
    
    func setupCell(value: Result?, index: Int, isFavorite: Bool = false) {
        self.index = index
        
        let fav = isFavorite
        if fav {
            self.heartButton.tintColor = UIColor.orange
        } else {
            self.heartButton.tintColor = UIColor.white
        }
        if let _value = value {
            
            self.currentMovie = _value
            self.titleLabel.text = _value.title
            self.overviewLabel.text = _value.overview
            self.movieCoverImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185\(_value.posterPath ?? "")"), completed: nil)
        }
        
    }
    
    
    func setupCell(value: Movie?) {
        
        if let _value = value {
            self.heartButton.isHidden = true
            self.titleLabel.text = _value.title
            self.overviewLabel.text = _value.overview
            self.movieCoverImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185\(_value.coverURL ?? "")"), completed: nil)
        }
        
    }


    
    @IBAction func heartBtnTapped(_ sender: Any) {
        self.delegate?.successAddFavorite(index: index)
                
    }
}
