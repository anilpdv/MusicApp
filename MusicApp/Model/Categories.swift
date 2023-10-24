//
//  Categories.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import Foundation

struct CategoriesResponse: Decodable {
    let categories: Categories
}

struct Categories: Decodable {
    let href: String
    let items: [Category]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

struct Category: Decodable, Equatable {
    let href: String
    let icons: [Icon]
    let id: String
    let name: String

    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}

struct Icon: Decodable {
    let height: Int?
    let url: String
    let width: Int?
}
