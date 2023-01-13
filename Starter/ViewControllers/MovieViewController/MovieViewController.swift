//
//  MovieViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 06/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MovieViewController: UIViewController, MovieItemDelegate {
    
    
    @IBOutlet weak var tableViewMovies: UITableView!
    
    let disposeBag = DisposeBag()
    
    var viewModel: MovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieViewModel()
        
        setupNavbar()
        
        registerTableViewCell()
        
        viewModel.fetchAllData()
        
        bindData()
        

    }
    
    private func setupNavbar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
        
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "search_button"
    }
    
    
    private func bindData() {
        viewModel.homeItemList
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .bind(to: tableViewMovies.rx.items(dataSource: initDataSource()))
        .disposed(by: disposeBag)
    }
    
    
    //MARK: - Init DataSource
    private func initDataSource() -> RxTableViewSectionedReloadDataSource<HomeMovieSectionModel> {
        
        return RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>.init { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
                
            case .upcomingMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                cell.delegate = self
                cell.data = items
                return cell
                
            case .popularMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.labelTitle.text = "popular movies".uppercased()
                cell.delegate = self
                cell.data = items
                return cell

            case .popularSeriesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.labelTitle.text = "popular series".uppercased()
                cell.delegate = self
                cell.data = items
                return cell

            case .movieShowTimeSection:
                return tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)

            case .movieGenreSection(let items, let movies):
                print("Genre is reloaded")
                let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
                cell.allMoviesAndSeries = movies
                cell.genreList = items
                cell.delegate = self
                return cell

            case .showcaseMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
                cell.data = items
                cell.delegate = self
                return cell
//
            case .bestActorSection(let items):
                let cell = tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
                cell.data = items
                cell.delegate = self
                return cell
                
                
            }
        }
    }
    
    //MARK: - Cell Register
    private func registerTableViewCell() {
//        tableViewMovies.dataSource = self
        
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
    
    //MARK: - Ontap Callbacks
    func onTapMovie(id: Int, type: String) {
        navigateToMovieDetailViewController(movieId: id, type: type)
    }
    
    func onTapActor(id: Int) {
        navigateToActorDetailViewController(actorId: id)
    }
    
    func onTapMoreActors() {
        navigateToMoreActorsViewController()
    }
    
    func onTapMoreShowCases() {
        navigateToMoreShowcasesViewController()
    }
    
    @IBAction func onTapSearch(_ sender: Any) {
        navigateToMovieSearchViewController()
    }
    
}

