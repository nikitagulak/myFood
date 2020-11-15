//
//  DietViewController.swift
//  myFood
//
//  Created by Nick on 11.11.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit

class DietViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func generateMealPlan(_ sender: UITapGestureRecognizer) {
        getDataFromServer(url: URL(string: "http://localhost:3000")!)
    }
    
    func getDataFromServer(url: URL) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
        }
        
        task.resume()
    }
    
//    public func getDataFromServer(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let sessionConfiguration = URLSessionConfiguration.default
//            let session = URLSession(configuration: sessionConfiguration)
//            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
//                guard let data = data else { completion(nil); return }
//                completion(data)
//            })
//            task.resume()
//        }
//    }
    

}
