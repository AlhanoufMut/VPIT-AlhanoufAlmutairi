//
//  data.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 05/12/1442 AH.
//

import Foundation

struct Output: Codable {
//    let code: Code
//    let meta: Meta
    let data: [User]
}

struct User: Codable {
    let id : Int
    let name : String
    let email : String
    let gender : String
    let status : String
}



