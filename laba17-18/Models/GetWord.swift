//
//  GetWord.swift
//  laba17-18
//
//  Created by Вадим Мартыненко on 28.04.2023.
//

import Foundation

struct GetWord: Codable {
    let responseData: ResponseData
}

struct ResponseData: Codable {
    let translatedText: String
}
