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
import RxSkeleton

class StoreListViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = StoreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeUI() {
        super.makeUI()
        
        view.isSkeletonable = true
        collectionView.isSkeletonable = true
        collectionView.refreshControl = UIRefreshControl()
        
        themeService.rx
            .bind({ $0.background }, to: view.rx.backgroundColor)
            .bind({ $0.background }, to: collectionView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        collectionView.delegate = nil
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        let refresh = Observable.of(Observable.just(()), collectionView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()).merge().debug("refresh")
        
        let input = StoreViewModel.Input(refresh: refresh)
        
        let output = viewModel.transform(input: input)
        
        let items = output.items.share()
        
        items
            .bind(to: collectionView.rx.items(dataSource: storeSectionDataSource()))
            .disposed(by: rx.disposeBag)
        
        items.mapTo(false).debug("refreshControl").bind(to: collectionView.refreshControl!.rx.isRefreshing).disposed(by: rx.disposeBag)
        
        Observable.just(true).bind(to: view.rx.isSkeletoning(showAnimation: .topLeftBottomRight, collectionView: collectionView)).disposed(by: rx.disposeBag)
        items.mapTo(false).bind(to: view.rx.isSkeletoning(showAnimation: .topLeftBottomRight, collectionView: collectionView)).disposed(by: rx.disposeBag)
        //items.mapTo(false).bind(to: view.rx.isSkeletoning(showAnimation: .topLeftBottomRight)).disposed(by: rx.disposeBag)
        
    }
    
    func storeSectionDataSource() -> RxCollectionViewSkeletonedReloadDataSource<StoreSection> {
        return RxCollectionViewSkeletonedReloadDataSource(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            
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
        }, reuseIdentifierForItemAtIndexPath: { _, _, _ in
            return String(describing: StoreItemCollectionViewCell.self)
        })
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

