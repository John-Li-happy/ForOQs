//
//  Model.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/24/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import Foundation
import UIKit

enum DownloadState {
    case prepared
    case finished
    case failed
    case filtered
}

class WorkerCustom {
    static func == (lhs: WorkerCustom, rhs: WorkerCustom) -> Bool {
        return true
    }
    
    var firstName: String
    var lastName: String
    var headShot: Data?
    var state: DownloadState
    var urlPath: String
    
    init(firstName: String, lastname: String, urlPath: String, state: DownloadState = .prepared) {
        self.firstName = firstName
        self.lastName = lastname
        self.urlPath = urlPath
        self.state = .prepared
    }
}
