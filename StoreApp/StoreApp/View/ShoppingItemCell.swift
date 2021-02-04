//
//  ShoppingItemCell.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/02.
//

import UIKit

class ShoppingItemCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var groupDiscountedPrice: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var groupDiscountUserCount: UILabel!
    private var storeDomain = ""
    private var productId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCellSubviews()
        setGestureGecognizer()
    }
    
    
    func setCellData(item : StoreItem) {
        HTTPRequestManager.getImageUsingURLString(urlString: item.productImage) {
            (data) in
            DispatchQueue.main.async {
                self.productImage.image = UIImage(data: data)
            }
        }
        productName.text = item.productName
        groupDiscountedPrice.text = ShoppingItemCellStringMaker.makeGroupDiscountedPriceString(price: item.groupDiscountedPrice)
        originalPrice.text = ShoppingItemCellStringMaker.makeOriginalPriceString(price: item.originalPrice)
        groupDiscountUserCount.text = ShoppingItemCellStringMaker.makeGroudDiscountUserCountString(count: item.groupDiscountUserCount)
        storeDomain = item.storeDomain
        productId = item.productId
    }
    
    private func setCellSubviews() {
        setProductImage()
        setProductName()
        setGroupDiscpontedPrice()
        setOriginalPrice()
        setGroupDiscountUserCOunt()
    }
    
    private func setProductImage() {
        contentView.addSubview(productImage)
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        productImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    private func setProductName() {
        contentView.addSubview(productName)
        productName.translatesAutoresizingMaskIntoConstraints = false
        productName.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10).isActive = true
        productName.leadingAnchor.constraint(equalTo: productImage.leadingAnchor).isActive = true
        productName.trailingAnchor.constraint(equalTo: productImage.trailingAnchor).isActive = true
        productName.sizeToFit()
    }
    
    private func setGroupDiscpontedPrice() {
        contentView.addSubview(groupDiscountedPrice)
        groupDiscountedPrice.translatesAutoresizingMaskIntoConstraints = false
        groupDiscountedPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10).isActive = true
        groupDiscountedPrice.leadingAnchor.constraint(equalTo: productName.leadingAnchor).isActive = true

        groupDiscountedPrice.sizeToFit()
        groupDiscountedPrice.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setOriginalPrice() {
        contentView.addSubview(originalPrice)
        originalPrice.translatesAutoresizingMaskIntoConstraints = false
        originalPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10).isActive = true
        originalPrice.leadingAnchor.constraint(equalTo: groupDiscountedPrice.trailingAnchor, constant: 10).isActive = true

        originalPrice.sizeToFit()
        originalPrice.font = UIFont.systemFont(ofSize: 14)
        originalPrice.textColor = .darkGray
    }

    private func setGroupDiscountUserCOunt() {
        contentView.addSubview(groupDiscountUserCount)
        groupDiscountUserCount.translatesAutoresizingMaskIntoConstraints = false
        groupDiscountUserCount.topAnchor.constraint(equalTo: originalPrice.bottomAnchor, constant: 5).isActive = true
        groupDiscountUserCount.leadingAnchor.constraint(equalTo: productName.leadingAnchor).isActive = true

        groupDiscountUserCount.sizeToFit()
        groupDiscountUserCount.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setGestureGecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTouched))
        contentView.addGestureRecognizer(gestureRecognizer)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc func cellTouched() {
        NotificationCenter.default.post(name: .cellTouched, object: nil, userInfo: ["productId" : productId, "storeDomain" : storeDomain])
    }
}

extension Notification.Name {
    static let cellTouched = Notification.Name("cellTouched")
}
