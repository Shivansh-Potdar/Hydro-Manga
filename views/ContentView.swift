//
//  ContentView.swift
//  Hydro Manga
//
//  Created by Shivansh Potdar on 26/09/23.
//

import SwiftUI

struct ContentView: View {
    @State var name: String = "";
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                NavigationLink(destination: searchpage(cName: "\(name)")){
                    Text("Hydro")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .overlay {
                            Rectangle()
                                .stroke()
                        }
                }
                
                TextField("Enter manga name...", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .fontDesign(.rounded)
                    .padding()
                
                Spacer()
                Divider()
                Text("Made by Shivansh Potdar <3")
                    .font(.subheadline)
                    .italic()
                    .padding()
            }
        }.background(Color.black)
    }
}

#Preview {
    ContentView()
}
