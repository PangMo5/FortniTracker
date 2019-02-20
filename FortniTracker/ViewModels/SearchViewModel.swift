//
//  SearchViewModel.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import Moya
import Moya_ObjectMapper
import NSObject_Rx

class SearchViewModel: NSObject, ViewModelType {

    let provider = MoyaProvider<UserAPI>()
    
    struct Input {
        let inputText: Driver<String>
        let selection: Driver<SearchSectionItem>
        let tapGesture: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[SearchSection]>
        let dismissKeyboard: Observable<Void>
        let userSelected: Driver<UserDetailViewModel>
    }
    
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[SearchSection]>(value: [])
        
        let userSelected = PublishSubject<User>()
        
        let dismissKeyboard = Observable.of(input.selection.mapToVoid().asObservable(), input.tapGesture).merge()
        
        let inputText = BehaviorRelay(value: "")
        input.inputText.skip(1).debounce(0.5).distinctUntilChanged().asObservable()
            .bind(to: inputText).disposed(by: rx.disposeBag)
        
        input.selection.drive(onNext: { item in
            switch item {
            case .item( _):
                break
            case .user(let viewModel):
                userSelected.onNext(viewModel.user)
            }
        }).disposed(by: rx.disposeBag)
        
        inputText.skip(1).flatMapLatest { text -> Observable<[User]> in
            return self.provider.rx
                .request(.userID(username: text))
                .debug("searchUser")
                .mapObjectForBase(User.self)
                .asObservable()
                .toArray()
            }.subscribe(onNext: { items in
                let sectionItems = items.map { SearchSectionItem.user(viewModel: SearchUserCellViewModel(with: $0)) }
                elements.accept([SearchSection.users(title: "Users", items: sectionItems)])
            }).disposed(by: rx.disposeBag)
        
        let userDetail = userSelected.map({ (user) -> UserDetailViewModel in
            let viewModel = UserDetailViewModel(user: user)
            return viewModel
        }).asDriverOnErrorJustComplete()
        
        return Output(items: elements,
                      dismissKeyboard: dismissKeyboard,
                      userSelected: userDetail)
    }
}

