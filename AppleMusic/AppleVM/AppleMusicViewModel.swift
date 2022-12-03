//
//  AppleMusicViewModel.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/24/22.
//

import Foundation
import CoreData

protocol AppleMusicVMProtocol {
    func bind(completion: @escaping() -> Void)
    func bindFav(completion: @escaping() -> Void)
    func requestNextPage()
    func getName(for index : Int) -> String
    func getArtistName(for index : Int) -> String
    func getImage(for index:Int, completion: @escaping(Data?)->Void)
    var count: Int { get }
    func getGenres(for index: Int) -> String
    func getDate(for index: Int) -> String
}



//class CoreDataObj : NSManagedObject{
//    var musics : AppleMusic = AppleMusic(context: NSPersistentContainer.context)
//    init(id: String, name: String, img: Data, artistName: String, date: String, geners: String){
//        self.musics = AppleMusic()
//        self.musics.id = Int32(musics.id)
//        self.musics.img = img
//        self.musics.name = name
//        self.musics.artistName = artistName
//        self.musics.date = date
//        self.musics.geners = geners
//
//    }
//}

class AppleMusicViewModel {
    typealias UpdateHandler = (()->Void)
    private var musics : [Music]
    
    var favMusics : [AppleMusic]{
        didSet{
            print("favMusics \(self.favMusics)")
            self.updateFaveHandler?()
        }
    }
    private var updateHandler : UpdateHandler?
    private var updateFaveHandler : UpdateHandler?
    private var network : NetworkManagerProtocol
    private var cordata : CoreDataManagerProtocal
    private var currentPage : Int
    private var months  = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    init(musics: [Music] = [], updateHandler: UpdateHandler? = nil, network: NetworkManagerProtocol = NetworkManager(), currentPage: Int = 0) {
        self.musics = musics
        self.favMusics = []
        self.updateHandler = updateHandler
        self.network = network
        self.currentPage = currentPage
        self.cordata = CoreDataManager.shared
    }
}

//  core data functions
extension AppleMusicViewModel{
    
    var favCount: Int {
        return self.favMusics.count
    }

    func bindFav(completion: @escaping () -> Void) {
        self.updateFaveHandler = completion
    }
    func checkCordata(id : Int) -> Bool{
        return self.cordata.checkCordata(id: id)
    }
//    func addToCordata(id : Int)
    func deleteFromCordata(id : Int){
//        self.cordata.delete()
    }
    
    func addToCoreData(id : Int, data: Data){
        if self.cordata.checkCordata(id: id){
            return
        }
        print(id)
        self.cordata.buildAlbum(id : id, data: data, name: self.musics[id].name, artistName: self.musics[id].artistName, date: self.getDate(for: id), genres: self.getGenres(for: id))
//        self.cordata.saveContext()
//        self.favMusics.append(id)
        self.cordata.addToCordata(id: id)
        print("finished to add")
//        self.updateFaveHandler?()
        self.loadFav()
//        self.cordata.fetchData { result in
//            self.favMusics = result
//            print("count\(self.favCount)")
//            self.updateFaveHandler?()
//            print(self.favCount)
//        }
    }
    

    func loadFav(){
        self.cordata.fetchData(){
            result in
            print(result)
            self.favMusics = result
            return
        }
    }
}

extension AppleMusicViewModel : AppleMusicVMProtocol{

    
    //cordata operation

    
    func getGenres(for index: Int) -> String {
        guard index < self.count else { return "[]" }
        let temp : [String] = self.musics[index].genres.compactMap { genre in
            genre.name
        }
        return "\(temp)"
    }
    
    func getDate(for index: Int) -> String {
        guard index < self.count else { return "0000,00,00" }
        let temp = self.musics[index].releaseDate
        let pre = temp.prefix(4)
        let last = temp.suffix(2)
        var mid = temp.dropFirst(5)
        mid = mid.dropLast(3)
        guard let month = Int(mid) else {return "Thirteen's Month"}
        return "\(self.months[month-1]) \(last), \(pre)"
        
    }
    
    var count: Int {
        return self.musics.count
    }
    
    
    func bind(completion: @escaping () -> Void) {
        self.updateHandler = completion
//        self.cordata.bindCoreData {
//            self.updateHandler?()
//        }
    }
    

    
    func requestNextPage() {
        self.currentPage += 1
        let url = NetworkConstant(page: self.currentPage*100).baseUrl
        
        
        self.network.fetchModel(with: url) { (result : Result<PageResult, NetworkError>) in
            switch result{
                
            case .success(let res):
                self.musics.append(contentsOf: res.feed.results)
                print("check:\(self.count)")
                
                self.updateHandler?()
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
    func getName(for index: Int) -> String {
        guard index < self.count else { return "" }
        return self.musics[index].name
    }
    
    func getArtistName(for index: Int) -> String {
        guard index < self.count else { return "" }
        return self.musics[index].artistName
    }
    
    func getImage(for index: Int, completion: @escaping (Data?) -> Void) {
        guard index < self.count else { return }
        let url = self.musics[index].artworkUrl100
        self.network.fetchRawData(with: url) { (result : Result<Data, NetworkError>) in
            switch result{
                
            case .success(let res):
                completion(res)
            case .failure(let err):
                print(err)
            }
        }
    }
}


