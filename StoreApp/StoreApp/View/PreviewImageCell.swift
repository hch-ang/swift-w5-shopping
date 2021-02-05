//
//  DetailViewCell.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/05.
//

import UIKit

class PreviewImageCell: UICollectionViewCell {

    var cellImage = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = .blue
        contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cellImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cellImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    func setCellImage(image : UIImage) {
        self.cellImage.image = image
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: .imageCellTouchesBegan, object: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: .imageCellTouchesEnded, object: nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: .imageCellTouchesEnded, object: nil)
    }
    
}

extension Notification.Name {
    static let imageCellTouchesBegan = Notification.Name("imageCellTouchesBegan")
    static let imageCellTouchesEnded = Notification.Name("imageCellTouchesEnded")
}
