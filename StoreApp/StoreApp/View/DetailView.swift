//
//  DetailView.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import UIKit
import WebKit

class DetailView: UIScrollView {
    private var detailItemManager : DetailItemManagerProtocol! = nil
    private var contentView = UIView()
    private var previewImageView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    private var imageCount = 0
    var timer : Timer!
    var nowPage = 0
    private var totalProductStarRankingAndReviewCount = UILabel()
    private var productName = UILabel()
    private var standardPrice = UILabel()
    private var standardPriceLeadingAnchorConstraint : NSLayoutConstraint! = nil
    private var standardPriceCenterXAnchoerConstraint : NSLayoutConstraint! = nil
    private var discountedPrice = UILabel()
    private var purchaseDelegate : NetworkPurchaseManagerDelegateProtocol! = nil
    private var storeName = UILabel()
    private var deliveryFee = UILabel()
    private var noticeTitle = UILabel()
    private var noticeCreatedAt = UILabel()
    private var webView = WKWebView()
    private var webViewTopAnchorConstraintWithNoticeCreatedAt : NSLayoutConstraint! = nil
    private var webViewTopAnchorConstraintWithDeliveryFee : NSLayoutConstraint! = nil
    private var webViewHeightAnchorConstraint : NSLayoutConstraint!


    
    func setViewLayouts() {
        setContentViewLayout()
        setPreviewImageView()
        setTotalProductStarRankingAndReviewCount()
        setProductName()
        setDiscountedPrice()
        setStandardPrice()
        setStoreName()
        setDeliveryFee()
        setNoticeTitle()
        setNoticeCreatedAt()
        setWKWebView()
    }
    
    private func setWKWebView() {
        webView.navigationDelegate = self
        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewTopAnchorConstraintWithNoticeCreatedAt = webView.topAnchor.constraint(equalTo: noticeCreatedAt.bottomAnchor, constant: 10)
        webViewTopAnchorConstraintWithDeliveryFee = webView.topAnchor.constraint(equalTo: deliveryFee.bottomAnchor, constant: 10)
        webViewTopAnchorConstraintWithNoticeCreatedAt.isActive = true
        webViewTopAnchorConstraintWithDeliveryFee.isActive = false
        webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        webView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setNoticeCreatedAt() {
        contentView.addSubview(noticeCreatedAt)
        noticeCreatedAt.translatesAutoresizingMaskIntoConstraints = false
        noticeCreatedAt.topAnchor.constraint(equalTo: noticeTitle.bottomAnchor, constant: 5).isActive = true
        noticeCreatedAt.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        noticeCreatedAt.font = UIFont.systemFont(ofSize: 13)
        noticeCreatedAt.textColor = .systemGray
    }
    
    private func setNoticeTitle() {
        contentView.addSubview(noticeTitle)
        noticeTitle.translatesAutoresizingMaskIntoConstraints = false
        noticeTitle.topAnchor.constraint(equalTo: deliveryFee.bottomAnchor, constant: 15).isActive = true
        noticeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        noticeTitle.sizeToFit()
    }
    
    private func setDeliveryFee() {
        contentView.addSubview(deliveryFee)
        deliveryFee.translatesAutoresizingMaskIntoConstraints = false
        deliveryFee.topAnchor.constraint(equalTo: storeName.bottomAnchor, constant: 10).isActive = true
        deliveryFee.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        deliveryFee.sizeToFit()
        deliveryFee.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setStoreName() {
        contentView.addSubview(storeName)
        storeName.translatesAutoresizingMaskIntoConstraints = false
        storeName.topAnchor.constraint(equalTo: standardPrice.bottomAnchor, constant: 10).isActive = true
        storeName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        storeName.sizeToFit()
        storeName.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func setDiscountedPrice() {
        contentView.addSubview(discountedPrice)
        discountedPrice.translatesAutoresizingMaskIntoConstraints = false
        discountedPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10).isActive = true
        discountedPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        discountedPrice.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/5).isActive = true
        discountedPrice.heightAnchor.constraint(equalTo: discountedPrice.widthAnchor, multiplier: 1/3).isActive = true
        discountedPrice.layer.cornerRadius = 25
        
        discountedPrice.textAlignment = .center
        discountedPrice.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(discountedPriceTouced(_:)))
        discountedPrice.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func discountedPriceTouced(_ sender : UITapGestureRecognizer) {
        purchaseDelegate.purchaseDiscounted()
    }
    
    private func setStandardPrice() {
        contentView.addSubview(standardPrice)
        standardPrice.translatesAutoresizingMaskIntoConstraints = false
        standardPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10).isActive = true
        standardPriceLeadingAnchorConstraint = standardPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        standardPriceCenterXAnchoerConstraint = standardPrice.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        standardPriceLeadingAnchorConstraint.isActive = true
        standardPriceCenterXAnchoerConstraint.isActive = false
        standardPrice.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/5).isActive = true
        standardPrice.heightAnchor.constraint(equalTo: standardPrice.widthAnchor, multiplier: 1/3).isActive = true
//        standardPrice.backgroundColor = .black
        standardPrice.layer.backgroundColor = UIColor.black.cgColor
        standardPrice.layer.cornerRadius = 25
        standardPrice.textColor = .white
        standardPrice.textAlignment = .center
        standardPrice.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(standardPriceTouched(_:)))
        standardPrice.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func standardPriceTouched(_ sender : UITapGestureRecognizer) {
        purchaseDelegate.purchaseStandard()
    }
    
    func setPurchaseDelegate(purchaseDelegate : NetworkPurchaseManagerDelegateProtocol) {
        self.purchaseDelegate = purchaseDelegate
    }
    
    private func setProductName() {
        contentView.addSubview(productName)
        productName.translatesAutoresizingMaskIntoConstraints = false
        productName.topAnchor.constraint(equalTo: totalProductStarRankingAndReviewCount.bottomAnchor, constant: 10).isActive = true
        productName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        productName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        productName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        productName.lineBreakMode = .byTruncatingTail
        productName.numberOfLines = 2
        productName.font = UIFont.systemFont(ofSize: 20)
        productName.textAlignment = .center
    }
    
    private func setTotalProductStarRankingAndReviewCount() {
        contentView.addSubview(totalProductStarRankingAndReviewCount)
        totalProductStarRankingAndReviewCount.translatesAutoresizingMaskIntoConstraints = false
        totalProductStarRankingAndReviewCount.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 10).isActive = true
        totalProductStarRankingAndReviewCount.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        totalProductStarRankingAndReviewCount.sizeToFit()
        totalProductStarRankingAndReviewCount.textColor = .systemBlue
    }
    
    private func setPreviewImageView() {
        addSubview(previewImageView)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
    
    private func setContentViewLayout() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor).isActive = true
    }
    
    func setViewData() {
        totalProductStarRankingAndReviewCount.text = DetailViewStringMaker.makeTotalProductStarRankingAndReviewCountString(totalProductStarRating: detailItemManager.totalProductStarRating, reviewCount: detailItemManager.reviewCount)
        productName.text = detailItemManager.productName
        if DetailViewLogicHelper.isOnSale(status: detailItemManager.status) {
            standardPriceLeadingAnchorConstraint.isActive = true
            standardPriceCenterXAnchoerConstraint.isActive = false
            discountedPrice.layer.backgroundColor = UIColor(red: 245/255, green: 225/255, blue: 75/255, alpha: 1).cgColor
            discountedPrice.text = DetailViewStringMaker.convertDiscountedPriceIntoString(discountedPrice: detailItemManager.discountedPrice)
        } else {
            standardPriceLeadingAnchorConstraint.isActive = false
            standardPriceCenterXAnchoerConstraint.isActive = true
            discountedPrice.layer.backgroundColor = UIColor.white.cgColor
            discountedPrice.text = ""
        }
        standardPrice.text = DetailViewStringMaker.convertStandardPriceIntoString(standardPrice: detailItemManager.standardPrice)
        storeName.text = detailItemManager.storeName
        deliveryFee.text = DetailViewStringMaker.makeDeilveryFeeString(deliveryFee: detailItemManager.deliveryFee, deliveryFeeType: detailItemManager.deliveryFeeType)
        if detailItemManager.noticeCount > 0 {
            noticeTitle.text = detailItemManager.noticeTitle
            noticeCreatedAt.text = DetailViewStringMaker.makeNoticeCreatedAtToFitStandard(createdAt: detailItemManager.noticeCreatedAt)
            webViewTopAnchorConstraintWithDeliveryFee.isActive = false
            webViewTopAnchorConstraintWithNoticeCreatedAt.isActive = true
        } else {
            webViewTopAnchorConstraintWithDeliveryFee.isActive = true
            webViewTopAnchorConstraintWithNoticeCreatedAt.isActive = false
        }
        webView.loadHTMLString(detailItemManager.description, baseURL: nil)
    }
    
    func setDetailItemManager(detailItemManager : DetailItemManagerProtocol) {
        self.detailItemManager = detailItemManager
    }
}

extension DetailView {
    func setCollectionPreviewImageViewDelegate(object : UICollectionViewDelegate) {
        previewImageView.delegate = object
    }
    
    func setCollectionPreviewImageViewDataSource(object : UICollectionViewDataSource) {
        previewImageView.dataSource = object
    }
    
    func setCollectionPreviewImageViewCellobject(nib : UINib, identifier : String) {
        previewImageView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadCollectionView() {
        
        previewImageView.reloadData()
    }
    
    var collectionViewFrame : CGSize {
        return previewImageView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            self.paging()
        }
    }
    
    func invalidateTimer() {
        print("Imvalidate")
        if timer != nil {
            timer.invalidate()
        }
    }
    
    func resetPage() {
        nowPage = 0
    }
    
    func setImageCount(count : Int) {
        imageCount = count
    }
    
    func paging() {
        print("from page : \(nowPage)")
        if nowPage == imageCount-1 {
            previewImageView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
            print("to page : \(nowPage)")
            return
        }
        nowPage += 1
        previewImageView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        print("to page : \(nowPage)")
    }

}

extension DetailView : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.webViewHeightAnchorConstraint != nil {
                self.webViewHeightAnchorConstraint.isActive = false
            }
            self.webViewHeightAnchorConstraint = self.webView.heightAnchor.constraint(equalTo: self.standardPrice.heightAnchor, constant: self.webView.scrollView.contentSize.height)
            self.webViewHeightAnchorConstraint.isActive = true
        }
    }
}

extension Notification.Name {
    static let StandardPriceTouched = Notification.Name("StandardPriceTouched")
    static let DiscountedPriceTouched = Notification.Name("DiscountedPriceTouched")
}
