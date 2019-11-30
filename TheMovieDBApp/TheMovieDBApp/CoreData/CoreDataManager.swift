//
//  CoreDataManager.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 26/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {

lazy var persistentContainer: NSPersistentContainer = {
     let container = NSPersistentContainer(name: "TheMovieDBApp")
     container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
             fatalError("Unresolved error \(error), \(error.userInfo)")
         }
     })
     return container
 }()
    
    
    
    func saveMovie(id: Int, title: String, overview: String, coverURL: String) {
        let context = persistentContainer.viewContext
        let movie = Movie(context: context)
        movie.id = Int64(id)
        movie.title = title
        movie.overview = overview
        movie.coverURL = coverURL
        
        try? context.save()
    }
    
    
    func loadMovie(completion:([Movie]) -> Void) {
        
        let context = persistentContainer.viewContext
              let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
              let result = try? context.fetch(request)
              let arrayMovie = result as? [Movie] ?? []
              completion(arrayMovie)
    }
    
    func deleteInformation(id: NSManagedObjectID, completion: (Bool) -> Void) {
        let context = persistentContainer.viewContext
        let obj = context.object(with: id)
        context.delete(obj)
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }

}
