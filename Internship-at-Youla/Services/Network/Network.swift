//
//  Network.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import UIKit

protocol NetworkProtocol: AnyObject {
    
    func getServices(_ handler: @escaping (Result<[Services], NetworkErrors>) -> Void)
    func getImage(_ urlString: String, _ handler: @escaping (Result<UIImage, NetworkErrors>) -> Void)
}


final class Network: NetworkProtocol {
    
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getServices(_ handler: @escaping (Result<[Services], NetworkErrors>) -> Void) {
        let urlString = "https://publicstorage.hb.bizmrg.com/sirius/result.json"
        if let url = URL(string: urlString) {
            fetch(url: url) { result in
                switch (result) {
                case let .failure(error):
                    handler(.failure(error))
                case let .success(data):
                    do {
                        let result = try JSONDecoder().decode(ServicesResponse.self, from: data)
                        handler(.success(result.body.services))
                    } catch {
                        handler(.failure(NetworkErrors(url.absoluteString, "", error)))
                    }
                }
            }
        } else {
            handler(.failure(NetworkErrors(urlString, "Couldn't get the URL")))
        }
    }
    
    func getImage(_ urlString: String, _ handler: @escaping (Result<UIImage, NetworkErrors>) -> Void) {
        if let url = URL(string: urlString) {
            fetch(url: url) { result in
                switch (result) {
                case let .failure(error):
                    handler(.failure(error))
                case let .success(data):
                    if let image = UIImage(data: data) {
                        handler(.success(image))
                    } else {
                        handler(.failure(NetworkErrors(url.absoluteString, "Couldn't init Image from Data")))
                    }
                }
            }
        } else {
            handler(.failure(NetworkErrors(urlString, "Couldn't get the URL")))
        }
    }
    
    
    private func fetch(url: URL, _ handler: @escaping (Result<Data, NetworkErrors>) -> Void) {
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
                    handler(.success(data))
                } else {
                    handler(.failure(NetworkErrors(url.absoluteString, "Response field is missing in the response")))
                }
            }
        }.resume()
    }
}
