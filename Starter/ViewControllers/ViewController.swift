//
//  ViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBAction func didTapButton(_ sender: Any) {
        labelName.text = textFieldName.text
        textFieldName.text = ""
    }
    
    @IBAction func didTapHomeToTableViewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToTableView", sender: self)
    }
    
    @IBAction func didTapHomeToCollectionViewButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToCollectionView", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureForImage = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        imageProfile.addGestureRecognizer(tapGestureForImage)
        imageProfile.isUserInteractionEnabled = true
        
        debugPrint("ViewDidLoad")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("ViewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("ViewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("ViewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("ViewDidDisappear")
    }
    
    
    @objc func onTapImage() {
        textFieldName.text = "Co Rae"
    }

    
    
}

