//
//  ViewController.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import UIKit

final class HomeViewController: UIViewController {

    public var homeView: HomeView {
        guard let view = self.view as? HomeView else {
            return HomeView(frame: self.view.frame)
        }
        return view
    }
    
    
    
    override func loadView() {
        view = HomeView()
        
        homeView.table.delegate = self
        homeView.table.dataSource = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.backgroundColor = .black
        
        title = "Сервисы"
        
        let network = Network()
        network.getServices { result in
            switch(result) {
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let data):
                print("!ok = \(data.count)")
            }
        }
        
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)") else {
            return UITableViewCell()
        }
        
        var content = UIListContentConfiguration.subtitleCell()
        content.directionalLayoutMargins = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        content.text = "ВКонтакте"
        content.textProperties.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        content.secondaryText = "checkmark circle fillc heckmark circle fill checkmark circle fill checkmark circle fill checkmark circle fill"
        
        
        content.image = UIImage(systemName: "checkmark.circle.fill")
        content.imageProperties.tintColor = .systemGreen
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}
