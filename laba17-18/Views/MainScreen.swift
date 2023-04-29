//
//  MainScreen.swift
//  laba17-18
//
//  Created by Вадим Мартыненко on 28.04.2023.
//

import SwiftUI

struct MainScreen: View {
    
    @StateObject var wordsViewModel: WordsViewModel = WordsViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                TextField("Слово:", text: $wordsViewModel.searchValue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                List{
                    Section(wordsViewModel.titleSection.rawValue) {
                        ForEach(wordsViewModel.filteredWords, id: \.self) { word in
                            NavigationLink(destination: {
                                WordScreen(wordModel: word){
                                    wordsViewModel.addWord(word: word.word, translate: word.translate)
                                }
                            }) {
                                ListItem(wordModel: word)
                            }
                        }

                    }
                }
                .listStyle(PlainListStyle())
            }
            .toolbar{
                ToolbarItem(placement: .principal) {
                    if wordsViewModel.showPogressView {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Переводчик")
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
