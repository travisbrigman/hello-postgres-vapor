//
//  File.swift
//  
//
//  Created by Travis Brigman on 12/5/20.
//
import Fluent
import Vapor
import Foundation

final class Movie: Model, Content {
    
    static let schema = "movies" //table name
    
    
    @ID(key: .id) //Property wrapper??
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    init() {}
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
