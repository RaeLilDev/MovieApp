//
//  ShowCaseCollectionViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 09/02/2022.
//

import UIKit

class ShowCaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelContentTitle: UILabel!
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var labelReleaseDate: UILabel!
    
    var data: MovieResult? {
        didSet {
            if let data = data {
                let title = data.originalTitle ?? data.originalName
                let backdropPath = "\(AppConstants.baseImageURL)/\(data.backdropPath ?? "")"
                
                labelContentTitle.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: backdropPath))
                labelReleaseDate.text = data.releaseDate ?? ""
                
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
