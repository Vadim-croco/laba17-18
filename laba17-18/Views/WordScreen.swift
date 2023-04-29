//
//  WordScreen.swift
//  laba17-18
//
//  Created by Вадим Мартыненко on 28.04.2023.
//

import SwiftUI

struct WordScreen: View {
    let wordModel: WordModel
    let addWord: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack{
                Text(wordModel.word)
                    .font(.largeTitle)
                Text("-")
                    .font(.largeTitle)
                Text(wordModel.translate)
                    .font(.largeTitle)
            }
            Spacer()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 5){
                        Image(systemName: "chevron.backward")
                        Text("Назад")
                    }
                }
            }
        }
        .onAppear{
            addWord()
        }
    }
}

struct WordScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            WordScreen(wordModel: WordModel(word: "Apple", translate: "Яблоко")){}
        }
    }
}
