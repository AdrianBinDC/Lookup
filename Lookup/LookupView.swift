//
//  LookupView.swift
//  Lookup
//
//  Created by Adrian Bolinger on 11/27/22.
//

import SwiftUI

struct LookupView: View {
    @StateObject var viewModel: LookupViewModel

    var body: some View {
        VStack {
            HStack {
                TextField("Enter search term", text: $viewModel.searchTerm)
                    .textFieldStyle(.plain)
                if !viewModel.searchTerm.isEmpty {
                    Button {
                        viewModel.searchTerm = ""
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                    .buttonStyle(.plain)

                }
            }

            switch (viewModel.possibleMatches.count, viewModel.searchTermSelected) {
            case (0, _):
                Text("")
            case (1, _), (2..., true):
                Text(viewModel.foundDefinition)
            default:
                Divider()
                Text("\(viewModel.possibleMatches.count) matches")
                List(viewModel.possibleMatches) { match in
                    Button(match.term) {
                        viewModel.searchTerm = match.term
                        viewModel.searchTermSelected = true
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("Q")

        }
        .padding()
    }
}

struct LookupView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LookupViewModel()

        LookupView(viewModel: viewModel)
    }
}
