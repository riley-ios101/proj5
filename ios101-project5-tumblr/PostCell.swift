//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Riley Dou on 3/24/24.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postSummary: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
