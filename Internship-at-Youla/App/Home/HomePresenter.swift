//
//  Presenter.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import UIKit


protocol HomePresentable: AnyObject {
    
    var numberOfRowsInSection: Int { get }
    
    init(
        _ viewController: HomeViewControllerDisplayable,
        network:          Network,
        cache:            ImageCacheProtocol
    )
    
    func fetch()
    
    func getItem(for row: Int) -> (name: String, description: String, icon: UIImage?)?
}


final class HomePresenter: HomePresentable {
    
    private weak var viewController: HomeViewControllerDisplayable?
    
    private let network: Network
    private let cache:   ImageCacheProtocol
    
    private var services: [Services] = []
    var numberOfRowsInSection: Int {
        services.count
    }
    
    init(
        _ viewController: HomeViewControllerDisplayable,
        network: Network,
        cache: ImageCacheProtocol = ImageCache.shared
    ) {
        self.viewController = viewController
        self.network = network
        self.cache = cache
    }
    
    
    
    func fetch() {
        network.getServices { [weak self] result in
            guard let self = self else { return }
            
            switch (result) {
            case let .success(data):
                self.services = data
                
                DispatchQueue.main.async {
                    self.viewController?.display()
                }
            case let .failure(error):
                print(error.message)
            }
        }
    }
    
    func getItem(for row: Int) -> (name: String, description: String, icon: UIImage?)? {
        guard (0 ... (services.count - 1)).contains(row) else { return nil }
        
        let icon = cache.getImage(url: services[row].iconURL)
        if icon == nil {
            network.getImage(services[row].iconURL) { [weak self] result in
                guard let self = self else { return }
                switch (result) {
                case let .success(image):
                    cache.add(url: services[row].iconURL, image: image)
                    DispatchQueue.main.async {
                        self.viewController?.display(for: row)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        return (name: services[row].name,  description: services[row].description, icon: icon)
    }
}
