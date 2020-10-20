//
//  Operations.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/24/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import Foundation
import UIKit

class DownloadWorkerListOperation: Operation
{
//    var dataSourceContainer: [WorkerCustom]?
//    
//    override func main()
//    {
//        guard let url = AppConstant.url else { return }
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//        guard let data = data, error == nil else { return }
//        do{
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
//            guard let dataKeyValue = json?["data"] as? [[String: Any]] else { return }
//            
//            for item in dataKeyValue
//            {
//                let firstName = item["first_name"] as! String
//                let lastName = item["last_name"] as! String
//                let url = item["avatar"] as! String
//                let singleWorkerContainer = WorkerCustom(firstName: firstName, lastname: lastName, urlPath: url, state: .prepared)
//                self.dataSourceContainer?.append(singleWorkerContainer)
//            }
////            self.dataSourceContainer!.append(contentsOf: self.dataSourceContainer!)
//
////            handler(self.dataSourceContainer)
//        }catch{print("error in parsing", error.localizedDescription)}
//    }.resume()
//    }
    
}

//class ParsingOperation: Operation
//{
//
//}

class DownloadImageOperation: Operation {
    private var workerCustom: WorkerCustom

    init(workerCustom: WorkerCustom) {
        self.workerCustom = workerCustom
    }

    override func main() {
        if workerCustom.state == .prepared {
            print("Gen-Oper is on \(Thread.current)")
            guard !isCancelled else {self.workerCustom.state = .failed; return}

            guard let url = URL(string: self.workerCustom.urlPath) else {
                print("error in url")
                self.workerCustom.state = .failed
                return}
         
            do{
                let imageData = try Data(contentsOf: url)
                self.workerCustom.headShot = imageData
            } catch {
                print("error in image fetching", error.localizedDescription)
                self.workerCustom.state = .failed
            }

            guard !isCancelled else {
                self.workerCustom.state = .failed;
                print("error in url")
                return}

            self.workerCustom.state = .finished
        }
    }
}

class ImageFilterOperation: Operation {
    private var workerCustom: WorkerCustom
    
    init(workerCustom: WorkerCustom) {
        self.workerCustom = workerCustom
    }
    
    override func main() {
        if workerCustom.state == .finished {
            print("Filt-Oper is on \(Thread.current)")
            guard let data = workerCustom.headShot else{ return }
            guard let readyImage = UIImage(data: data) else{ return }
            let filteredImage = readyImage.addFilter(filter: .Noir)
            let dataBack = filteredImage.pngData()
            workerCustom.headShot = dataBack
            workerCustom.state = .filtered
        }      
    }
}
