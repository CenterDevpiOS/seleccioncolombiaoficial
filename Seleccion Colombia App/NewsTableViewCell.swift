//
//  NewsTableViewCell.swift
//  Seleccion Colombia App
//
//  Created by Daniel Torres on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
