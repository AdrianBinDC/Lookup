//
//  LookupViewModel.swift
//  Lookup
//
//  Created by Adrian Bolinger on 11/27/22.
//

import Combine
import Foundation

struct Match: Identifiable {
    var id = UUID()
    var term: String
}

class LookupViewModel: ObservableObject {
    private lazy var dict = WebstersDictionary()
    private var subscriptions = Set<AnyCancellable>()

    @Published var searchTerm: String = "" {
        didSet {
            searchTermSelected = false
        }
    }
    @Published var possibleMatches: [Match] = []
    @Published var foundDefinition: String = ""
    @Published var searchTermSelected = false

    init() {
        $searchTerm
            .compactMap { $0 }
            .debounce(for: .milliseconds(250),
                      scheduler: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { term in
                self.possibleMatches = self.dict.keys
                    .filter { $0.contains(term) }
                    .sorted()
                    .map { Match(term: $0) }
            }
            .store(in: &subscriptions)

        $possibleMatches
            .debounce(for: .milliseconds(250),
                      scheduler: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { matches in
                switch matches.count {
                case 0 where !self.searchTerm.isEmpty:
                    self.foundDefinition = "Definition not found"
                case 0 where self.searchTerm.isEmpty:
                    self.foundDefinition = ""
                case 1:
                    guard let match = matches.first else {
                        return
                    }
                    self.foundDefinition = self.dict.lookup(match.term)
                case 2... where self.searchTermSelected:
                    self.foundDefinition = self.dict.lookup(self.searchTerm)
                default:
                    self.foundDefinition = ""
                }
            }
            .store(in: &subscriptions)

        $searchTermSelected
            .sink { selected in
                if selected {
                    self.foundDefinition = self.dict.lookup(self.searchTerm)
                }
            }
            .store(in: &subscriptions)
    }
}
