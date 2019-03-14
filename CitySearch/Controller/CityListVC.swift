//
//  ViewController.swift
//  CitySearch
//
//  Created by Kevin Langelier on 3/13/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import UIKit
import MapKit

class CityListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIStackView!
    
    var cities: [City] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.isHidden = true
        searchBar.isHidden = true
        loadingView.isHidden = false
        loadingView.alpha = 0
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.loadingView.alpha = 1
        }
        
        CityManager.shared.importCityJSON { [weak self] (error) in
            guard error == nil else { print(error as Any); return }
            self?.cities = CityManager.shared.fullCityList
            self?.tableView.alpha = 0
            self?.searchBar.alpha = 0
            self?.tableView.isHidden = false
            self?.searchBar.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self?.loadingView.alpha = 0
            }, completion: { _ in
                self?.loadingView.isHidden = true
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1
                    self?.searchBar.alpha = 1
                })
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC", let mapVC = segue.destination as? MapVC, let city = sender as? City {
            mapVC.location = CLLocation(latitude: CLLocationDegrees(city.latitude), longitude: CLLocationDegrees(city.longitude))
            mapVC.title = city.description
            let back = UIBarButtonItem()
            back.title = "Back"
            back.tintColor = .black
            navigationItem.backBarButtonItem = back
        }
    }

}

extension CityListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityListCell", for: indexPath) as! CityListTableViewCell
        cell.cityNameLabel.text = cities[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let city = cities[indexPath.row]
        performSegue(withIdentifier: "toMapVC", sender: city)
    }
    
}

extension CityListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        cities = CityManager.shared.getCitiesMatching(prefix: searchText)
    }
}

