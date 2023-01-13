//
//  MovieSearchViewModel.swift
//  Starter
//
//  Created by Ye linn htet on 6/2/22.
//

import Foundation
import RxSwift
import RxCocoa

class MovieSearchViewModel {
    
    var currentPage = 1
    var totalPages = 1
    
    let searchResultItems: BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    
    private var networkAgent: RxNetworkAgentProtocol!
    
    init(networkAgent: RxNetworkAgentProtocol = RxNetworkAgent.shared) {
        self.networkAgent = networkAgent
    }
    
    func handlePagination(indexPath: IndexPath, searchText: String) {

        let totalItems = try! self.searchResultItems.value().count
        let isAtLastRow = indexPath.row == totalItems - 1
        let hasMorePages = self.currentPage < self.totalPages
        if (isAtLastRow && hasMorePages) {
            self.currentPage += 1
            self.fetchFilmsByName(name: searchText, page: self.currentPage)
        }
    }
    
    func handleSearchInputText(text: String) {
        if text.isEmpty {
            self.currentPage = 1
            self.totalPages = 1
            self.searchResultItems.onNext([])
        } else {
            self.fetchFilmsByName(name: text, page: self.currentPage)
        }
    }
    
    
    //MARK: - Fetch Films By Name
    func fetchFilmsByName(name: String, page: Int) {
        networkAgent.searchMovies(name: name, page: page)
            .do(onNext: { [weak self] item in
                guard let self = self else { return }
                self.totalPages = item.totalPages ?? 1
            })
            .compactMap { $0.results }
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                if self.currentPage == 1 {
                    self.searchResultItems.onNext(item)
                } else {
                    self.searchResultItems.onNext( try! self.searchResultItems.value() + item)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
}
