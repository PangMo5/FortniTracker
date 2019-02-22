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
import RxSkeleton
import SwifterSwift

class UserDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 52
        }
    }
    
    lazy var dataSource = userDetailSectionDataSource()
    
    var viewModel: UserDetailViewModel!
    
    var output: UserDetailViewModel.Output!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func makeUI() {
        super.makeUI()
        
        tableView.isSkeletonable = true
        
        tableView.refreshControl = UIRefreshControl()
        
        themeService.rx
            .bind({ $0.background }, to: view.rx.backgroundColor)
            .bind({ $0.background }, to: tableView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        tableView.delegate = nil
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        let refresh = Observable.of(Observable.just(()), tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()).merge()
        
        let input = UserDetailViewModel.Input(refresh: refresh)
        
        output = viewModel.transform(input: input)
        
        let items = output.items.share()
        
        output.username.drive(self.navigationItem.rx.title).disposed(by: rx.disposeBag)
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        
        items.asObservable().map { _ in false }.bind(to: tableView.refreshControl!.rx.isRefreshing).disposed(by: rx.disposeBag)
        
        Observable.just(true).bind(to: view.rx.isSkeletoning(showAnimation: .topLeftBottomRight)).disposed(by: rx.disposeBag)
        
        items.mapTo(false).bind(to: view.rx.isSkeletoning(showAnimation: .topLeftBottomRight)).disposed(by: rx.disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                cell.hideSkeleton()
            }).disposed(by: rx.disposeBag)
    }
    
    func userDetailSectionDataSource() -> RxTableViewSkeletonedReloadDataSource<UserDetailSection> {
        return RxTableViewSkeletonedReloadDataSource<UserDetailSection>(configureCell: { dataSources, tableView, indexPath, item -> UITableViewCell in
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
        }, reuseIdentifierForRowAtIndexPath: { _, _, _ in
            return String(describing: UserDetailTableViewCell.self)
        })
    }
}

extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "UserDetailHeaderTableViewCell") as? UserDetailTableViewCell
        guard let section = output.items.value[safe: section] else { return nil }
        view?.bind(to: UserDetailCellViewModel(with: section.title, detailTitle: section.detailTitle))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = output.items.value[safe: section] else { return 0 }
        return 80
    }
}
