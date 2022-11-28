//
//  LookupViewModel.swift
//  Lookup
//
//  Created by Adrian Bolinger on 11/27/22.
//

import Combine
import Foundation

class LookupViewModel: ObservableObject {
    private lazy var dict = WebstersDictionary()
    private var subscriptions = Set<AnyCancellable>()

    @Published var searchTerm: String?
    @Published var possibleMatches: [String] = []
    @Published var foundDefinition: String = ""

    init() {
        $searchTerm
            .compactMap { $0 }
            .sink { term in
                self.possibleMatches = self.dict.keys.filter { $0.contains(term) }.sorted()
            }
            .store(in: &subscriptions)

        $possibleMatches
            .sink { matches in
                switch matches.count {
                case 0 where self.searchTerm != nil:
                    self.foundDefinition = "Definition not found"
                case 0 where self.searchTerm == nil:
                    self.foundDefinition = ""
                case 1:
                    guard let word = matches.first else {
                        return
                    }
                    self.foundDefinition = self.dict.lookup(word)
                default:
                    self.foundDefinition = ""
                }
            }
            .store(in: &subscriptions)
    }
}
