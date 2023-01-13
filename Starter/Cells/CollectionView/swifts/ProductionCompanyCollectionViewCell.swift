//
//  ProductionCompanyCollectionViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 19/03/2022.
//

import UIKit

class ProductionCompanyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var labelCompanyName: UILabel!
    
    var data: ProductionCompany? {
        didSet {
            if let data = data {
                
                
                let url = "\(AppConstants.baseImageURL)\(data.logoPath ?? "")"
                imageViewBackdrop.sd_setImage(with: URL(string: url))
                
                if data.logoPath == nil || data.logoPath!.isEmpty {
                    labelCompanyName.text = data.name
                } else {
                    labelCompanyName.text = "" // no text
                }
                
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
