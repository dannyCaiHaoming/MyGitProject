//
//  RxCLLocationManagerDelegateProxy.swift
//  RxExample
//
//  Created by Carlos García on 8/7/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

public class RxCLLocationManagerDelegateProxy
    : DelegateProxy<CLLocationManager, CLLocationManagerDelegate>
    , DelegateProxyType
    , CLLocationManagerDelegate {

    public init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }

    internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
        didUpdateLocationsSubject.onNext(locations)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }

    deinit {
        self.didUpdateLocationsSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
}


public class RxCLLocationManagerDelegateProxy1 : DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
                                                 DelegateProxyType,
                                                 CLLocationManagerDelegate {
    
//    public init<Proxy: DelegateProxyType>(parentObject: ParentObject, delegateProxy: Proxy.Type)
//        where Proxy: DelegateProxy<ParentObject, Delegate>, Proxy.ParentObject == ParentObject, Proxy.Delegate == Delegate {
//        self._parentObject = parentObject
//        self._currentDelegateFor = delegateProxy._currentDelegate
//        self._setCurrentDelegateTo = delegateProxy._setCurrentDelegate
//
//        MainScheduler.ensureRunningOnMainThread()
//        #if TRACE_RESOURCES
//            _ = Resources.incrementTotal()
//        #endif
//        super.init()
//    }
    
    
    public init(locationManage: CLLocationManager) {
        super.init(parentObject: locationManage, delegateProxy: RxCLLocationManagerDelegateProxy1.self)
    }
    
    public static func registerKnownImplementations() {
        self.register(make: { RxCLLocationManagerDelegateProxy1(locationManage: $0) })
    }
    
    
}
