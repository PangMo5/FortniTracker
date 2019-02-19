//
//  UserDetailViewController.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UserDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: UserDetailViewModel!
    
    var output: UserDetailViewModel.Output!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func makeUI() {
        super.makeUI()
        
        tableView.refreshControl = UIRefreshControl()
        
        themeService.rx
            .bind({ $0.background }, to: view.rx.backgroundColor)
            .bind({ $0.background }, to: tableView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let refresh = Observable.of(Observable.just(()), tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()).merge()
        
        let input = UserDetailViewModel.Input(refresh: refresh)
        
        output = viewModel.transform(input: input)
        
        output.items.asObservable().map { _ in false }.bind(to: tableView.refreshControl!.rx.isRefreshing).disposed(by: rx.disposeBag)
        
        output.username.drive(self.navigationItem.rx.title).disposed(by: rx.disposeBag)
        
        let dataSources = RxTableViewSectionedReloadDataSource<UserDetailSection>(configureCell: { dataSources, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withClass: UserDetailTableViewCell.self, for: indexPath)
            switch item {
            case .kd(let viewModel):
                cell.bind(to: viewModel)
            case .kills(let viewModel):
                cell.bind(to: viewModel)
            case .placetop1(let viewModel):
                cell.bind(to: viewModel)
            case .placetop2(let viewModel):
                cell.bind(to: viewModel)
            case .placetop3(let viewModel):
                cell.bind(to: viewModel)
            case .score(let viewModel):
                cell.bind(to: viewModel)
            }
            return cell
        })
        
        output.items.bind(to: tableView.rx.items(dataSource: dataSources)).disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
}

extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "UserDetailHeaderTableViewCell") as? UserDetailTableViewCell
        let section = output.items.value[section]
        view?.bind(to: UserDetailCellViewModel(with: section.title, detailTitle: section.detailTitle))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
