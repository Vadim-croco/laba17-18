//
//  WordsViewModel.swift
//  laba17-18
//
//  Created by Вадим Мартыненко on 28.04.2023.
//

import Foundation
import CoreData
import Alamofire

class WordsViewModel: ObservableObject {
    let container: NSPersistentContainer
    
    @Published var words: [WordModel] = []
    @Published var filteredWords: [WordModel] = []
    @Published var searchValue: String = "" {
        didSet {
            searching(searchValue: searchValue)
        }
    }
    
    enum TitleSection: String {
        case history = "История"
        case search = "Поиск"
    }
    
    @Published var titleSection: TitleSection = .history
    @Published var showPogressView: Bool = false
    
    init(){
        container = NSPersistentContainer(name: "Words")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        fetchWords()
    }
    
    func addWord(word: String, translate: String) {
        if !isHaveWordInCoreData(word: word, translate: translate) {
            let newWord = WordEntity(context: container.viewContext)
            newWord.word = word
            newWord.translate = translate
            newWord.dataCreated = Date()
            
            saveContext()
        }
    }
    
    func searching(searchValue: String){
        if searchValue.isEmpty {
            filteredWords = words
            titleSection = .history
            
            showPogressView = false
        } else {
            titleSection = .search
            
            let searchingInWords = words.filter{$0.word.lowercased().contains(searchValue.lowercased()) || $0.translate.lowercased().contains(searchValue.lowercased())}
            
            if searchingInWords.isEmpty {
                showPogressView = true
                
                let languageRequest = getLanguageRequest(value: searchValue)
                
                let urlString = "https://api.mymemory.translated.net/get?q=\(searchValue)&langpair=\(languageRequest)"
                
                if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded) {
                    AF
                        .request(url)
                        .responseDecodable(of: GetWord.self) { response in
                            if let value = response.value {
                                if self.searchValue == searchValue {
                                    self.filteredWords = [WordModel(word: searchValue, translate: value.responseData.translatedText)]
                                    
                                    self.showPogressView = false
                                }
                            } else {
                                if let error = response.error {
                                    print(error)
                                }
                            }
                        }
                }
                
            } else {
                filteredWords = searchingInWords
                
                showPogressView = false
            }
        }
    }
    
    func getLanguageRequest(value: String) -> String {
        let ru = "й ц у к е н г ш щ з х ъ ё ф ы в а п р о л д ж э я ч с м и т ь б ю".split(separator: " ")
        
        var isRu = false
        
        for letter in ru {
            if value.contains(letter) {
                isRu = true
                break
            }
        }
        
        if isRu {
            return "ru|en"
        } else {
            return "en|ru"
        }
    }
    
    func saveContext() {
        do {
            try container.viewContext.save()
            fetchWords()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func isHaveWordInCoreData(word: String, translate: String) -> Bool {
        let request = NSFetchRequest<WordEntity>(entityName: "WordEntity")
        
        do{
            let entities = try container.viewContext.fetch(request)
            
            let wordModelList: [WordModel] = entities.map { entity in
                return WordModel(word: entity.word ?? "", translate: entity.translate ?? "")
            }
            
            if wordModelList.contains(WordModel(word: word, translate: translate)) {
                return true
            } else {
                return false
            }
        } catch let error {
            print("Error: \(error)")
        }
        
        return false
    }
    
    func fetchWords() {
        let request = NSFetchRequest<WordEntity>(entityName: "WordEntity")
        
        do{
            let entities = try container.viewContext.fetch(request)
            let sortedEntities = entities.sorted(by: {$0.dataCreated ?? Date() > $1.dataCreated ?? Date()})
            
            words = sortedEntities.map({ enitity in
                return WordModel(word: enitity.word ?? "", translate: enitity.translate ?? "")
            })
            
            if searchValue.isEmpty {
                filteredWords = words
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
}
