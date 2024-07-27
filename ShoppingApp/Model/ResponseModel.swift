//
//  ResponseModel.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation

enum ResponseModel{
    struct Root: Codable {
        let status: Bool?
        let message: String?
      
        let categories: [Category]?
    }

    // MARK: - Category
    struct Category: Codable {
        let id: Int?
        let name: String?
        let items: [Item]?
    }

    // MARK: - Item
    struct Item: Codable {
        let id: Int?
        let name: String?
        let icon: String?
        let price: Double?
        let isLiked = false
    }

}
