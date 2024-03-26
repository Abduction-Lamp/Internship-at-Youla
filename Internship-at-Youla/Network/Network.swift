//
//  Network.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import Foundation

final class Network {
    
    private let session: URLSession
    private let queue = DispatchQueue(label: "ru.Lesnykh.Vladimir.Network", qos: .userInitiated, attributes: .concurrent)
    
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getServices(_ handler: @escaping (Result<[Services], NetworkErrors>) -> Void) {
        let urlString = "https://publicstorage.hb.bizmrg.com/sirius/result.json"
        if let url = URL(string: urlString) {
            
            
            
            fetch(url: url) { result in
                switch (result) {
                case .success(let response):
                    if (200...299).contains(response.status) {
                        handler(.success(response.body.services))
                    } else {
                        handler(.failure(NetworkErrors(url.absoluteString, "Data response status code \(response.status)")))
                    }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
            
            
            
            
        } else {
            handler(.failure(NetworkErrors(urlString, "Couldn't get the URL")))
        }
    }
    
    
    
    
    
    
    private func fetch(url: URL, _ handler: @escaping (Result<ServicesResponse, NetworkErrors>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                handler(.failure(NetworkErrors(url.absoluteString, "", error)))
            } else {
                if let httpURLResponse = response as? HTTPURLResponse {
                    guard (200...299).contains(httpURLResponse.statusCode) else {
                        handler(.failure(NetworkErrors(url.absoluteString, "http response status code: \(httpURLResponse.statusCode)")))
                        return
                    }
                    
                    guard let data = data else {
                        handler(.failure(NetworkErrors(url.absoluteString, "Data field is missing in the response")))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(ServicesResponse.self, from: data)
                        handler(.success(result))
                    } catch {
                        handler(.failure(NetworkErrors(url.absoluteString, "", error)))
                    }
                } else {
                    handler(.failure(NetworkErrors(url.absoluteString, "Response field is missing in the response")))
                }
            }
        }.resume()
    }
}
