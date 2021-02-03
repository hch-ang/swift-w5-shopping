//
//  DetailView.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import UIKit

class DetailView: UIScrollView {
    private var contentView = UIView()
    var previewImage = UIImageView()
    var totalProductStarRanking = UILabel()
    var reviewCount = UILabel()
    var standardPrice = UILabel()
    var talkDealStatus = ""
    var discountedPRice = UILabel()
    var storeName = UILabel()
    var deliveryFeeType = ""
    var deliveryFee = UILabel()
    var noticeTitle = UILabel()
    var noticeCreateAt = UILabel()
    
    
    func setViewLayouts() {
        setContentViewLayout()
    }
    
    func setContentViewLayout() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor).isActive = true
    }
    
    func setViewData() {
//        let detailData = DetailItemManager.getItem()
    }
}
