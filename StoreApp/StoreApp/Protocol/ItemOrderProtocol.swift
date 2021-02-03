//
//  ItemOrderProtocol.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation

protocol ItemOrderProtocol {
    func orderItem(who : String, what : String, quantity : Int, totalPrice : Int)
}
