//
//  PokemonListViewController.swift
//  Fundamentals
//
//  Created by Anthony on 9/17/26.
//

import Foundation
import UIKit

class PokemonListViewController: UIViewController {
    let label: UILabel = {
        let label = UILabel()
        label.text = "Pokemon List"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeHolderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(label)
        self.view.addSubview(placeHolderView)
        self.setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate(
            [label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
             label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
             placeHolderView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
             placeHolderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
             placeHolderView.heightAnchor.constraint(equalToConstant: 200),
             placeHolderView.widthAnchor.constraint(equalToConstant: 200)
            ]
        )
    }
    
}
