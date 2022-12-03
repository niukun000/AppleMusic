//
//  NetworkConstant.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/24/22.
//

import Foundation

struct NetworkConstant {
    let page : Int
    let baseUrl : URL?
 
    init(page: Int) {
        self.page = page
        let temp = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/\(self.page)/albums.json"
        self.baseUrl = URL(string: temp)
    }
}
