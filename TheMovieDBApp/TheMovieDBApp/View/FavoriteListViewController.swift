//
//  FavoriteListViewController.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 26/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {

    @IBOutlet weak var favoriteMoviesTableView: UITableView!
    
       let coreDataManager = CoreDataManager()
       var arrayMovies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.favoriteMoviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        loadInformation()

        self.favoriteMoviesTableView.dataSource = self
        self.favoriteMoviesTableView.delegate = self
    }

    func loadInformation() {
        coreDataManager.loadMovie{ (arrayMovies) in
        self.arrayMovies = arrayMovies
            print(self.arrayMovies.count)
        self.favoriteMoviesTableView.reloadData()
          
        }
      }
    
    override func viewDidAppear(_ animated: Bool) {
    
        loadInformation()
    }

}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? MovieTableViewCell
        
        cell?.setupCell(value: arrayMovies[indexPath.row])

//        cell?.setupCell(value: arrayMovies[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
      print("pegou traililing")
      
      tableView.deselectRow(at: indexPath, animated: true)
      
      if !self.arrayMovies.isEmpty {
          
        
          let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, (Bool) -> Void) in
              
            let temp: Movie = self.arrayMovies[indexPath.row]
             
            self.arrayMovies.remove(at: indexPath.row) 
              
            self.coreDataManager.deleteInformation(id: temp.objectID ) { (success) in
                
                if success {
                    self.favoriteMoviesTableView.reloadData()
                }
            }
             
          }
          
          deleteAction.backgroundColor = UIColor.red
          deleteAction.image = #imageLiteral(resourceName: "trash")
          
          let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
          swipeActionConfiguration.performsFirstActionWithFullSwipe = true
          
          return swipeActionConfiguration
          
      } else {
          
           return nil
          
      }
      
  }
    
    
    
}


