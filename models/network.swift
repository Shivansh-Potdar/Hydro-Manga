//
//  network.swift
//  Hydro Manga
//
//  Created by Shivansh Potdar on 27/09/23.
//

import Foundation

class Search: ObservableObject {
    struct Manga: Codable {
        let data: [Data]
    }

    struct Data: Codable, Identifiable {
        let id: String
        let attributes: Attributes
    }

    struct Attributes: Codable {
        let title: Title
    }

    struct Title: Codable{
        let en: String
    }
    
    @Published var name: String = ""
    
    @Published private(set) var manga: Manga?
    
    init(){
        Task.init{
            await fetchData();
        }
    }
    
    func fetchData() async {
        do {
            guard let url = URL(string: "https://api.mangadex.org/manga?title=\(name)") else { fatalError("Missing URL") }
            
            let urlRequest = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try JSONDecoder().decode(Manga.self, from: data)
            
            DispatchQueue.main.async {
                self.manga = decodedData
            }
            
        } catch {
            print("Error fetching data from Mangadex: \(error)")
        }
    }
}
