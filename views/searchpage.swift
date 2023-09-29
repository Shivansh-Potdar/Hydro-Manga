//
//  searchpage.swift
//  Hydro Manga
//
//  Created by Shivansh Potdar on 27/09/23.
//

import SwiftUI

struct searchpage: View {
    var cName: String
//    @ObservedObject var myN = Search();
    @State private var mangaList: [Manga] = []
    
    @State var show = false

    var body: some View {
        Text("\(cName)")
            .font(.title2)
        
        Divider()
        
        List(mangaList){hon in
            NavigationLink(destination: homepage(id: "\(hon.id)", name: "\(hon.attributes.title.en)")){
                VStack(alignment: .leading){
                    Text(hon.attributes.title.en)
                        .font(.title3)
                    Text(hon.id).font(.subheadline)
                }
            }.contextMenu{
                Button{
//                        add to favourites codes
                    show.toggle()
                } label: {
                    Label("Add to favourites", systemImage: "heart")
                }
            }.alert(isPresented: $show){
                Alert(
                    title: Text("Favourites"),
                    message: Text("To be implemented"),
                    dismissButton: .default(Text("Okay"))
                )
            }
        }.onAppear(perform: loadData)
        
        Spacer()
        Divider()
        Text("Hold down to add to favurites")
    }
    
    func loadData() {
        guard let url = URL(string: "http://api.mangadex.org/manga?title=\(cName)") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(MangaData.self, from: data)
                        mangaList = decodedData.data
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error fetching data: \(error)")
                }
            }.resume()
        }
}

#Preview {
    searchpage(cName: "Solo")
}

struct MangaData: Codable {
    let data: [Manga]
}

struct Manga: Codable, Identifiable {
    let id: String
    let type: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let title: Title
}

struct Title: Codable {
    let en: String
}
