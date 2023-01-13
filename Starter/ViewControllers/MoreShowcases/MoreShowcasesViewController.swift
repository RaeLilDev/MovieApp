//
//  MoreShowcasesViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 22/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MoreShowcasesViewController: UIViewController {
    
    @IBOutlet weak var collectionViewShowCases: UICollectionView!
    
    private let networkAgent = MovieDBNetworkAgent.shared
    private let movieModel: MovieModel = MovieModelImpl.shared
    
    private var delegate: MovieItemDelegate?
    
    private var totalPages = 1
    private var currentPage = 1
    
    private var showCaseList: [MovieResult] = []
    
    //MARK: - 2
    var showCaseResultItems: BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initObservers()
        
        fetchShowCases(page: currentPage)
        
    }
    
    private func initView() {
        self.navigationItem.title = "Showcases"
        
        registerCollectionViewCell()
    }
    
    //MARK: - Init Observers
    private func initObservers() {
        
        addCollectionViewBindingObserver()
        
        addItemSelectedObserver()
        
        addPaginationObserver()
        
    }
    
    private func registerCollectionViewCell() {
//        collectionViewShowCases.dataSource = self
        collectionViewShowCases.delegate = self
        collectionViewShowCases.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
    }
    
    
    //MARK: - Fetch Films By Name
    private func fetchShowCases(page: Int) {
        
        //MARK: - 1
        RxMovieModelImpl.shared.getTopRatedMovieList(page: page)
            .subscribe(onNext: { item in
                print("Data count is \(item.count)")
                if self.currentPage == 1 {
                    self.showCaseResultItems.onNext(item)
                } else {
                    self.showCaseResultItems.onNext(try! self.showCaseResultItems.value() + item)
                }
            })
            .disposed(by: disposeBag)

    }

}



extension MoreShowcasesViewController {
    
    //MARK: - 3
    private func addCollectionViewBindingObserver() {
        // Bind data to colletionview cell
        showCaseResultItems.bind(to: collectionViewShowCases.rx.items(
            cellIdentifier: String(describing: ShowCaseCollectionViewCell.identifier),
            cellType: ShowCaseCollectionViewCell.self
        )) { row, element, cell in
            cell.data = element
        }
        .disposed(by: disposeBag)
        
    }
    
    //MARK: - 4
    private func addItemSelectedObserver() {
        
        collectionViewShowCases.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let items = try! self.showCaseResultItems.value()
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
        
        collectionViewShowCases.rx.willDisplayCell
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (cellTuple) in
                let (_, indexPath) = cellTuple
                let totalItems = try! self.showCaseResultItems.value().count
                let isAtLastRow = indexPath.row == totalItems - 1
                if (isAtLastRow) {
                    self.currentPage += 1
                    print("Fetch Showcase for \(self.currentPage)")
                    self.fetchShowCases(page: self.currentPage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}

extension MoreShowcasesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showCaseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as ShowCaseCollectionViewCell
        cell.data = showCaseList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = collectionView.frame.width - 32
        let itemHeight: CGFloat = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = showCaseList[indexPath.row]
//        if item.originalTitle != nil {
//            navigateToMovieDetailViewController(movieId: item.id ?? -1, type: "movie")
//        } else {
//            navigateToMovieDetailViewController(movieId: item.id ?? -1, type: "tv")
//        }
//    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let isLastItem = indexPath.row == (showCaseList.count - 1)
//        //let hasMoreData = currentPage < totalPages
//        if isLastItem {
//            currentPage += 1
//            fetchShowCases(page: currentPage)
//        }
//    }
    
    
}
