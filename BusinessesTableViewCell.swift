//
//  BusinessesTableViewCell.swift
//  MyYelp
//
//  Created by Nhung Huynh on 7/15/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImg: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewImg: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            if business.imageURL != nil {
                restaurantImg.alpha = 1.0
                //                UIView.animateWithDuration(0.3, animations: {
                //                    self.restaurantImageView.setImageWithURL(self.business.imageURL!)
                //                    self.restaurantImageView.alpha = 1.0
                //                    }, completion: nil)
                
                restaurantImg.setImageWith(self.business.imageURL!)
                
            } else {
                restaurantImg.image = UIImage(named: "noImage")
            }
            nameLabel.text = business?.name
            distanceLabel.text = business?.distance
            reviewImg.setImageWith(business.ratingImageURL!)
            guard let reviewNumber = business.reviewCount else {
                reviewCountLabel.text = "No review"
                return
            }
            reviewCountLabel.text = "\(reviewNumber) review(s)"
            addressLabel.text = business?.address
            categoryLabel.text = business?.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
