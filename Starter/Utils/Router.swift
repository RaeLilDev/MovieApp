//
//  Router.swift
//  Starter
//
//  Created by Ye Lynn Htet on 10/02/2022.
//

import Foundation
import UIKit


enum StoryboardName : String {
    case Main = "Main"
    case Authentication = "Authentication"
    case LaunchScreen = "LaunchScreen"
}


extension UIStoryboard {
    static func mainStoryboard()->UIStoryboard{
        return UIStoryboard(name: StoryboardName.Main.rawValue, bundle: nil)
    }
}


extension UIViewController {
    
    func navigateToMovieDetailViewController(movieId: Int, type: String) {
        
        guard let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as? MovieDetailViewController else {
            return
        }
        vc.viewModel = MovieDetailViewModel(movieID: movieId, movieType: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToActorDetailViewController(actorId: Int) {
        guard let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: ActorDetailViewController.identifier) as? ActorDetailViewController else {
            return
        }
        vc.actorId = actorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMoreActorsViewController() {
        let moreActorsVC = MoreActorsViewController()
        self.navigationController?.pushViewController(moreActorsVC, animated: true)
    }
    
    func navigateToMoreShowcasesViewController() {
        let moreShowCasesVC = MoreShowcasesViewController()
        self.navigationController?.pushViewController(moreShowCasesVC, animated: true)
    }
    
    func navigateToMovieSearchViewController() {
        let movieSearchVC = MovieSearchViewController()
        self.navigationController?.pushViewController(movieSearchVC, animated: true)
    }
    
}
