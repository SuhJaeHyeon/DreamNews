//
//  User.swift
//  DreamMegazin
//
//  Created by martin on 6/21/24.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var name: String
    var email: String = ""
    var gender: String = ""
    var birthYear: String = ""
    var profileImage: URL? = URL(string: "")
    var profileImageData: String = ""
}
