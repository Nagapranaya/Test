//
//  productDetailModel.swift
//  Test
//
//  Created by Pranaya on 11/13/24.
//

import Foundation
struct ProductDetail: Codable{
    let products: [Detail]
    
}

struct Detail: Codable{
    let name: String
    let regularPrice: Double
    let salePrice: Double
    let longDescription: String
    let sku: Int64
    let image: String
}
