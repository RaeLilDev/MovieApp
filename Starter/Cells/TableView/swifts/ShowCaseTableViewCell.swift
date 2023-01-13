//
//  ShowCaseTableViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 09/02/2022.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblShowCases: UILabel!
    @IBOutlet weak var lblMoreShowCases: UILabel!
    @IBOutlet weak var collectionViewShowCases: UICollectionView!
    @IBOutlet weak var heightCollectionViewShowCases: NSLayoutConstraint!
    
    var delegate: MovieItemDelegate?=nil
    
    var data : [MovieResult]? {
        didSet {
            if let _ = data {
                collectionViewShowCases.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblMoreShowCases.underlineText(text: "MORE SHOWCASES")
        
        registerCollectionViewCell()
        
        initGestureRecognizer()
        
        let itemWidth: CGFloat = collectionViewShowCases.frame.width - 50
        let itemHeight: CGFloat = (itemWidth / 16) * 9
        heightCollectionViewShowCases.constant = itemHeight
    }
    
    
    func registerCollectionViewCell() {
        collectionViewShowCases.dataSource = self
        collectionViewShowCases.delegate = self
        collectionViewShowCases.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
    }
    
    private func initGestureRecognizer() {
        let tapGestureRecognizerMoreShowcases = UITapGestureRecognizer(target: self, action: #selector(tapMoreShowCases))
        lblMoreShowCases.isUserInteractionEnabled = true
        lblMoreShowCases.addGestureRecognizer(tapGestureRecognizerMoreShowcases)
    }
    
    @objc func tapMoreShowCases() {
        delegate?.onTapMoreShowCases()
    }

    
}

extension ShowCaseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as ShowCaseCollectionViewCell
        cell.data = data?[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?[indexPath.row]
        if data?[indexPath.row].originalTitle != nil {
            delegate?.onTapMovie(id: item?.id ?? -1, type: "movie")
        } else {
            delegate?.onTapMovie(id: item?.id ?? -1, type: "tv")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = collectionView.frame.width - 50
        let itemHeight: CGFloat = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ((scrollView.subviews[(scrollView.subviews.count-1)]).subviews[0]).backgroundColor = UIColor(named: "color_yellow")
    }
    
    
}
