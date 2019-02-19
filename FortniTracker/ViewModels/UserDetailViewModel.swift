//
//  UserDetailViewModel.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Moya
import Moya_ObjectMapper

class UserDetailViewModel: NSObject, ViewModelType {
    
    let provider = MoyaProvider<UserAPI>()
    
    struct Input {
        let refresh: Observable<Void>
        //let selection: Driver<asdd>
    }
    
    struct Output {
        let items: BehaviorRelay<[UserDetailSection]>
        let username: Driver<String?>
    }
    
    let user: BehaviorRelay<User?>
    
    init(user: User?) {
        self.user = BehaviorRelay(value: user)
    }
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[UserDetailSection]>(value: [])
        
        input.refresh.flatMapLatest({ [weak self] () -> Observable<UserDetail> in
            guard let self = self,
                let id = self.user.value?.uid else { return Observable.just(UserDetail()) }
            return self.provider.rx
                .request(.userStats(userID: id))
                .debug("userDetail")
                .processCheckForNetworkError(.popupForRetry)
                .mapObjectForBase(UserDetail.self)
                .asObservable()
        }).subscribe(onNext: { item in
            
            var sectionElements = [UserDetailSection]()
            //total
            if let totalData = item.overallData {
                let totalKD = UserDetailSectionItem.kd(viewModel: UserDetailCellViewModel(with: "K/D", detailTitle: self.kd(kill: totalData.kills, matchs: totalData.matchesplayed)))
                let totalKills = UserDetailSectionItem.kills(viewModel: UserDetailCellViewModel(with: "Kills", detailTitle: totalData.kills?.string))
                let totalPlacetop1 = UserDetailSectionItem.placetop1(viewModel: UserDetailCellViewModel(with: "Wins", detailTitle: totalData.placetop1?.string))
                let totalScore = UserDetailSectionItem.score(viewModel: UserDetailCellViewModel(with: "Score", detailTitle: totalData.score?.string))
                
                sectionElements.append(UserDetailSection.total(title: "Total", detailTitle: "\((totalData.matchesplayed ?? 0)) matches", items: [totalKD, totalKills, totalPlacetop1, totalScore]))
            }
            
            //solo
            
            if let soloData = item.data?.defaultsolo {
                let soloKD = UserDetailSectionItem.kd(viewModel: UserDetailCellViewModel(with: "K/D", detailTitle: self.kd(kill: soloData.kills, matchs: soloData.matchesplayed)))
                let soloKills = UserDetailSectionItem.kills(viewModel: UserDetailCellViewModel(with: "Kills", detailTitle: soloData.kills?.string))
                let soloPlacetop1 = UserDetailSectionItem.placetop1(viewModel: UserDetailCellViewModel(with: "Wins", detailTitle: soloData.placetop1?.string))
                let soloPlacetop2 = UserDetailSectionItem.placetop2(viewModel: UserDetailCellViewModel(with: "Top10", detailTitle: soloData.placetop10?.string))
                let soloPlacetop3 = UserDetailSectionItem.placetop3(viewModel: UserDetailCellViewModel(with: "Top25", detailTitle: soloData.placetop25?.string))
                let soloScore = UserDetailSectionItem.score(viewModel: UserDetailCellViewModel(with: "Score", detailTitle: soloData.score?.string))
                
                sectionElements.append(UserDetailSection.solo(title: "Solo", detailTitle: "\(soloData.matchesplayed ?? 0) matches\n\(soloData.minutesplayed ?? 0) minutes", items: [soloKD, soloKills, soloPlacetop1, soloPlacetop2, soloPlacetop3, soloScore]))
            }
            
            //duo
            
            if let duoData = item.data?.defaultduo {
                let duoKD = UserDetailSectionItem.kd(viewModel: UserDetailCellViewModel(with: "K/D", detailTitle: self.kd(kill: duoData.kills, matchs: duoData.matchesplayed)))
                let duoKills = UserDetailSectionItem.kills(viewModel: UserDetailCellViewModel(with: "Kills", detailTitle: duoData.kills?.string))
                let duoPlacetop1 = UserDetailSectionItem.placetop1(viewModel: UserDetailCellViewModel(with: "Wins", detailTitle: duoData.placetop1?.string))
                let duoPlacetop2 = UserDetailSectionItem.placetop2(viewModel: UserDetailCellViewModel(with: "Top5", detailTitle: duoData.placetop5?.string))
                let duoPlacetop3 = UserDetailSectionItem.placetop3(viewModel: UserDetailCellViewModel(with: "Top12", detailTitle:duoData.placetop12?.string))
                let duoScore = UserDetailSectionItem.score(viewModel: UserDetailCellViewModel(with: "Score", detailTitle: duoData.score?.string))
                
                sectionElements.append(UserDetailSection.duo(title: "Duo", detailTitle: "\(duoData.matchesplayed ?? 0) matches\n\(duoData.minutesplayed ?? 0) minutes", items: [duoKD, duoKills, duoPlacetop1, duoPlacetop2, duoPlacetop3, duoScore]))
            }
            
            //squad
            
            if let squadData = item.data?.defaultsquad {
                let squadKD = UserDetailSectionItem.kd(viewModel: UserDetailCellViewModel(with: "K/D", detailTitle: self.kd(kill: squadData.kills, matchs: squadData.matchesplayed)))
                let squadKills = UserDetailSectionItem.kills(viewModel: UserDetailCellViewModel(with: "Kills", detailTitle: squadData.kills?.string))
                let squadPlacetop1 = UserDetailSectionItem.placetop1(viewModel: UserDetailCellViewModel(with: "Wins", detailTitle: squadData.placetop1?.string))
                let squadPlacetop2 = UserDetailSectionItem.placetop2(viewModel: UserDetailCellViewModel(with: "Top3", detailTitle: squadData.placetop3?.string))
                let squadPlacetop3 = UserDetailSectionItem.placetop3(viewModel: UserDetailCellViewModel(with: "Top6", detailTitle: squadData.placetop6?.string))
                let squadScore = UserDetailSectionItem.score(viewModel: UserDetailCellViewModel(with: "Score", detailTitle: squadData.score?.string))
                
                sectionElements.append(UserDetailSection.squad(title: "Squad", detailTitle: "\(squadData.matchesplayed ?? 0) matches\n\(squadData.minutesplayed ?? 0) minutes", items: [squadKD, squadKills, squadPlacetop1, squadPlacetop2, squadPlacetop3, squadScore]))
            }
            
            elements.accept(sectionElements)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: elements,
                      username: Driver.just(user.value?.username))
    }
    
    fileprivate func kd(kill: Int?, matchs: Int?) -> String {
        return String(format: "%.2f", arguments: [(((kill ?? 0) == 0) ? 0 : (kill ?? 0).float / (matchs ?? 0).float)])
    }
}

