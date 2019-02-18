//
//  StoreViewModel.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import Moya
import Moya_ObjectMapper

class StoreViewModel: ViewModelType {
    
    let provider = MoyaProvider<ItemAPI>()
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let refresh: Observable<Void>
        //let selection: Driver<asdd>
    }
    
    struct Output {
        let items: BehaviorRelay<[StoreSection]>
    }
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[StoreSection]>(value: [])
        
        let dailyElements = BehaviorRelay<[Item]>(value: [])
        let upcomingElements = BehaviorRelay<[Item]>(value: [])
        
        input.refresh.flatMapLatest({ [weak self] () -> Observable<[Item]> in
            guard let self = self else { return Observable.just([]) }
            return self.provider.rx
                .request(.dailyStore)
                .debug("dailyStore")
                .mapArrayForBase(Item.self, atKeyPath: "items")
                .asObservable()
        }).subscribe(onNext: { items in
            dailyElements.accept(items)
        }).disposed(by: disposeBag)
        
        input.refresh.flatMapLatest({ [weak self] () -> Observable<[Item]> in
            guard let self = self else { return Observable.just([]) }
            return self.provider.rx
                .request(.upcomingItems)
                .debug("upcomingItems")
                .mapArrayForBase(Item.self, atKeyPath: "items")
                .asObservable()
        }).subscribe(onNext: { items in
            upcomingElements.accept(items)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(dailyElements, upcomingElements).map { (daily, upcoming) -> [StoreSection] in
            var elements = [StoreSection]()
            
            let daily = daily.map({ daily -> StoreSectionItem in
                let cellViewModel = StoreCellViewModel(with: daily)
                return StoreSectionItem.daily(viewModel: cellViewModel)
            })
            if daily.isNotEmpty {
                elements.append(StoreSection.item(title: "Daily Store", items: daily))
            }
            
            let upcoming = upcoming.map({ upcoming -> StoreSectionItem in
                let cellViewModel = StoreCellViewModel(with: upcoming)
                return StoreSectionItem.upcoming(viewModel: cellViewModel)
            })
            if upcoming.isNotEmpty {
                elements.append(StoreSection.item(title: "Upcoming Items", items: upcoming))
            }
            
            return elements
        }.bind(to: elements).disposed(by: disposeBag)
        
        return Output(items: elements)
    }
    
    func request() -> Observable<[StoreCellViewModel]> {
        return provider.rx
            .request(.dailyStore)
            .mapArray(Item.self)
            .asObservable()
            .map { $0.map { StoreCellViewModel(with: $0) } }
    }
}
