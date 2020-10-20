//
//  ViewController.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/22/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.



import UIKit
//import ObjectiveC
class Messenger {

    private var messages: [String] = []

    var queue = DispatchQueue(label: "This messages.queue", attributes: .concurrent)
    
    private var backGroundQ = DispatchQueue.global(qos: .background)

    var lastMessage: String? {
        print("this is on ", Thread.current)
        return backGroundQ.sync {
            messages.last
        }
    }

    func postMessage(aNewMessage newMessage: String) {
        backGroundQ.sync(flags: .barrier) {
            messages.append(newMessage)
            print("this is on", Thread.current)
        }
    }
}

class MainViewController: UIViewController
{
    @IBOutlet weak var trialLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        createOQ()
//        forOrders()
        let messenger = Messenger()
        
        messenger.postMessage(aNewMessage: "Newmessage")
        
        print(String(messenger.lastMessage ?? ""))
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func createOQ()
    {
        
        let blockO = BlockOperation //Original Concurrent
        {
            print("first started")
                for counter in 1...10
                {
 
//                    print(counter)
                }
            OperationQueue.main.addOperation
            {
//                self.calculateResultLabel.text = String(result)
            }
            print("One thread\(Thread.current)")
        }
        
        let blockOTwo = BlockOperation
        {
          print("second started")
            for counter in 11...15
            {
//                print(counter)
            }
            OperationQueue.main.addOperation
            {
//                self.calculateResultLabel.text = String(result)
            }
            print("Two thread\(Thread.current)")
        }
        
        let blockOThree = BlockOperation
        {
            print("three started")
            for counter in 121...125
            {
//                print(counter)
            }
            OperationQueue.main.addOperation
            {
//                self.calculateResultLabel.text = String(result)
            }
            print(" Three thread\(Thread.current)")

        }

         let blockOFour = BlockOperation
        {
            print("four started")
            for counter in 1001...1005
            {
//                print(counter)
            }
            OperationQueue.main.addOperation
            {
//                self.calculateResultLabel.text = String(result)
            }
            print("Four thread\(Thread.current)")
        }
        blockO.completionBlock = {
            print("first Accomplished", DispatchTime.now())
        }
        blockOTwo.completionBlock = {
            print("Two Accomplished", DispatchTime.now())
        }
        blockOThree.completionBlock = {
            print("three Accomplished", DispatchTime.now())
        }
        blockOFour.completionBlock = {
            print("four Accomplished", DispatchTime.now())
        }
//        blockOTwo.qualityOfService = .userInteractive
        
//        blockO.start()//not recommand
        let oqueue = OperationQueue()
        oqueue.maxConcurrentOperationCount = 1 //concurrent
        
//        oqueue.qualityOfService = .background
//        oqueue.addOperation(blockO)
//        oqueue.addOperation(blockOTwo)
//        oqueue.addOperation(blockOThree)
        
//        blockOTwo.addDependency(blockO)
//        blockOThree.addDependency(blockOTwo)
//        blockOFour.queuePriority = .veryHigh
//        blockOThree.queuePriority = .veryHigh
        
        oqueue.addOperations([blockO, blockOTwo, blockOThree, blockOFour], waitUntilFinished: false)
        //main block ture???
    }
    
    
    func forOrders()
    {
        let operationQ = OperationQueue()
        let bgQ1 = BlockOperation{
            for _ in 1...5
            {
                print("One")
            }
        }
//        bgQ1.queuePriority = .normal
        let bgQ2 = BlockOperation{
            for _ in 1...5
            {
                print("Two")
            }
        }
        let bgQ3 = BlockOperation{
            for _ in 1...5
            {
                print("Three")
            }
        }
        let bgQ4 = BlockOperation{
            for _ in 1...5
            {
                print("Four")
            }
        }
        bgQ4.queuePriority = .veryHigh
        bgQ4.qualityOfService = .userInteractive
        operationQ.addOperation {
            print("welllllll")
        }
        operationQ.maxConcurrentOperationCount = 1
        operationQ.addOperations([bgQ2, bgQ1, bgQ3, bgQ4], waitUntilFinished: true)

        
    }
    
}


