//
//  ApiController.swift
//  RxSearchBar
//
//  Created by Jair Moreno Gaspar on 4/11/19.
//  Copyright © 2019 Jair Moreno Gaspar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class ApiController {
    static var shared = ApiController()
    var dataTask: URLSessionDataTask?
    
    let searchText = Variable("")
    
    lazy var data: Driver<[Repo]> = {
        return self.searchText.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .flatMapLatest(ApiController.repositoriesBy)
        .asDriver(onErrorJustReturn: [])
    }()
    
    static func repositoriesBy(_ githubID: String) -> Observable<[Repo]> {
        
        guard !githubID.isEmpty, let url = URL(string: "https://api.github.com/users/\(githubID)/repos") else {
            print("campo vacío o imposible construir url")
            return Observable.just([])
        }
        let request = URLRequest(url: url)
        var apiController = ApiController()
        
        
        return URLSession.shared.rx.data(request: request).map({ (myData) in
            apiController.parse(data: myData)
        })
        
    }
    
    func parse(data: Data) -> [Repo]{
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([Repo].self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    //the url String
    
}
