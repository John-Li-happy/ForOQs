//
//  ViewController.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/22/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import UIKit
//import ObjectiveC

class MainViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        createOQ()
    }
    
    func createOQ()
    {
        let blockO = BlockOperation
        {
            var result = 0
            
            for counter in 1...1000
            {
                result += counter
            }
        }
        
        let queue = OperationQueue()
        queue.qualityOfService = .background
//        queue.p
        
        queue.addOperation(blockO)
        
        
    }
}

extension MainViewController: NSObject
{
}

