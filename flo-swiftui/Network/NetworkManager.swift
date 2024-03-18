//
//  NetworkManager.swift
//  flo-swiftui
//
//  Created by 영현 on 3/19/24.
//

import Foundation
import Alamofire

final class NetworkManager<T: Codable> {
    static func fetch(completion: @escaping (Result<T, NetworkError>) -> Void) {
        AF.request(API.baseUrlString).validate().response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(json))
                } catch let err {
                    print(String(describing: err))
                    completion(.failure(.decodingError(err: err.localizedDescription)))
                }
                
            case .failure(let error):
                print("\(error.localizedDescription)")
                completion(.failure(.error(err: error.localizedDescription)))
            }
        }
    }
    
    static func download(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            AF.download(url).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case error(err: String)
    case decodingError(err: String)
}
