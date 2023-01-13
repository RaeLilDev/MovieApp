//
//  ActorCollectionViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 09/02/2022.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var ivHeartFill: UIImageView!
    @IBOutlet weak var imageViewActorProfile: UIImageView!
    @IBOutlet weak var labelActorName: UILabel!
    @IBOutlet weak var labelKnownForDepartment: UILabel!
    
    public var delegate: ActorActionDelegate?=nil
    
    var data : ActorInfoResponse? {
        didSet {
            if let data = data {
                let posterPath = "\(AppConstants.baseImageURL)/\(data.profilePath ?? "")"
                imageViewActorProfile.sd_setImage(with: URL(string: posterPath), completed: nil)
                labelActorName.text = data.name
                labelKnownForDepartment.text = data.knownForDepartment
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initGestureRecognizers()
        
    }
    
    private func initGestureRecognizers() {
        let tapGestureForFavourite = UITapGestureRecognizer(target: self, action: #selector(onTapFavorite))
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestureForFavourite)
        
        let tapGestureForUnFavourite = UITapGestureRecognizer(target: self, action: #selector(onTapUnFavorite))
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestureForUnFavourite)
    }
    
    @objc func onTapFavorite() {
        ivHeartFill.isHidden = true
        ivHeart.isHidden = false
        delegate?.onTapFavorite(isFavorite: true)
    }
    
    @objc func onTapUnFavorite() {
        ivHeart.isHidden = true
        ivHeartFill.isHidden = false
        delegate?.onTapFavorite(isFavorite: false)
    }

}
