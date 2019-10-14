//
//  Observable.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

internal class Observable<T: Equatable> {
    private let thread : DispatchQueue
    var property : T? {
        willSet(newValue) {
            if let newValue = newValue,  property != newValue {
                thread.async {
                    self.observe?(newValue)
                }
            }
        }
    }
    var observe : ((T) -> ())?
    init(_ value: T? = nil, thread dispatcherThread: DispatchQueue =     DispatchQueue.main) {
        self.thread = dispatcherThread
        self.property = value
    }
}
