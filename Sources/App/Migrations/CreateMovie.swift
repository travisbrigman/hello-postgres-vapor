//
//  File.swift
//  
//
//  Created by Travis Brigman on 12/4/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateMovie: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies") //⬅ Table Name
            .id()
            .field("title", .string) //⬅ Column Name
            .create()
        
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies").delete()
    }
}
