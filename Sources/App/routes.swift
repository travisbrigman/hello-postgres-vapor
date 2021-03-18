import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("movies"){ req in
        Movie.query(on: req.db).with(\.$actors).with(\.$reviews).all()
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
        return movie.create(on: req.db).map { movie }
        
    }
    
    //MARK: Reviews
    app.post("reviews"){ req -> EventLoopFuture<Review> in
        let review = try req.content.decode(Review.self) //content = body of httprequest
        return review.create(on: req.db).map { review }
        
    }
    
    //MARK: Actors
    app.post("actors"){ req -> EventLoopFuture<Actor> in
        let actor = try req.content.decode(Actor.self)
        return actor.create(on: req.db).map { actor }
    }
    
    //MARK: MovieActors
    
    //movie/:movieId/actor/:actorId
    app.post("movie", ":movieId", "actor", ":actorId") { req -> EventLoopFuture<HTTPStatus> in
        
        //get the movie
        let movie = Movie.find(req.parameters.get("movieId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        let actor = Actor.find(req.parameters.get("actorId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return movie.and(actor).flatMap { (movie, actor) in
            movie.$actors.attach(actor, on: req.db)
        }.transform(to: .ok)
    }
    
    app.get("actors"){ req in
        Actor.query(on: req.db).with(\.$movies).all()
    }
    
}
