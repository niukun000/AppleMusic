//
//  CoreDataManager.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/28/22.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocal{
    func bindCoreData(completion: @escaping () -> Void)
//    func saveContext()
    func buildAlbum(id : Int, data: Data, name: String, artistName: String, date: String, genres: String)
    func fetch()
    func delete()
    func checkCordata(id : Int) -> Bool
    func addToCordata(id : Int)
    func deleteFromCordata(id : Int)
    func fetchData(_ completion: @escaping ([AppleMusic]) -> Void) -> [AppleMusic]
//    func count() -> Int
    
//    var count: Int { get }

}


class CoreDataManager : CoreDataManagerProtocal {
    
    static let shared = CoreDataManager()
    
    func fetch() {
        return
    }
    
    func delete() {
        return
    }
    
//    var count: Int{
//        return self.m
//    }
    
    
    
    var cordataIdSet : Set = Set<Int>()
    
    
    func checkCordata(id : Int) -> Bool{
        return self.cordataIdSet.contains(id)
    }
    
    func addToCordata(id : Int){
        //        self.buildAlbum(data: data, name: name, artistName: artistName, date: date, genres: ge)
//        self.saveContext()
        self.cordataIdSet.insert(id)

    }
    
    func deleteFromCordata(id : Int){
        self.cordataIdSet.remove(id)
        self.updateCoreDataHandler?()
    }
    
    typealias UpdateHandler = (()->Void)
    private var updateCoreDataHandler : UpdateHandler?
    
    lazy var persistantContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppleMusic")
        container.loadPersistentStores { description, err in
            if let _ = err{
                fatalError("failed to create core data container")
            }
        }
        return container
    }()
    
    lazy var mainContext : NSManagedObjectContext = {
        let main = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        main.persistentStoreCoordinator = self.persistantContainer.persistentStoreCoordinator
        return main
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let back = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        back.parent = self.mainContext
        return back
    }()
    
    //    var updateHandeler : (()-> Void)
    
    
    func bindCoreData( completion: @escaping () -> Void){
        self.updateCoreDataHandler = completion
    }
    
//    func saveContext (){
//        let context = self.persistantContainer.viewContext
//        if context.hasChanges{
//            do{
//                try context.save()
//            }
//            catch{
//                print(error)
//            }
//        }
//
//    }
    
    func loadFav() -> [AppleMusic]{
//        self.cordata.fetchData { result in
            let request = AppleMusic.fetchRequest()
            // BAD!!! DO NOT DO!!!
            return try! self.mainContext.fetch(request)
        
    }
    
    func fetchData(_ completion: @escaping ([AppleMusic]) -> Void) -> [AppleMusic]{
        let context = self.mainContext
        let entity = NSEntityDescription.entity(forEntityName: "AppleMusic", in: context)
        
        context.perform {
            let request = NSFetchRequest<AppleMusic>()
            request.entity = entity
            
            do {
                let results = try context.fetch(request)
//                print(results)
                completion(results)
                
            } catch {
                print(error)
            }
        }
        return []
    }
    
    //    func bind(completion : )
    
    func buildAlbum(id : Int, data: Data, name: String, artistName: String, date: String, genres: String) {
        let context = self.backgroundContext
        context.perform {
            guard let entity = NSEntityDescription.entity(forEntityName: "AppleMusic", in: context) else{
                return
            }
            
            let appleMusic = AppleMusic(entity: entity, insertInto: context)
            appleMusic.name = name
            appleMusic.artistName = artistName
            appleMusic.date = date
            appleMusic.geners = genres
            appleMusic.img = data
            appleMusic.id = Int32(id)
            
            do {
                try context.save()
                
            }catch{
                print(error)
                
            }
        }
    }
}
