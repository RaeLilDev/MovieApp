//
//  PopularFilmCollectionViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 08/02/2022.
//

import UIKit

class PopularFilmCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelContentTitle: UILabel!
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var ratingStar: RatingControl!
    @IBOutlet weak var labelRating: UILabel!
    
    var data: MovieResult? {
        didSet {
            if let data = data {
                let title = data.originalTitle ?? data.originalName
                let posterPath = "\(AppConstants.baseImageURL)/\(data.posterPath ?? "")"
                
                labelContentTitle.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: posterPath))
                
                let voteAverage = data.voteAverage ?? 0.0
                labelRating.text = "\(voteAverage)"
                ratingStar.rating = Int(voteAverage * 0.5)
                
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
