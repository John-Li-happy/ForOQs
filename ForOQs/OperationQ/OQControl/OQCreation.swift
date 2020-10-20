//
//  OQCreation.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/24/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import Foundation

class OperationQCustomControl {
    lazy var operationQ: OperationQueue = {
        let operationQ = OperationQueue()
        operationQ.maxConcurrentOperationCount = 1
        print("initialized Q")
        operationQ.qualityOfService = .utility
        return operationQ
    }()
    
    lazy var filteringQ: OperationQueue = {
        let operationQ = OperationQueue()
        operationQ.maxConcurrentOperationCount = 1
        operationQ.qualityOfService = .background
        return operationQ
    }()
}
