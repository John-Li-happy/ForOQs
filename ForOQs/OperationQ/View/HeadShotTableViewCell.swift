//
//  HeadShotTableViewCell.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/30/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import UIKit

class HeadShotTableViewCell: UITableViewCell {

    @IBOutlet weak var headShotImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(image: UIImage?, name: String){ //optional para
        headShotImageView.image = image
        nameLabel.text = name
        
        headShotImageView?.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: headShotImageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: headShotImageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: headShotImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: headShotImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        contentView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }

}
