//
//  DetailViewController.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailView: DetailView!
    private var detailItemManager : DetailItemManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detailView.setDetailItemManager(detailItemManager: detailItemManager)
        detailView.setViewLayouts()
        setCollectionViewInDetailView()
        detailView.setPurchaseDelegate(purchaseDelegate: self)
        
    }
    
    func setDetailItemManager(detailItemManager : DetailItemManagerProtocol) {
        self.detailItemManager = detailItemManager
    }
    
    func addObserverOfDetailViewDataIsReady() {
        NotificationCenter.default.addObserver(self, selector: #selector(viewDataIsReady), name: .DetailViewDataIsReady, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createTimer), name: .imageCellTouchesEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: .imageCellTouchesBegan, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWIllAppear")
        detailView.createTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.detailView.resetPage()
        self.detailView.invalidateTimer()
    }
    
    @objc func viewDataIsReady() {
        DispatchQueue.main.async {
            self.detailView.setViewData()
            self.detailItemManager.setPreviewImages() {
                self.detailView.setImageCount(count: self.detailItemManager.previewImageCount)
                self.detailView.reloadCollectionView()
            }
        }
    }
    
    @objc func createTimer() {
        detailView.createTimer()
    }
    
    @objc func invalidateTimer() {
        detailView.invalidateTimer()
    }

}

extension DetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func setCollectionViewInDetailView() {
        detailView.setCollectionPreviewImageViewDelegate(object: self)
        detailView.setCollectionPreviewImageViewDataSource(object: self)
        detailView.setCollectionPreviewImageViewCellobject(nib: UINib(nibName: "PreviewImageCell", bundle: nil), identifier: "PreviewImageCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailItemManager.previewImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewImageCell", for: indexPath) as? PreviewImageCell else { return UICollectionViewCell() }
        cell.setCellImage(image: detailItemManager.getPreviewImage(index: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return detailView.collectionViewFrame
    }

}

extension DetailViewController : NetworkPurchaseManagerDelegateProtocol {
    func purchaseStandard() {
        let buyer = "David"
        let item = detailItemManager.productName
        let count = 1
        let price = detailItemManager.standardPrice
        let returnString = "\(buyer) \(item) \(count)개 : \(StandardStringMaker.makeIntegerToFitStandard(num: price*count))원 주문완료"
//        print(returnString)
//        HTTPRequestManager.sendPost(paramText: returnString, urlString: "https://hooks.slack.com/services/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")
//        navigationController?.popViewController(animated: true)
        showToast(vc: self, msg: returnString, sec: 1) {
            self.detailView.resetPage()
            self.detailView.invalidateTimer()
            self.navigationController?.popViewController(animated: true)
        }
    }

    func purchaseDiscounted() {
        let buyer = "David"
        let item = detailItemManager.productName
        let count = 1
        let price = detailItemManager.discountedPrice
        let returnString = "\(buyer) \(item) \(count)개 : \(StandardStringMaker.makeIntegerToFitStandard(num: price*count))원 주문완료"
//        print(returnString)
//        HTTPRequestManager.sendPost(paramText: returnString, urlString: "https://hooks.slack.com/services/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")
//        navigationController?.popViewController(animated: true)
        showToast(vc: self, msg: returnString, sec: 1) {
            self.detailView.resetPage()
            self.detailView.invalidateTimer()
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    func showToast(vc: UIViewController, msg: String, sec: Double, completionHandler : @escaping () -> ()) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            
        vc.present(alert, animated: true, completion: nil)
            
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + sec) {
            alert.dismiss(animated: true, completion: nil)
            completionHandler()
        }
    }

}

