//
//  ViewController.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import UIKit

protocol HomeViewControllerDisplayable: AnyObject {
    
    var presenter: HomePresentable? { get set }
    
    func display()
    func display(for item: Int)
    
}
extension HomeViewControllerDisplayable where Self: UIViewController {}



final class HomeViewController: UIViewController, HomeViewControllerDisplayable {

    var presenter: HomePresentable?
    
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
        
        title = "Сервисы"
        homeView.backgroundColor = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetch()
    }
    
    
    func display() {
        homeView.table.reloadData()
    }
    
    func display(for item: Int) {
        homeView.table.reloadRows(at: [IndexPath(row: item, section: 0)], with: .automatic)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let item = presenter?.getItem(for: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)")
        else { return UITableViewCell() }
        
        var content = UIListContentConfiguration.subtitleCell()
        content.directionalLayoutMargins = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        content.text = item.name
        content.textProperties.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        content.textProperties.color = .white
        
        content.secondaryText = item.description
        content.secondaryTextProperties.color = .white
        
        content.image = item.icon
        content.imageProperties.maximumSize = .init(width: 50, height: 50)
        
        cell.contentConfiguration = content
        cell.backgroundColor = .black
        cell.accessoryType = .disclosureIndicator
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.open(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
