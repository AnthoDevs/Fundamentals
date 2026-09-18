//
//  PokemonListViewController.swift
//  Fundamentals
//
//  Created by Anthony on 9/17/26.
//

import Foundation
import UIKit

protocol PokemonCoordinator {
    var navigationController: UINavigationController? { get }
}

class PkmnCoordinator: PokemonCoordinator, PokemonListViewControllerDelegate {
    func pokemonListViewController(_ viewController: PokemonListViewController, didSelect item: PokemonListItem) {
        print("selected pokemon: \(item)")
    }
    
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(){
        let vc = PokemonListViewController()
        vc.delegate = self
        navigationController?.setViewControllers([vc], animated: true)
    }
}


nonisolated enum Section: Hashable, Sendable {
    case main
}

protocol PokemonListViewControllerDelegate: AnyObject {
    func pokemonListViewController(_ viewController: PokemonListViewController, didSelect item: PokemonListItem)
}

extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let pokemon = dataSource.itemIdentifier(for: indexPath) {
            delegate?.pokemonListViewController(self, didSelect: pokemon)
            print("pokemon selected: \(pokemon)")
        }
    }
}


class PokemonListViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, PokemonListItem>!
    weak var delegate: PokemonListViewControllerDelegate?

    let label: UILabel = {
        let label = UILabel()
        label.text = "Pokemon List"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PokemonListItem> { cell, index, item in
        var config = cell.defaultContentConfiguration()
        config.text = item.name
        var background = UIBackgroundConfiguration.listCell()
        background.backgroundColor = .systemBlue
        cell.backgroundConfiguration = background
        cell.contentConfiguration = config
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(label)
        self.view.addSubview(collectionView)
        self.setConstraints()
        
        dataSource = UICollectionViewDiffableDataSource<Section, PokemonListItem>(
                collectionView: collectionView
            ) { [weak self] collectionView, indexPath, item in

                guard let self else { return nil }

                return collectionView.dequeueConfiguredReusableCell(
                    using: self.cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonListItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(
            [
                PokemonListItem(id: "Piachu",
                                name: "Picachu",
                                url: ""),
                PokemonListItem(id: "Charmander",
                                name: "Charmander",
                                url: "")
            ]
        )
        dataSource.apply(snapshot)
        collectionView.delegate = self
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate(
            [label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
             label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
             collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
             collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
             collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
    
}
