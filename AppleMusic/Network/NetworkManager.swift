//
//  NetworkManager.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/24/22.
//

import Foundation

class NetworkManager{
    let urlSession: URLSession
    let decoder: JSONDecoder
    
    init(urlSession: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}


extension NetworkManager : NetworkManagerProtocol {
    func fetchModel<T>(with url: URL?, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let url = url else {
            completion(.failure(.badURL))
            return
        }
        let task = self.urlSession.dataTask(with: url) { data, response, error in
            if let err = error{
                completion(.failure(.serverError(err)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(.badStatusCode(httpResponse.statusCode)))
                return
            }
            guard let data = data else{
                completion(.failure(.badData))
                return
            }
            do {
                let model = try self.decoder.decode(T.self, from: data)
                completion(.success(model))
            }
            catch{
                if let error = error as? DecodingError{
                    completion(.failure(.decodeFailure(error)))
                }
                else{
                    completion(.failure(.other(error)))
                }
            }
        }
        task.resume()
    }
    
    func fetchRawData(with url: URL?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = url else{
            completion(.failure(.badURL))
            return
        }
        let task = self.urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(.badStatusCode(httpResponse.statusCode)))
                return
            }
            guard let data = data else{
                completion(.failure(.badData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    
}
