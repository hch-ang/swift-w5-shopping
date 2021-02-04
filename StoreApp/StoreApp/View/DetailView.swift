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
    private var previewImageView = UIImageView()
    private var totalProductStarRankingAndReviewCount = UILabel()
    private var productName = UILabel()
    private var standardPrice = UILabel()
    private var standardPriceLeadingAnchorConstraint : NSLayoutConstraint! = nil
    private var standardPriceCenterXAnchoerConstraint : NSLayoutConstraint! = nil
    private var discountedPrice = UILabel()
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
        discountedPrice.backgroundColor = UIColor(red: 245/255, green: 225/255, blue: 75/255, alpha: 1)
        discountedPrice.textAlignment = .center
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
        standardPrice.backgroundColor = .black
        standardPrice.textColor = .white
        standardPrice.textAlignment = .center
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
//        print(detailItemManager.getPreviewImages())
        totalProductStarRankingAndReviewCount.text = DetailViewStringMaker.makeTotalProductStarRankingAndReviewCountString(totalProductStarRating: detailItemManager.totalProductStarRating, reviewCount: detailItemManager.reviewCount)
        productName.text = detailItemManager.productName
        if DetailViewLogicHelper.isOnSale(status: detailItemManager.status) {
            standardPriceLeadingAnchorConstraint.isActive = true
            standardPriceCenterXAnchoerConstraint.isActive = false
            discountedPrice.backgroundColor = UIColor(red: 245/255, green: 225/255, blue: 75/255, alpha: 1)
            discountedPrice.text = DetailViewStringMaker.convertDiscountedPriceIntoString(discountedPrice: detailItemManager.discountedPrice)
        } else {
            standardPriceLeadingAnchorConstraint.isActive = false
            standardPriceCenterXAnchoerConstraint.isActive = true
            discountedPrice.backgroundColor = .white
            discountedPrice.text = ""
        }
        standardPrice.text = DetailViewStringMaker.convertStandardPriceIntoString(standardPrice: detailItemManager.standardPrice)
        storeName.text = detailItemManager.storeName
        deliveryFee.text = DetailViewStringMaker.makeDeilveryFeeString(deliveryFee: detailItemManager.deliveryFee, deliveryFeeType: detailItemManager.deliveryFeeType)
        if detailItemManager.noticeCount > 0 {
            noticeTitle.text = detailItemManager.noticeTitle
            print(noticeTitle)
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

