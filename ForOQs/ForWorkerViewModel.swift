//
//  ForWorkerViewModel.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/24/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import UIKit

class ForWorkersViewModel {
    static let shared = ForWorkersViewModel()
    private init(){}
    var dataSourceContainer = [WorkerCustom]()
    var oprationCustomControl = OperationQCustomControl()
    
    func fetchGeneralData(handler: @escaping ([WorkerCustom]) -> ()) {
        guard let url = AppConstant.url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                guard let dataKeyValue = json?["data"] as? [[String: Any]] else { return }
                
                for item in dataKeyValue {
                    guard let firstName = item["first_name"] as? String else { return }
                    guard let lastName = item["last_name"] as? String else { return }
                    let url = item["avatar"] as! String
                    let singleWorkerContainer = WorkerCustom(firstName: firstName, lastname: lastName, urlPath: url, state: .prepared)
                    self.dataSourceContainer.append(singleWorkerContainer)
                }
                self.dataSourceContainer.append(contentsOf: self.dataSourceContainer)
                handler(self.dataSourceContainer)
            } catch {
                print("error in parsing", error.localizedDescription)
            }
        }.resume()
    }
    
    func startDownloadImageOperation(workerCustom: WorkerCustom, handler: @escaping (IndexPath) -> ()) { //scroll to cancel
        if workerCustom.state == .prepared {
            let downloadOperation = DownloadImageOperation(workerCustom: workerCustom)
            print("download starts on ")
            oprationCustomControl.operationQ.addOperations([downloadOperation], waitUntilFinished: false)
            
            downloadOperation.completionBlock = {
                guard let currentWorkingIndexRow = self.dataSourceContainer.firstIndex(where: {$0 === workerCustom}) else {
                    print("failed")
                    return
                }
                let currentIndexPath = IndexPath(row: Int(currentWorkingIndexRow), section: 0)
                
                print("data returnning at", currentIndexPath)
                print("downloadComptete")
                
                if downloadOperation.isCancelled { return }
                handler(currentIndexPath)
            }
        }
    }
    
    func startFilteringOperation(workerCustom: WorkerCustom, handler: @escaping (IndexPath) -> ()) {
        if workerCustom.state == .finished {
            print("filter started", Thread.current)
            let filterOperation = ImageFilterOperation(workerCustom: workerCustom)
            oprationCustomControl.filteringQ.addOperation(filterOperation)
            
            filterOperation.completionBlock = {
                guard let currentWorkingIndexRow = self.dataSourceContainer.firstIndex(where: {$0 === workerCustom}) else {
                    print("failed")
                    return}
                
                let currentIndexPath = IndexPath(row: Int(currentWorkingIndexRow), section: 0)
                print("data returnning at ", currentIndexPath)
                print("filter done", Thread.current)
                handler(currentIndexPath)
            }
        }
    }
}
