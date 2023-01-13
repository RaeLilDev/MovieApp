//
//  PopularFilmTableViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 08/02/2022.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewMovies: UICollectionView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var type: String?
    
    var delegate: MovieItemDelegate?=nil
    
    var data: [MovieResult]? {
        didSet {
            if let _ = data {
                collectionViewMovies.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCollectionViewCell()
        
    }
    
    func registerCollectionViewCell() {
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        collectionViewMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }

    
}

extension PopularFilmTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = 120
        let itemHeight: CGFloat = collectionView.frame.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?[indexPath.row]
        if data?[indexPath.row].originalTitle != nil {
            delegate?.onTapMovie(id: item?.id ?? -1, type: "movie")
        } else {
            delegate?.onTapMovie(id: item?.id ?? -1, type: "tv")
        }
        
    }
    
}
