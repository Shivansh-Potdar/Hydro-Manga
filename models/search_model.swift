//
//  search_model.swift
//  Hydro Manga
//
//  Created by Shivansh Potdar on 27/09/23.
//

import Foundation



class Results: ObservableObject {
    @Published var title = "";
    @Published var mId = "";
    let identifier = UUID();
    
}
