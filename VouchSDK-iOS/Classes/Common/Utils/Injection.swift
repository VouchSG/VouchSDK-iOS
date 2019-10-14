//
//  Injection.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation


struct Injection {
    private static var mRepository: VouchRepository? = nil
    
    static func createRepository()-> VouchRepository? {
        if (Injection.mRepository == nil) {
            Injection.mRepository = VouchRepository(localDataSource: VouchLocalDataSource(), remoteDataSource: VouchRemoteDataSource())
        }
        
        return Injection.mRepository
    }
}
