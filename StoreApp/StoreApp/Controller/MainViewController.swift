//
//  ViewController.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import UIKit

class MainViewController: UIViewController {

    var shoppingListView : UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "카카오 쇼핑"
        setShoppingListView()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func setShoppingListView() {
        shoppingListView = UICollectionView(frame: CGRect(), collectionViewLayout: createLayout())
        view.addSubview(shoppingListView)
        let layoutGuide = view.safeAreaLayoutGuide
        shoppingListView.translatesAutoresizingMaskIntoConstraints = false
        shoppingListView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        shoppingListView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        shoppingListView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        shoppingListView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
    }

}

