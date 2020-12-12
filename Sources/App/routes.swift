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
    
    app.post("movies"){ req -> EventLoopFuture<Movie> in
      let movie = try req.content.decode(Movie.self) //content = body of httprequest
        return movie.create(on: req.db).map {movie}
        
    }

}
