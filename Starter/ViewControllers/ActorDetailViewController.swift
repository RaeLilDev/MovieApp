//
//  ActorDetailViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 22/03/2022.
//

import UIKit

class ActorDetailViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var labelBiography: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var collectionViewCredits: UICollectionView!
    
    let networkAgent = MovieDBNetworkAgent.shared
    
    private let actorModel: ActorModel = ActorModelImpl.shared
    
    var actorId: Int = -1
    
    private var credits: [MovieResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        registerCollectionViewCell()
        
        fetchCredtits(id: actorId)
        
        fetchActorDetail(id: actorId)
        
    }
    
    private func fetchCredtits(id: Int) {
        actorModel.getCombinedCredits(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.credits = data
                self.collectionViewCredits.reloadData()
                
            case .failure(let message):
                print(message)
            }
            
        }

    }
    
    private func fetchActorDetail(id: Int) {
        actorModel.getActorDetail(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                
                self.bindData(data: data)
                
            case .failure(let message):
                print(message)
            }
            
        }
    }
    
    private func bindData(data: ActorDetailResponse) {
        labelName.text = data.name ?? ""
        labelBirthday.text = data.birthday ?? ""
        labelBiography.text = data.biography ?? ""
        let profileURL = "\(AppConstants.baseImageURL)/\(data.profilePath ?? "")"
        ivProfile.sd_setImage(with: URL(string: profileURL))
    }
    
    
    func registerCollectionViewCell() {
        collectionViewCredits.dataSource = self
        collectionViewCredits.delegate = self
        collectionViewCredits.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        collectionViewCredits.showsHorizontalScrollIndicator = false
        collectionViewCredits.showsVerticalScrollIndicator = false
    }
    
    @IBAction func onTapReadMore(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://www.google.com")!, options: [:], completionHandler: nil)
    }
    
}

extension ActorDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
        let item: MovieResult = credits[indexPath.row]
        cell.data = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = 120
        let itemHeight: CGFloat = collectionView.frame.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = credits[indexPath.row]
        if item.originalTitle != nil {
            navigateToMovieDetailViewController(movieId: item.id ?? -1, type: "movie")
        } else {
            navigateToMovieDetailViewController(movieId: item.id ?? -1, type: "tv")
        }
    }
    
    
}


