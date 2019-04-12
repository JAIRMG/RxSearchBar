//
//  ViewController.swift
//  RxSearchBar
//
//  Created by Jair Moreno Gaspar on 4/11/19.
//  Copyright © 2019 Jair Moreno Gaspar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar {
        return searchController.searchBar
    }
    
    let disposeBag = DisposeBag()
    var viewModel = ApiController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSearchBar()
        rxSetup()
        
        
        
        
    }
    
    func rxSetup(){
        
        
//        Observable<Int>.interval(20.0, scheduler: MainScheduler.instance)
//            .subscribe({_ in
//                print("call the service + info aquí: https://stackoverflow.com/questions/52311965/periodically-call-an-api-with-rxswift")
//
//            })
//            .disposed(by: disposeBag)
        
        
        searchBar.rx.text.orEmpty
            .filter { query in
                return query.count > 2
            }
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        viewModel.data.drive(tableView.rx.items(cellIdentifier: "Cell")) {_, repository, cell in
            cell.textLabel?.text = repository.name
            cell.detailTextLabel?.text = repository.html_url
        }
        .disposed(by: disposeBag)

        
        
    }
    
    func configureSearchBar(){
        //Obscurece el controlador cuando esta escribiendo
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter your search"
        tableView.tableHeaderView = searchBar
        
    }


}

