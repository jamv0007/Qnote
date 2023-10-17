//
//  NoteCellView.swift
//  Qnote
//
//  Created by Jose Antonio on 15/10/23.
//

import UIKit

class NoteCellView: UITableViewCell {

    @IBOutlet var textLabelShow: UILabel!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
