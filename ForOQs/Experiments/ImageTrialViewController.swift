//
//  ImageTrialViewController.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/25/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import UIKit

class ImageTrialViewController: UIViewController {

    @IBOutlet weak var trialImageV: UIImageView!
    @IBOutlet weak var firstFilteredImageV: UIImageView!
    @IBOutlet weak var secondFilteredImageV: UIImageView!
    
    var originalImageData = Data()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchOriginalImageData()
        filterFirstImage()
        filterSecondImage()
    }
    
    func fetchOriginalImageData()
    {
        guard let firstAPI = URL(string: "https://www.telecomreviewasia.com/images/stories/2019/12/Big-Data-Asias-newest-socio-economic-ally.jpg") else {return}
        do{
            let data = try Data(contentsOf: firstAPI)
            originalImageData = data
            trialImageV.image = UIImage(data: data)
        }catch{print("error in fetching data", error.localizedDescription)}
        
    }
    
    func filterFirstImage()
    {
        let originImage = UIImage(data: originalImageData)
        firstFilteredImageV.image = originImage?.addFilter(filter: .Noir)
    }
    
    func filterSecondImage()
    {
        let originImage = UIImage(data: originalImageData)
        secondFilteredImageV.image = originImage?.addFilter(filter: .Process)
    }

}


extension UIImage
{
    func addFilter(filter: FilterType) -> UIImage
    {
        let filter = CIFilter(name: filter.rawValue)
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        guard let ciImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!) else { return UIImage()}
       
        return UIImage(cgImage: ciImage)
    }
    
}
enum FilterType: String
{
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}
