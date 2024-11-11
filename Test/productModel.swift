//
//  productModel.swift
//  Test
//
//  Created by Pranaya on 11/11/24.
//

import Foundation

struct Items: Codable{
    let products: [Product]
}

struct Product: Codable{
    let name: String
    let salePrice: Double
}
