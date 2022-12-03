//
//  MusicModel.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/20/22.
//

import Foundation

struct PageResult : Decodable{
    let feed : Feed
}

struct Feed : Decodable{
    let results : [Music]
}

struct Music : Decodable{
    let name : String
    let artistName : String
    let id : String
    let releaseDate : String
    let artworkUrl100 : URL
    let genres : [Genres]
    
}

struct Genres : Decodable {
    let genreId : String
    let name : String
    let url : URL
}
