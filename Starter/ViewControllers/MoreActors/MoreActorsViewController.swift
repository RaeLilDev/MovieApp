//
//  MoreActorsViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 22/03/2022.
//

import UIKit

class MoreActorsViewController: UIViewController {
    
    @IBOutlet weak var collectionViewActors: UICollectionView!
    
    private let networkAgent = MovieDBNetworkAgent.shared
    private let movieModel: MovieModel = MovieModelImpl.shared
    private let actorModel: ActorModel = ActorModelImpl.shared
    
    private var actors: [ActorInfoResponse] = []
    
    private var totalPages: Int = 1
    private var currentPage: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        fetchActors(page: 1)
        
    }
    
    private func initView() {
        self.navigationItem.title = "Actors"
        
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
    }
    
    
    private func fetchActors(page: Int) {
        actorModel.getPopularPeople(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.actors.append(contentsOf: data)
//                if data.page == 1 {
//                    self.totalPages = data.totalPages ?? 1
//                }
                self.collectionViewActors.reloadData()
            case .failure(let message):
                print(message)
            }
            
        }
    }
}

extension MoreActorsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: ActorCollectionViewCell.identifier, indexPath: indexPath) as ActorCollectionViewCell
        cell.data = actors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth: CGFloat = (collectionView.frame.width-64)/3
        let itemHeight: CGFloat = itemWidth * 1.5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actorId = actors[indexPath.row].id ?? -1
        navigateToActorDetailViewController(actorId: actorId)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == (actors.count - 1)
        //let hasMorePage = currentPage < totalPages
        if isLastRow {
            currentPage += 1
            fetchActors(page: currentPage)
        }
    }
    
    
}
