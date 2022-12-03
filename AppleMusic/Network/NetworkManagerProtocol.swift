//
//  NetworkManagerProtocol.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/24/22.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchModel<T: Decodable>(with url: URL?, completion : @escaping(Result<T, NetworkError>)->Void)
    func fetchRawData(with url: URL?, completion : @escaping(Result<Data, NetworkError>)->Void)
}
