//
//  QueryService.swift
//  LetsGo
//
//  Created by Macbook on 21/5/19.
//  Copyright © 2019 Peartree Developers. All rights reserved.
//

import Foundation

class QueryService {
    
    var places = [Place]()
    
    
    typealias QueryResult = ([Place]?) -> ()
    
    func parseJSONOnline(completion: @escaping QueryResult) {
        guard let url = URL(string: "https://data.melbourne.vic.gov.au/resource/vh2v-4nfs.json?$limit=20") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in guard let data = data else { return }
            do {
                
                self.places = try JSONDecoder().decode([Place].self, from: data)
                print(self.places)
            } catch let err {
                print("Err", err)
            }
            
            DispatchQueue.main.async {
                completion(self.places)
            }
            }.resume()
        print(places)
    }
    
    
    
}
