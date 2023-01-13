//
//  MovieDetailViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 05/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnRateMovie: UIButton!
    @IBOutlet weak var labelReleasedYear: UILabel!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieDescription: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var viewRatingCount: RatingControl!
    @IBOutlet weak var labelVoteCount: UILabel!
    @IBOutlet weak var labelAboutMovieTitle: UILabel!
    @IBOutlet weak var labelGenreCollectionString: UILabel!
    @IBOutlet weak var labelProductionCountriesString: UILabel!
    @IBOutlet weak var labelAboutMovieDescription: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var imageViewMoviePoster: UIImageView!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var collectionViewProductionCompanies: UICollectionView!
    @IBOutlet weak var collectionViewSimilarContent: UICollectionView!
    @IBOutlet weak var viewProductionCompanies: UIView!
    @IBOutlet weak var buttonPlayTrailer: UIButton!
    
    //MARK: - Properties
    var viewModel: MovieDetailViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        viewModel.fetchAllData()
        
        bindObservers()
        
    }
    
    
    //MARK: - init view
    
    private func initView() {
        registerCollectionViewCell()
        
        btnRateMovie.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnRateMovie.layer.borderWidth = 2
        buttonPlayTrailer.isHidden = true
    }
    
    func registerCollectionViewCell() {
        
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        
        collectionViewSimilarContent.delegate = self
        collectionViewSimilarContent.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        collectionViewSimilarContent.showsHorizontalScrollIndicator = false
        collectionViewSimilarContent.showsVerticalScrollIndicator = false
        
        collectionViewProductionCompanies.delegate = self
        collectionViewProductionCompanies.registerForCell(identifier: ProductionCompanyCollectionViewCell.identifier)
        collectionViewProductionCompanies.showsHorizontalScrollIndicator = false
        collectionViewProductionCompanies.showsVerticalScrollIndicator = false
        
    }
    
    
    private func bindObservers() {
        
        addMovieDetailBindingObserver()
        
        addCollectionViewBindingObserver()
        
        addItemSelectedObserver()
        
    }
    
    
    //MARK: - OnTapCallbacks
    @IBAction func onClickPlayTrailer(_ sender: UIButton) {
        
        viewModel.trailerResultItems
            .bind { [weak self] trailers in
                guard let self = self else { return }
                let item = trailers.first
                let youtubeId = item?.key ?? ""
                let playerVC = YouTubePlayerViewController()
                playerVC.youtubeId = youtubeId
                self.present(playerVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    //MARK: - Bind Data
    private func bindData(data: MovieDetailResponse) {
        
        let posterPath = "\(AppConstants.baseImageURL)/\(data.backdropPath ?? "")"
        imageViewMoviePoster.sd_setImage(with: URL(string: posterPath), completed: nil)
        
        let date = data.releaseDate ?? data.firstAirDate
        labelReleasedYear.text = "\(date?.split(separator: "-")[0] ?? "")"
        
        labelMovieTitle.text = data.originalTitle ?? data.originalName
        self.navigationItem.title = data.originalTitle ?? data.originalName
        
        labelMovieDescription.text = data.overview
        
        let runTimeHour = Int((data.runtime ?? 0) / 60)
        let runTimeMinutes = (data.runtime ?? 0) % 60
        
        labelDuration.text = "\(runTimeHour) hr \(runTimeMinutes) mins"
        labelRating.text = "\(data.voteAverage ?? 0.0)"
        viewRatingCount.rating = Int((data.voteAverage ?? 0.0) * 0.5)
        labelVoteCount.text = "\(data.voteCount ?? 0)"
        labelAboutMovieTitle.text = data.originalTitle ?? data.originalName
        var genreListStr = ""
        
        data.genres?.forEach({ item in
            genreListStr += "\(item.name ), "
        })
        
        labelGenreCollectionString.text = genreListStr
        
        var countryListStr = ""
        data.productionCountries?.forEach({ item in
            countryListStr += "\(item.name ?? ""), "
        })
        
        if data.productionCompanies?.count == nil {
            viewProductionCompanies.isHidden = true
        } else {
            if !countryListStr.isEmpty {
                countryListStr.removeLast()
                countryListStr.removeLast()
            }
        }
        
        labelProductionCountriesString.text = countryListStr
        labelAboutMovieDescription.text = data.overview
        labelReleaseDate.text = data.releaseDate ?? data.firstAirDate
    }
    
}


//MARK: - Bind Observers
extension MovieDetailViewController {
    
    private func addMovieDetailBindingObserver() {
        viewModel.movieDetailResultItem
            .bind { [weak self] result in
                guard let self = self else { return }
                if let result = result {
                    self.bindData(data: result)
                }
        }
            .disposed(by: disposeBag)
    }
    
    
    private func addCollectionViewBindingObserver() {
        
        viewModel.similarMovieResultItems
            .bind(to: collectionViewSimilarContent.rx.items(
            cellIdentifier: String(describing: PopularFilmCollectionViewCell.identifier),
            cellType: PopularFilmCollectionViewCell.self
        )) { row, element, cell in
            print(element)
            cell.data = element
        }
        .disposed(by: disposeBag)
        
        
        viewModel.productionCompaniesResultItems
            .bind(to: collectionViewProductionCompanies.rx.items(
                cellIdentifier: String(describing: ProductionCompanyCollectionViewCell.identifier),
                cellType: ProductionCompanyCollectionViewCell.self
            )) { row, element, cell in
                cell.data = element
            }
            .disposed(by: disposeBag)
        
        
        viewModel.castsResultItems
            .bind(to: collectionViewActors.rx.items(
                cellIdentifier: String(describing: ActorCollectionViewCell.identifier),
                cellType: ActorCollectionViewCell.self
                )) { row, element, cell in
                let item: MovieCast = element
                cell.data = item.convertToActorInfoResponse()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func addItemSelectedObserver() {
        
        collectionViewSimilarContent.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.viewModel.getSelectedMovieResult(index: indexPath.row)
                if item.originalTitle != nil {
                    self.navigateToMovieDetailViewController(movieId: item.id!, type: "movie")
                } else {
                    self.navigateToMovieDetailViewController(movieId: item.id!, type: "tv")
                }
            })
            .disposed(by: disposeBag)
        
        
        collectionViewActors.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.viewModel.getSelectedCastResult(index: indexPath.row)
                self.navigateToActorDetailViewController(actorId: item.id!)
            })
            .disposed(by: disposeBag)
    }
    
    
}


//MARK: - CollectionView Data & Delegates
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewProductionCompanies {
            let itemWidth: CGFloat = collectionView.frame.height
            let itemHeight = itemWidth
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == collectionViewActors {
            let itemWidth: CGFloat = 120
            let itemHeight: CGFloat = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == collectionViewSimilarContent {
            let itemWidth: CGFloat = 120
            let itemHeight: CGFloat = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            return CGSize.zero
        }
    }
}
