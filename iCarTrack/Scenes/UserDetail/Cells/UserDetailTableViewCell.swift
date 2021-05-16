//
//  UserTableViewCell.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//

import UIKit
import Domain

class UserDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!

    var item:CellData? {
        didSet {
            self.titleLbl.text = item?.title
            self.detailLbl.text = item?.text
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
