//
//  NewsTableViewCell.swift
//  Seleccion Colombia App
//
//  Created by Daniel Torres on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

protocol NewsTableViewCellDelegate: class {
    func seeMorePressed(newsCell: NewsTableViewCell)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    
    weak var delegate: NewsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if AppUtility.isBSC(){
            moreButton.backgroundColor = UIColor.clear
        moreButton.setTitleColor(Color.yellow.color, for: .normal)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func seeMore(_ sender: UIButton) {
        delegate?.seeMorePressed(newsCell: self)
    }
    
}
