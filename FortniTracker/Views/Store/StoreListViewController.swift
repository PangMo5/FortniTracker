//
//  StoreListViewController.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SwifterSwift
import RxSwiftExt

class StoreListViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = StoreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeUI() {
        collectionView.refreshControl = UIRefreshControl()
        
        themeService.rx
            .bind({ $0.background }, to: view.rx.backgroundColor)
            .bind({ $0.background }, to: collectionView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let refresh = Observable.of(Observable.just(()), collectionView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()).merge()
        
        let input = StoreViewModel.Input(refresh: refresh)
        
        let output = viewModel.transform(input: input)
        
        output.items.asObservable().map { _ in false }.bind(to: collectionView.refreshControl!.rx.isRefreshing).disposed(by: rx.disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<StoreSection>(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withClass: StoreItemCollectionViewCell.self, for: indexPath)
            
            switch item {
            case .daily(let viewModel):
                cell.bind(to: viewModel)
            case .upcoming(let viewModel):
                cell.bind(to: viewModel)
            }
            
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: StoreListHeaderView.self, for: indexPath)
            let section = dataSource[indexPath.section]
            headerView.titleLabel.text = section.title
            themeService.rx
                .bind({ $0.headerBackground }, to: headerView.rx.backgroundColor)
                .bind({ $0.text }, to: headerView.titleLabel.rx.textColor)
                .disposed(by: headerView.rx.disposeBag)
            return headerView
        })
        
        output.items.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
}

extension StoreListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SwifterSwift.screenWidth - 24) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 40)
    }
}

