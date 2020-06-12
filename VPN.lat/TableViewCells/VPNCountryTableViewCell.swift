//
//  VPNCountryTableViewCell.swift
//  VPN.lat
//
//  Created by user173177 on 5/30/20.
//  Copyright © 2020 user173177. All rights reserved.
//

import UIKit

class VPNCountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var backgroundHolderView: UIView!
    @IBOutlet weak var CircularImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        
        backgroundHolderView?.layer.borderWidth = 2.0
        backgroundHolderView?.layer.borderColor = UIColor.white.cgColor
        backgroundHolderView?.layer.cornerRadius = 5
        backgroundHolderView?.clipsToBounds = true
        
        makeRounded()
    }
    
     func makeRounded() {

        
        CircularImageView.layer.masksToBounds = false
        CircularImageView.layer.cornerRadius = CircularImageView.frame.width / 2
        CircularImageView.layer.borderWidth = 2
        CircularImageView.layer.borderColor = UIColor.white.cgColor
        CircularImageView.clipsToBounds = true
        
        
//    CircularImageView.layer.masksToBounds = true
//    CircularImageView.layer.cornerRadius = CircularImageView.bounds.width / 2
        
    }
//
// override var frame: CGRect {
//    get {
//        return super.frame
//    }
//    set (newFrame) {
//        var frame =  newFrame
//        frame.origin.y += 4
//        frame.size.height -= 2 * 5
//        super.frame = frame
//    }
//  }
}
