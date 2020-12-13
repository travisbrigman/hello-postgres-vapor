//
//  Review.swift
//  
//
//  Created by Travis Brigman on 12/12/20.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Review: Model, Content {
    static let schema: String = "reviews"
    
    @ID(key: .id) //PK
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "body")
    var body: String
    
    @Parent(key: "movie_id") //FK
    var movie: Movie
    
    init() { } // in case you want to call this instance and not have to set anything up
    init(id:UUID? = nil, title: String, body: String, movieId: UUID) {
        self.id = id
        self.title = title
        self.body = body
        self.$movie.id = movieId //$ is used to access the underlying property. "accessing the property wrapper."
    }
}
