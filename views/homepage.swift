//
//  homepage.swift
//  Hydro Manga
//
//  Created by Shivansh Potdar on 26/09/23.
//

import SwiftUI

struct homepage: View {
    var id: String
    var name : String
    @State var description: String = "";
    @State var imageLink: String = "";
    @State var coverArtUrl: String = "";
    @State var coverId: String = "";
    @State var show = false
    
    var body: some View {
        VStack{
            Text(name)
                .font(.title)
                .padding()
            
            AsyncImage(
                url: URL(string: imageLink),
                transaction: Transaction(animation: .easeInOut)
            ){phase in
                switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .transition(
                                .scale(scale: 0.1, anchor: .center))
                    case .failure:
                        Image(systemName: "wifi.slash")
                    @unknown default:
                        EmptyView()
                }
            }
            HStack(alignment: .center){
                TextEditor(text: .constant(description))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: false)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .frame(height: 100)
                VStack{
                    NavigationLink(destination: ContentView()){
                        Label("Open", systemImage: "bolt.fill")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                    .padding()
                    
                    Button{
//                        add favourites code
                    } label: {
                        Label("Favourite", systemImage: "heart")
                    }
                    .colorInvert()
                    
                }
            }.padding()
        }.onAppear{
            fetchData()
        }
    }
    
    func fetchData() {
        // Replace with your actual URL where the JSON is hosted
        guard let url = URL(string: "https://api.mangadex.org/manga/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(MyData.self, from: data)
                    
                    DispatchQueue.main.async {
                        // Update the description property
                        self.description = jsonData.data.attributes.description["en"] ?? ""
                        
                        if let coverArtRelationship = jsonData.data.relationships.first(where: {$0.type == "cover_art"}) {
                            
                            self.coverId = coverArtRelationship.id
                            fetchCoverArtURL(cid: coverId)
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
    
    func fetchCoverArtURL(cid: String) {
            // Replace with the URL to fetch cover art data
            guard let coverArtUrl = URL(string: "https://api.mangadex.org/cover/\(cid)") else { return }
            
            URLSession.shared.dataTask(with: coverArtUrl) { data, _, error in
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
            
                        if let jsonDict = json as? [String: Any],
                        let dataDict = jsonDict["data"] as? [String: Any],
                        let attributesDict = dataDict["attributes"] as? [String: Any],
                        let fileName = attributesDict["fileName"] as? String {
                            self.imageLink = "https://uploads.mangadex.org/covers/\(id)/\(fileName)"
                            } else {
                                print("Failed to extract fileName from JSON")
                            }
                    } catch{
                        print("\(error)")
                    }
    
                    print(coverArtUrl)
                    print("Image final: \(imageLink)")
                } else if let error = error {
                    print("Error fetching cover art data: \(error)")
                }
            }.resume()
        }
}

#Preview {
    homepage(id: "425f2ccf-581f-42cf-aed3-c3312fcde926", name:"Loading")
}


struct MyData: Codable {
    struct Data: Codable {
        struct Attributes: Codable {
            let title: [String: String]
            let description: [String: String]
        }
        let attributes: Attributes
        let relationships: [Relationship]
    }
    let data: Data
}

struct Relationship: Codable {
    let id: String
    let type: String
}
