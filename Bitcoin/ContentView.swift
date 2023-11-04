//
//  ContentView.swift
//  Bitcoin
//
//  Created by Kovács Márk on 21/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var responseData = ""
    
    var body: some View {
        ZStack {
            Color.mint
            HStack {
                Text(responseData)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding()
            .onAppear() {
                //fetchDataToJSON()
                Task {
                    do {
                        let data = try await fetchDataAsync()
                        self.responseData = "\(data.bpi.EUR.rate) \(data.bpi.EUR.code)"
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } //ZStack
        .ignoresSafeArea()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed(String)
    }
    
    func fetchDataAsync() async throws -> BitcoinData {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed("Invalid response")
        }
        
        return try JSONDecoder().decode(BitcoinData.self, from: data)
    }
    
    
    func fetchDataToJSON() {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data) {
                    print(jsonResponse)
                }
            }
        }
        .resume()
    }
    
}

#Preview {
    ContentView()
}
