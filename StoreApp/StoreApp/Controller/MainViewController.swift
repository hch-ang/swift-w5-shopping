//
//  ViewController.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import UIKit

class MainViewController: UIViewController {
    
    var shoppingListView : UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<ItemType, StoreItem>! = nil
    var snapshot : NSDiffableDataSourceSnapshot<ItemType, StoreItem>!
    var detailViewController : DetailViewController! = nil
    private let storeItemManager : StoreItemManagerProtocol = StoreItemManager()
    private let detailItemManager : DetailItemManagerProtocol = DetailItemManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "카카오 쇼핑"
        
        setShoppingListView()
        configureDataSource()
        setNotificationListener()
        storeItemManager.setAllTypeOfItems()
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
    
    func setSnapshotData(itemType : ItemType) {
        snapshot.appendItems(storeItemManager.getItems(itemType: itemType), toSection: itemType)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureDataSource() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: "sectionHeader") {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "\(ItemType.allCases[indexPath.section])"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
        }


        dataSource = UICollectionViewDiffableDataSource<ItemType, StoreItem>(collectionView: shoppingListView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: StoreItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingItemCell", for: indexPath) as? ShoppingItemCell else { return UICollectionViewCell() }
            cell.setCellData(item: identifier)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.shoppingListView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        
        snapshot = NSDiffableDataSourceSnapshot<ItemType, StoreItem>()
        snapshot.appendSections([.best])
        snapshot.appendSections([.mask])
        snapshot.appendSections([.grocery])
        snapshot.appendSections([.fryingpan])

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



extension MainViewController : ItemOrderProtocol{
    func orderItem(who: String, what: String, quantity: Int, totalPrice: Int) {
        print(who)
        print(what)
        print(quantity)
        print(totalPrice)
    }
    
    
}

extension MainViewController {
    private func setNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailView(_:)), name: .cellTouched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setSnapshotData(_:)), name: .FinishedItemSet, object: nil)
    }
    
    @objc func showDetailView(_ notification : Notification) {
        guard let productId = notification.userInfo?["productId"] as? Int else { return }
        guard let storeDomain = notification.userInfo?["storeDomain"] as? String else { return }
        if detailViewController == nil {
            detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController")
            detailViewController.setDetailItemManager(detailItemManager: detailItemManager)
            detailViewController.addObserverOfDetailViewDataIsReady()
        }
        detailItemManager.setItem(storeDomain: storeDomain, productId: String(productId))
        self.navigationController?.pushViewController(self.detailViewController, animated: true)
    }
    
    @objc func setSnapshotData(_ notification : Notification) {
        guard let itemType = notification.userInfo?["itemType"] as? ItemType else { return }
        DispatchQueue.main.async {
            self.setSnapshotData(itemType: itemType)
        }
    }
}


