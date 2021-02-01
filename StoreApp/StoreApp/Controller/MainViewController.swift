//
//  ViewController.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import UIKit

class MainViewController: UIViewController {

    var shoppingListView : UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    let sectionTitles = ["베스트", "마스크", "잡화", "프라이팬"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "카카오 쇼핑"
        
        for itemCase in ItemManager.jsonPath.allCases {
            HTTPRequestManager.getJsonData(itemCase: itemCase)
        }
        
        setShoppingListView()
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        let sectionHeaderFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderFooterSize, elementKind: "sectionHeader", alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: "sectionHeader") {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "\(self.sectionTitles[indexPath.section])"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
        }


        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: shoppingListView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return UICollectionViewCell()
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.shoppingListView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendSections([1])
        snapshot.appendSections([2])
        snapshot.appendSections([3])

        dataSource.apply(snapshot, animatingDifferences: true)
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
        shoppingListView.backgroundColor = .white
    }

}

