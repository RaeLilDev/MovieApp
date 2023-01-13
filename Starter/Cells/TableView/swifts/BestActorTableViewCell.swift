//
//  BestActorTableViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 09/02/2022.
//

import UIKit

class BestActorTableViewCell: UITableViewCell, ActorActionDelegate {
    

    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var lblMoreActors: UILabel!
    
    var data: [ActorInfoResponse]? {
        didSet {
            if let _ = data {
                collectionViewActors.reloadData()
            }
        }
    }
    
    var delegate: MovieItemDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblMoreActors.underlineText(text: "MORE ACTORS")
        
        initGestureRecognizer()
        
        registerCollectionViewCell()
    }

    func registerCollectionViewCell() {
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
    }
    
    func initGestureRecognizer() {
        let tapGestureForMoreActors = UITapGestureRecognizer(target: self, action: #selector(onTapMoreActors))
        lblMoreActors.isUserInteractionEnabled = true
        lblMoreActors.addGestureRecognizer(tapGestureForMoreActors)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTapFavorite(isFavorite: Bool) {
        debugPrint("isFavorite => \(isFavorite)")
    }
    
    @objc func onTapMoreActors() {
        delegate?.onTapMoreActors()
    }
    
}

extension BestActorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: ActorCollectionViewCell.identifier, indexPath: indexPath) as ActorCollectionViewCell
        cell.delegate = self
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?[indexPath.row]
        delegate?.onTapActor(id: item?.id ?? -1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = 120
        let itemHeight: CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
        //return CGSize(width: collectionView.frame.width/2.5, height: CGFloat(200))
    }
    
    
}
