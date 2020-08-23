//
//  MyFoodViewController.swift
//  myFood
//
//  Created by Nick on 23.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit

class MyFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFoodTableView.dataSource = self
        myFoodTableView.delegate = self
    }
    
    @IBOutlet weak var myFoodTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        return cell
    }
}
