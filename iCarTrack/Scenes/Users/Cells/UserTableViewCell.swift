//
//  UserTableViewCell.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//

import UIKit
import Domain

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var item:UserDetail? {
        didSet {
            self.titleLbl.text = item?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
