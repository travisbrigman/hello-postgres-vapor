//
//  MovieActor.swift
//  
//
//  Created by Travis Brigman on 3/17/21.
//

import Foundation
import Vapor
import FluentPostgresDriver
import Fluent

final class MovieActor: Model { //⬅ doesn't need the usual Content protocol since it's NOT being returned to the client
    
    static let schema = "movie_actors"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "movie_id")
    var movie: Movie
    
    @Parent(key: "actor_id")
    var actor: Actor
    
    init() {}
    
    init(movieId: UUID, actorID: UUID) {
        self.$movie.id = movieId
        self.$actor.id = actorID
    }
    
}
