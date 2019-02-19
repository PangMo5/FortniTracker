//
//  Moya+Rx.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import ObjectMapper
import RxSwiftExt
import Toaster

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapObjectForBase<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            let cdData = try response.mapObject(Base.self)
            if cdData.error ?? false {
                if let reason = cdData.errorMessage {
                    Toast(text: reason, duration: Delay.long).show()
                }
                return Single.just(try response.mapObject(type, context: context))
            } else {
                return Single.just(try response.mapObject(type, context: context))
            }
        }
    }
    
    public func mapArrayForBase<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            let cdData = try response.mapObject(Base.self)
            if cdData.error ?? false {
                if let reason = cdData.errorMessage {
                    Toast(text: reason, duration: Delay.long).show()
                }
                return Single.just(try response.mapArray(type, context: context))
            } else {
                return Single.just(try response.mapArray(type, context: context))
            }
        }
    }
    
    public func mapObjectForBase<T: BaseMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            let cdData = try response.mapObject(Base.self)
            if cdData.error ?? false {
                if let reason = cdData.errorMessage {
                    Toast(text: reason, duration: Delay.long).show()
                }
                return Single.just(try response.mapObject(type, atKeyPath: keyPath, context: context))
            } else {
                return Single.just(try response.mapObject(type, atKeyPath: keyPath, context: context))
            }
        }
    }
    
    public func mapArrayForBase<T: BaseMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            let cdData = try response.mapObject(Base.self)
            if cdData.error ?? false {
                if let reason = cdData.errorMessage {
                    Toast(text: reason, duration: Delay.long).show()
                }
                return Single.just(try response.mapArray(type, atKeyPath: keyPath, context: context))
            } else {
                return Single.just(try response.mapArray(type, atKeyPath: keyPath, context: context))
            }
        }
    }
}

public enum ErrorToShow {
    case popup
    case popupForRetry
    case toast
}

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func processCheckForNetworkError(_ type: ErrorToShow = .toast) -> Single<Response> {
        return flatMap { response -> Single<Response> in
            do {
                return Single.just(try response.filterSuccessfulStatusCodes())
            } catch {
                switch type {
                case .popup:
                    Toast(text: error.localizedDescription, duration: Delay.long).show()
                case .toast:
                    Toast(text: error.localizedDescription, duration: Delay.long).show()
                default:
                    break
                }
                return Single.error(error)
            }
            }.retryWhen({ e -> Observable<Int> in
                return e.enumerated().flatMap({ (index, error) -> Observable<Int> in
                    if type != .popupForRetry {
                        return Observable.error(error)
                    } else {
                        return Observable<Int>.create { observer in
                            UIApplication.getTopMostViewController()?.showAlert(title: "Networking Error", message: error.localizedDescription, buttonTitles: ["cancel", "retry"], highlightedButtonIndex: 1, completion: { index in
                                if index == 0 {
                                    return observer.onError(error)
                                } else {
                                    return observer.onNext(1)
                                }
                            })
                            return Disposables.create()
                        }
                    }
                })
            })
    }
}
