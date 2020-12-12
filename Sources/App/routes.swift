import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("movies"){ req in
        Movie.query(on: req.db).all()
    }
    
    //movies/id
    
    app.get("movies", ":movieid") { req -> EventLoopFuture<Movie> in
        Movie.find(req.parameters.get("movieid"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    app.put("movies") { req -> EventLoopFuture<HTTPStatus> in
        let movie = try req.content.decode(Movie.self)
        
        return Movie.find(movie.id, on:  req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = movie.title
                return $0.update(on: req.db).transform(to: .ok)
        }
        
    }
    
    app.delete("movies",":movieid") { req -> EventLoopFuture<HTTPStatus> in
        Movie.find(req.parameters.get("movieid"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
        }.transform(to: .ok)
        
    }
    
    app.post("movies"){ req -> EventLoopFuture<Movie> in
      let movie = try req.content.decode(Movie.self) //content = body of httprequest
        return movie.create(on: req.db).map {movie}
        
    }

}
