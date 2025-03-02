//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Result: Codable {
    var id: Int
    var team: String
    var date: String
    var opponent: String
    var score: gameScores
    var isHomeGame: Bool
}

struct gameScores: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        NavigationStack {
            List(results, id: \.id) { item in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(item.team) vs. \(item.opponent)")
                        Spacer()
                        Text("\(item.score.unc) - \(item.score.opponent)")
                    }
                    .font(.headline)
                    HStack {
                        Text(item.date)
                        Spacer()
                        if item.isHomeGame {
                            Text("Home")
                        } else {
                            Text("Away")
                        }
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
