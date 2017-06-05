//
//  FiltersSeeAllTableViewCell.swift
//  MyYelp
//
//  Created by Nhung Huynh on 7/17/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

@objc protocol FiltersSeeAllDelegate {
    @objc optional func filtersSeeAllDelegate(_ filtersSeeAllTableViewCell: FiltersSeeAllTableViewCell, didSet title:String)
}
class FiltersSeeAllTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var delegate: FiltersSeeAllDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        delegate?.filtersSeeAllDelegate?(self, didSet: titleLabel.text!)
    }

}
