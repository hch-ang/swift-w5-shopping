//
//  ViewController.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import UIKit

class MainViewController: UIViewController {
    
    var shoppingListView : UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<ItemManager.ItemType, StoreItem>! = nil
    var snapshot : NSDiffableDataSourceSnapshot<ItemManager.ItemType, StoreItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "카카오 쇼핑"
        
        setShoppingListView()
        configureDataSource()
        setNotificationListener()

        for itemType in ItemManager.ItemType.allCases {
            ItemManager.setItems(itemType: itemType) {
                self.setSnapshotData(itemType: itemType)
            }
        }

    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let sectionHeaderFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderFooterSize, elementKind: "sectionHeader", alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setSnapshotData(itemType : ItemManager.ItemType) {
        snapshot.appendItems(ItemManager.getItems(itemType: itemType), toSection: itemType)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureDataSource() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: "sectionHeader") {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "\(ItemManager.ItemType.allCases[indexPath.section].SectionName)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
        }


        dataSource = UICollectionViewDiffableDataSource<ItemManager.ItemType, StoreItem>(collectionView: shoppingListView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: StoreItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingItemCell", for: indexPath) as? ShoppingItemCell else { return UICollectionViewCell() }
            cell.setCellData(item: identifier)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.shoppingListView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        
        snapshot = NSDiffableDataSourceSnapshot<ItemManager.ItemType, StoreItem>()
        snapshot.appendSections([.best])
        snapshot.appendSections([.fryingpan])
        snapshot.appendSections([.grocery])
        snapshot.appendSections([.mask])

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
        
        shoppingListView.register(UINib(nibName: "ShoppingItemCell", bundle: nil), forCellWithReuseIdentifier: "ShoppingItemCell")
    }
}

extension MainViewController {
    private func setNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailView(_:)), name: .cellTouched, object: nil)
    }
    
    @objc func showDetailView(_ notification : Notification) {
        guard let productId = notification.userInfo?["productId"] else { return }
        guard let productName = notification.userInfo?["productName"] else { return }
        guard let storeDomain = notification.userInfo?["storeDomain"] else { return }
    }
}


