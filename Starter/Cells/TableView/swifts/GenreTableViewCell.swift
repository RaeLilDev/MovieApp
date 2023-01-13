//
//  GenreTableViewCell.swift
//  Starter
//
//  Created by Ye Lynn Htet on 08/02/2022.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewMovie: UICollectionView!
    @IBOutlet weak var collectionViewGenre: UICollectionView!
    
    var genreList: [GenreVO]? {
        didSet {
            if let _ = genreList {
                
                collectionViewGenre.reloadData()
                
//                print(genreList)
                
                genreList?.removeAll(where: { genreVO -> Bool in
                    let genreId = genreVO.id

                    let results = movieListByGenre.filter {key, value -> Bool in
//                        print("Genre id is \(genreId) and value is \(value)")
                        return genreId == key
                    }
                    return results.count == 0
                })
                
                
                self.onTapGenre(genreId: genreList?.first?.id ?? 0)
                collectionViewGenre.reloadData()
            }
        }
    }
    
    var delegate: MovieItemDelegate?
    
    let movieList : [MovieResult] = [MovieResult]()
    
    var allMoviesAndSeries : [MovieResult] = [] {
        didSet {
            
            allMoviesAndSeries.forEach { movieSeries in
                movieSeries.genreIDS?.forEach({ genreId in
                    let key = genreId
                    
                    if var _ = movieListByGenre[key] {
                        movieListByGenre[key]!.insert(movieSeries)
                    } else {
                        movieListByGenre[key] = [movieSeries]
                    }
                })
            }
            
        }
    }
    
    private var selectedMovieList: [MovieResult] = []
    private var movieListByGenre: [Int: Set<MovieResult>] = [:]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCollectionViewCell()
    }

    func registerCollectionViewCell() {
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        collectionViewGenre.registerForCell(identifier: GenreCollectionViewCell.identifier)
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension GenreTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMovie {
            return selectedMovieList.count
        }
        return genreList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewMovie {
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = selectedMovieList[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            cell.data = genreList?[indexPath.row]
            
            cell.onTapItem = { genreId in
                self.onTapGenre(genreId: genreId)
            }
            return cell
        }
    }
    
    private func onTapGenre(genreId: Int) {
        self.genreList?.forEach { genreVO in
            if genreId == genreVO.id {
                genreVO.isSelected = true
            } else {
                genreVO.isSelected = false
            }
        }
        
        let movieList = self.movieListByGenre[genreId]
        self.selectedMovieList = movieList?.map { $0 } ?? [MovieResult]()
        self.collectionViewGenre.reloadData()
        self.collectionViewMovie.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewMovie {
            let itemWidth: CGFloat = 120
            let itemHeight: CGFloat = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        return CGSize(width: widthOfString(text: genreList?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14.0))+20, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewMovie {
            let item = selectedMovieList[indexPath.row]
            if item.originalTitle != nil {
                delegate?.onTapMovie(id: item.id ?? -1, type: "movie")
            } else {
                delegate?.onTapMovie(id: item.id ?? -1, type: "tv")
            }
        }
    }
    
    
    func widthOfString(text: String, font: UIFont) ->CGFloat {
        
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        
        return CGFloat(textSize.width)
    }
    
}
