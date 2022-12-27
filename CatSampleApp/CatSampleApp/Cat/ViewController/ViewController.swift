//
//  ViewController.swift
//  CatSampleApp
//
//  Created by Nabnit Patnaik on 12/22/22.
//

import UIKit

class ViewController: UIViewController, ResponseHandlerDelegate {
    
    var stackView = UIStackView()
    var lblCatDescription = UILabel()
    var imgCatPhoto = UIImageView()
    
    private lazy var scrollView: UIScrollView = {
        let scrlView = UIScrollView(frame: .zero)
        scrlView.backgroundColor = .clear
        scrlView.translatesAutoresizingMaskIntoConstraints = false
        scrlView.layoutMargins = .zero
        return scrlView
    }()
    
    lazy var catViewModel: CatViewModel = {
        let catVM = CatViewModel()
        catVM.delegate = self
        return catVM
        
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        loadData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    // UI setup
    func setupView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.alignment = .center
        
        imgCatPhoto.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imgCatPhoto)
        
        lblCatDescription.numberOfLines = 0
        lblCatDescription.sizeToFit()
        lblCatDescription.lineBreakMode = .byWordWrapping
        lblCatDescription.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(lblCatDescription)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    /// Fetches the Cat details - photo and description
    func loadData() {
        catViewModel.fetchCatDetails()
    }
    
    /// Delegate function which is called after the cat description & photo are fetched.
    func updateUI() {
        DispatchQueue.main.async {
            self.lblCatDescription.text = self.catViewModel.description?.data.first
            self.imgCatPhoto.image = self.catViewModel.image
        }
    }
    
    ///  Reload data when the screen is tapped
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        loadData()
    }
}
