//
//  ViewController.swift
//  CitySearch
//
//  Created by Kevin Langelier on 3/13/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CityManager.shared.importCityJSON { (error) in
            
        }
    }

}

