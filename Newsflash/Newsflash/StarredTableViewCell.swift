//
//  StarredTableViewCell.swift
//  Newsflash
//
//  Created by Zeyana Ayesha Musthafa on 11/29/17.
//  Copyright © 2017 iOSDecal. All rights reserved.
//

import UIKit

class StarredTableViewCell: UITableViewCell {

    @IBOutlet var titlelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
