//
//  ListItem.swift
//  laba17-18
//
//  Created by Вадим Мартыненко on 28.04.2023.
//

import SwiftUI

struct ListItem: View {
    
    let wordModel: WordModel
    
    var body: some View {
        HStack{
            Text(wordModel.word)
                .font(.title2)
            Spacer()
            Text(wordModel.translate)
                .foregroundColor(Color.gray)
        }
        .padding(.horizontal)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(wordModel: WordModel(word: "Apple", translate: "Яблоко"))
    }
}
