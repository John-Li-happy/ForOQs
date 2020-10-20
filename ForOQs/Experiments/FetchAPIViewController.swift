//
//  FetchAPIViewController.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/22/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import UIKit

class FetchAPIViewController: UIViewController
{

    @IBOutlet weak var firstImageV: UIImageView!
    @IBOutlet weak var secondImageV: UIImageView!
    @IBOutlet weak var thirdImageV: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var TrialLabel: UILabel!

    let operationQ = OperationQueue()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UIsettings()
        useData()
    }
    
    private func UIsettings()
    {
        self.view.bringSubviewToFront(loader)
        loader.isHidden = false
        loader.color = .black
        loader.backgroundColor = .blue
        loader.startAnimating()
        
        TrialLabel.text = "Not Done"
        firstImageV.image = UIImage(systemName: "goforward")
        secondImageV.image = UIImage(systemName: "goforward")
        thirdImageV.image = UIImage(systemName: "goforward")
    }
    
    private func useData()
    {
        guard let firstAPI = URL(string: "https://www.telecomreviewasia.com/images/stories/2019/12/Big-Data-Asias-newest-socio-economic-ally.jpg") else {return}
        guard let secondAPI  = URL(string: "https://www.verdict.co.uk/wp-content/uploads/2020/01/Leading-data-trends-in-big-data-600x450.jpg") else {return}
        guard let thirdAPI = URL(string: "https://bbvaopen4u.com/sites/default/files/styles/big-image/public/img/new/imagen_1_10.png") else {return}
        
        let firstAPIblockO = BlockOperation
        {
            OperationQueue.main.addOperation {
                self.firstImageV.image(url: firstAPI)
            }
        }
        firstAPIblockO.completionBlock =
        {
            self.completionJudgeNUI()
        }

        let secondAPIblockO = BlockOperation
        {
            self.fetchDataWithhandler(url: secondAPI) { (image) in
                OperationQueue.main.addOperation {
                    self.secondImageV.image = image
                    self.secondImageV.roundedConterView()
                }
            }
            
            OperationQueue.main.addOperation {

            }
        }
        
        secondAPIblockO.completionBlock =
        {
            self.completionJudgeNUI()
        }

        let thirdAPIblockO = BlockOperation
        {

            let thirdImage = self.fetchData(url: thirdAPI)
            OperationQueue.main.addOperation {
                self.thirdImageV.image = thirdImage
            }
        }
        
        thirdAPIblockO.completionBlock =
        {
            self.completionJudgeNUI()
        }
        
        firstAPIblockO.qualityOfService = .utility
        secondAPIblockO.qualityOfService = .utility
        thirdAPIblockO.qualityOfService = .utility
        

        operationQ.addOperations([firstAPIblockO, secondAPIblockO, thirdAPIblockO], waitUntilFinished: false)

        /* // Method One, dependencies
        let completionblockO = BlockOperation
        {
            OperationQueue.main.addOperation
            {
                self.loader.isHidden = true
                self.loader.stopAnimating()
                self.TrialLabel.text = "Done"
            }
        }

        let operationQ = OperationQueue()
        operationQ.maxConcurrentOperationCount = 4
        //dependency
        completionblockO.addDependency(firstAPIblockO)
        completionblockO.addDependency(secondAPIblockO)
        completionblockO.addDependency(thirdAPIblockO)
        
        operationQ.addOperations([firstAPIblockO, secondAPIblockO, thirdAPIblockO, completionblockO], waitUntilFinished: false)
        */
        
    }
    
    private func completionJudgeNUI()
    {
        if operationQ.operations.count == 0
        {
            OperationQueue.main.addOperation
            {
                self.loader.isHidden = true
                self.loader.stopAnimating()
                self.TrialLabel.text = "Done"
            }
        }
    }
    
    private func fetchData(url: URL) -> UIImage?
    {
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            let q = DispatchQueue.global(qos: DispatchQoS.QoSClass).async {
                
            }
            return image
        } catch {print("error in fetching", error.localizedDescription)}
        return nil
    }
    
    private func fetchDataWithhandler(url: URL, aSimpleHandler handler: @escaping (UIImage?) -> ())
    {
        do{
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            handler(image)
        }catch{print("error in fetching", error.localizedDescription)}

    }
    
}
extension UIImage
{
    
}

extension UIImageView
{
    public func image(url: URL)
    {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data
            {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
    
    public func roundedConterView()
    {
        self.layer.cornerRadius = 100
        self.clipsToBounds = true
    }
}
