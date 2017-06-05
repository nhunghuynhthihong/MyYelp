//
//  FiltersSwitchTableViewCell.swift
//  MyYelp
//
//  Created by Nhung Huynh on 7/16/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

@objc protocol FiltersSwitchDelegate {
    @objc optional func filtersSwitchDelegate(_ filtersSwitchTableViewCell: FiltersSwitchTableViewCell, didSet isSelected: Bool)
}
class FiltersSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    
//    var mainSwitch: UISwitch!
    
    var delegate: FiltersSwitchDelegate?
    var isSwitched = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        mainSwitch = UISwitch(frame: CGRect(x: 100, y: 100, width: 0, height: 0))
//        mainSwitch.offImage = UIImage(named: "switch")
//        mainSwitch.onImage = UIImage(named: "switch")
//        mainSwitch.addTarget(self, action: "switchIsChanged", forControlEvents: .ValueChanged)
//        optionSwitch.addSubview(mainSwitch)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        optionSwitch.onImage = UIImage(named: "expand_arrow")
//        optionSwitch.offImage = UIImage(named: "expand_arrow")
        
    }
//    func switchIsChanged(sender: UISwitch){
//        isSwitched = sender.on
//        delegate?.filtersSwitchDelegate!(self, didSet: isSwitched)
//    }
    @IBAction func onSWitch(_ sender: UISwitch) {
        isSwitched = sender.isOn
        delegate?.filtersSwitchDelegate!(self, didSet: isSwitched)
        
    }

}
