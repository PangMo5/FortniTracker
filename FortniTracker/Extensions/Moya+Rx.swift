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
import Toast_Swift

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapObjectForBase<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            let cdData = try response.mapObject(Base.self)
            if cdData.error ?? false {
                if let reason = cdData.errorMessage {
                    UIApplication.getTopMostViewController()?.view.makeToast(reason)
                }
                return Single.error(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : cdData.errorMessage ?? ""]))
            } else {
                return Single.just(try response.mapObject(type, context: context))
            }
        }
    }
    
    public func mapArrayForBase<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            let cdData = try response.mapObject(Base.self)
            if cdData.error ?? false {
                if let reason = cdData.errorMessage {UIApplication.getTopMostViewController()?.view.makeToast(reason)
                }
                return Single.error(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : cdData.errorMessage ?? ""]))
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
                    UIApplication.getTopMostViewController()?.view.makeToast(reason)
                }
                return Single.error(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : cdData.errorMessage ?? ""]))
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
                    UIApplication.getTopMostViewController()?.view.makeToast(reason)
                }
                return Single.error(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : cdData.errorMessage ?? ""]))
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
                    UIApplication.getTopMostViewController()?.view.makeToast(error.localizedDescription)
                case .toast:
                    UIApplication.getTopMostViewController()?.view.makeToast(error.localizedDescription)
                default:
                    break
                }
                return Single.error(error)
            }
            }.retryWhen({ e -> Observable<Void> in
                return e.flatMap({ error -> Observable<Void> in
                    if type != .popupForRetry {
                        return Observable.error(error)
                    } else {
                        return Observable<Void>.create { observer in
                            UIApplication.getTopMostViewController()?.showAlert(title: "Networking Error", message: error.localizedDescription, buttonTitles: ["cancel", "retry"], highlightedButtonIndex: 1, completion: { index in
                                if index == 0 {
                                    return observer.onError(error)
                                } else {
                                    return observer.onNext(())
                                }
                            })
                            return Disposables.create()
                        }
                    }
                })
            })
    }
}
