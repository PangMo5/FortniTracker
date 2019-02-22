//
//  SearchListViewController.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SwifterSwift
import RxSwiftExt
import RxGesture

class SearchListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func makeUI() {
        super.makeUI()
        
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.textField?.font = UIFont(name: "ObelixPro", size: 12) ?? UIFont.systemFont(ofSize: 12)
        
        searchBar.becomeFirstResponder()
        
        themeService.rx
            .bind({ $0.barStyle }, to: searchBar.rx.barStyle)
            .bind({ $0.background }, to: view.rx.backgroundColor)
            .bind({ $0.background }, to: tableView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SearchViewModel.Input(inputText: searchBar.rx.text.filterNil().asDriver(onErrorJustReturn: ""),
                                          selection: tableView.rx.modelSelected(SearchSectionItem.self).asDriver(),
                                          dismissGesture: tableView.rx.didScroll.asObservable())
        
        let output = viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            switch item {
            case .item( _):
                return UITableViewCell()
            case .user(let viewModel):
                let cell = tableView.dequeueReusableCell(withClass: SearchListTableViewCell.self, for: indexPath)
                cell.bind(to: viewModel)
                return cell
            }
        })
        
        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        output.userSelected.drive(onNext: { [weak self] viewModel in
            self?.tableView.indexPathsForVisibleRows?.forEach { self?.tableView.deselectRow(at: $0, animated: true) }
            self?.show(segue: .userDetail(viewModel: viewModel))
        }).disposed(by: rx.disposeBag)
        
        output.dismissKeyboard.subscribe(onNext: { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: rx.disposeBag)
    }
}
