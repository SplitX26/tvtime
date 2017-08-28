/******************************************************************************
 *
 * CouchPotato
 *
 ******************************************************************************/

import Foundation

public final class CouchPotato: Networking {
    
    public enum Commands: String {
        
        case searchAllWanted = "Full Search"
        case restart = "Restart"
        case shutdown = "Shutdown"
        
        public static let allValues = [searchAllWanted, restart, shutdown]
    }
    
    private struct Keys {
        static let list = "list"
        static let movies = "movies"
        static let success = "success"
        static let media = "media"
    }
    
    private struct ServiceKeys {
        static let movieListKey = "movieList"
        static let snatchedMovieListKey = "snatchedMovieList"
        static let addMovieKey = "movieAdd"
        static let deleteMovieKey = "movieDelete"
        static let getMovieKey = "movieGet"
        static let editMovieKey = "movieEdit"
        static let searchMoviesKey = "movieSearch"
        static let qualitiesKey = "profileList"
        static let ignoreReleaseKey = "ignoreRelease"
        static let manualDownloadKey = "manualDownload"
        static let fullSearchKey = "fullSearch"
        static let appRestartKey = "appRestart"
        static let appShutdownKey = "appShutdown"
    }
    
    private static let ServerPaths = [
        ServiceKeys.movieListKey: "/movie.list?status=active",
        ServiceKeys.snatchedMovieListKey: "/movie.list?release_status=snatched,missing,available,downloaded",
        ServiceKeys.addMovieKey: "/movie.add?title=%@&identifier=%@",
        ServiceKeys.editMovieKey: "/movie.edit?id=%@&profile_id=%@",
        ServiceKeys.deleteMovieKey: "/movie.delete?id=%@&delete_from=wanted",
        ServiceKeys.ignoreReleaseKey: "/release.ignore?id=%@",
        ServiceKeys.searchMoviesKey: "/movie.search?q=%@",
        ServiceKeys.qualitiesKey: "/profile.list",
        ServiceKeys.getMovieKey: "/media.get?id=%@",
        ServiceKeys.manualDownloadKey: "/release.manual_download?id=%@",
        ServiceKeys.fullSearchKey: "/movie.searcher.full_search",
        ServiceKeys.appRestartKey: "/app.restart",
        ServiceKeys.appShutdownKey: "/app.shutdown",
        ]
    
    @objc public static func appShutdown() {
        
        let parseBlock = { (data: Data) -> Any? in
            return nil
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.appShutdownKey, parameters: nil, parse: parseBlock, success: nil, failure: nil)
    }
    
    @objc public static func appRestart() {
        
        let parseBlock = { (data: Data) -> Any? in
            return nil
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.appRestartKey, parameters: nil, parse: parseBlock, success: nil, failure: nil)
    }
    
    @objc public static func fullSearch() {
        
        let parseBlock = { (data: Data) -> Any? in
            return nil
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.fullSearchKey, parameters: nil, parse: parseBlock, success: nil, failure: nil)
    }
    
    public static func search(_ term: String, sortType: MovieSortType?, success: (([MovieSearchResult]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(MovieSearch.self, from: data).movies
            } catch {
                return [MovieSearchResult]()
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [MovieSearchResult])
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.searchMoviesKey, parameters: [term], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func add(_ searchResult: MovieSearchResult, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Success.self, from: data).success
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        var parameters = [searchResult.title, searchResult.imdb]
        
        if let profileId = searchResult.profileId {
            parameters.append(String(format: "profile_id=%@", profileId))
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.addMovieKey, parameters: parameters, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func download(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Success.self, from: data).success
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.manualDownloadKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func update(_ movie: Movie, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Success.self, from: data).success
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        guard let profileId = movie.profile?.id else {
            fatalError()
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.editMovieKey, parameters: [movie.id, profileId], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func getMovie(_ id: String, success: ((MovieDetails?) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(MovieDetails.self, from: data)
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let results = results as? MovieDetails {
                if let success = success {
                    success(results)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.getMovieKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func delete(_ movie: Movie, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Success.self, from: data).success
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.deleteMovieKey, parameters: [movie.id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func ignore(_ release: MovieRelease, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Success.self, from: data).success
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.ignoreReleaseKey, parameters: [release.id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func wantedMovies(_ sortType: MovieSortType?, success: (([Movie]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Movies.self, from: data).results?.filter({ $0.isValid })
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let results = results as? [Movie] {
                if let success = success {
                    success(results)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.movieListKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func snatchedMovies(_ sortType: MovieSortType?, success: (([Movie]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Movies.self, from: data).results?.filter({ $0.isValid })
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let results = results as? [Movie] {
                if let success = success {
                    success(results)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.snatchedMovieListKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }

    public static func setupCouchPotato(_ success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        fetchCPQualityProfiles({ (profiles) in
            MoviesManager.movieProfiles = profiles
            if let success = success {
                success(true)
            }
        }, failure: failure)
    }
    
    public static func fetchCPQualityProfiles(_ success: ((MovieProfileList?) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(MovieProfileList.self, from: data)
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success, let results = results as? MovieProfileList {
                success(results)
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .couchPotato, pathDictionary: ServerPaths, key: ServiceKeys.qualitiesKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
}
