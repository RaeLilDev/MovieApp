//
//  MovieSearchViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 23/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var collectionViewMovies: UICollectionView!
    
    @IBOutlet weak var noSearchResult: UIStackView!
    
    private let searchBar = UISearchBar()
    
    var viewModel: MovieSearchViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewModel = MovieSearchViewModel()

        initView()
        
        initObservers()
        
    }
    
    //MARK: - iniitialize view
    private func initView() {
        
        noSearchResult.isHidden = true
        
        searchBar.placeholder = "Search..."
        searchBar.searchTextField.textColor = .white
        
        navigationItem.titleView = searchBar
        
        registerCollecitonView()
        
    }
    
    
    //MARK: - register collectionview
    private func registerCollecitonView() {
        collectionViewMovies.delegate = self
        collectionViewMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    //MARK: - Init Observers
    private func initObservers() {
        
        addSearchBarObserver()
        
        addCollectionViewBindingObserver()
        
        addItemSelectedObserver()
        
        addPaginationObserver()
        
    }
    
    

}

//MARK: - Observers
extension MovieSearchViewController {
    
    //MARK: - 1
    private func addSearchBarObserver() {
        
        searchBar.rx.text.orEmpty  //to handle nullable
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                
                self.viewModel.handleSearchInputText(text: value)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - 4
    private func addCollectionViewBindingObserver() {
        // Bind data to colletionview cell
        viewModel.searchResultItems
        .bind(to: collectionViewMovies.rx.items(
            cellIdentifier: String(describing: PopularFilmCollectionViewCell.identifier),
            cellType: PopularFilmCollectionViewCell.self
        )) { row, element, cell in
            cell.data = element
        }
        .disposed(by: disposeBag)
        
    }
    
    //MARK: - 6
    private func addItemSelectedObserver() {
        
        collectionViewMovies.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let items = try! self.viewModel.searchResultItems.value()
                let item = items[indexPath.row]
                if item.originalTitle != nil {
                    self.navigateToMovieDetailViewController(movieId: item.id!, type: "movie")
                } else {
                    self.navigateToMovieDetailViewController(movieId: item.id!, type: "tv")
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: - 5
    private func addPaginationObserver() {
        Observable.combineLatest(
            collectionViewMovies.rx.willDisplayCell,
            searchBar.rx.text.orEmpty)
            .subscribe(onNext: { (cellTuple, searchText) in
                let (_, indexPath) = cellTuple
                self.viewModel.handlePagination(indexPath: indexPath, searchText: searchText)
            })
            .disposed(by: disposeBag)
    }

}


//MARK: - Collection View Data Source and Delegates

extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = (collectionView.frame.width - 40) / 3
        let itemHeight: CGFloat = itemWidth * 2.1
        return CGSize(width: itemWidth, height: itemHeight)
    }


}
