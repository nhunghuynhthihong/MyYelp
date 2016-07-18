//
//  FiltersDropdownTableViewCell.swift
//  MyYelp
//
//  Created by Nhung Huynh on 7/16/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

@objc protocol FiltersDropdownDelegate {
    optional func filtersDropdownDelegate(filtersDropdownTableViewCell: FiltersDropdownTableViewCell, didSet dropdownImg: UIImage)
}
class FiltersDropdownTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropdownImage: UIImageView!
    
    var delegate: FiltersDropdownDelegate?
//    var FiltersDropdown
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        delegate?.filtersDropdownDelegate!(self, didSet: dropdownImage.image!)
    }

}
