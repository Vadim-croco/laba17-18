//
//  WordModel.swift
//  laba17-18
//
//  Created by Вадим Мартыненко on 28.04.2023.
//

import Foundation

struct WordModel: Hashable {
    let word: String
    let translate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(word + translate)
    }
}
