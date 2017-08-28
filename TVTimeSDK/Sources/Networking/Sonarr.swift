/******************************************************************************
 *
 * Sonarr
 *
 ******************************************************************************/
import Foundation

public final class Sonarr: Networking {
    
    private struct Keys {
        static let path = "path"
        static let rootFolderPath = "rootFolderPath"
        static let name = "name"
        static let seriesId = "seriesId"
        static let seasonNumber = "seasonNumber"
        static let episodeIds = "episodeIds"
        static let deleteFiles = "deleteFiles"
    }
    
    private struct Commands {
        static let seriesSearch = "SeriesSearch"
        static let seasonSearch = "SeasonSearch"
        static let episodeSearch = "EpisodeSearch"
    }
    
    private struct ServiceKeys {
        static let profileKey = "profile"
        static let statusKey = "status"
        static let seriesKey = "series"
        static let seriesIdKey = "seriesId"
        static let seriesDeleteKey = "seriesDelete"
        static let searchSeriesKey = "lookup"
        static let rootFolderKey = "rootfolder"
        static let getEpisodesKey = "getEpisodesKey"
        static let commandKey = "commandKey"
    }
    
    private static var sonarrRootFolder = ""
    private static let ServerPaths = [
        ServiceKeys.profileKey: "/api/profile",
        ServiceKeys.statusKey: "/api/system/status",
        ServiceKeys.searchSeriesKey: "/api/series/lookup?term=%@",
        ServiceKeys.seriesKey: "/api/series",
        ServiceKeys.seriesIdKey: "/api/series/%@",
        ServiceKeys.seriesDeleteKey: "/api/series/%@?deleteFiles=%@",
        ServiceKeys.rootFolderKey: "/api/rootfolder",
        ServiceKeys.getEpisodesKey: "/api/episode?seriesId=%@",
        ServiceKeys.commandKey: "/api/command"
    ]
    
    public static func setupSonarr(_ completion: (() -> ())?, failure: ((Error) -> Void)?) {
        
        fetchSonarrRootFolder({ (path) in
            sonarrRootFolder = path.path
            fetchSonarrQualityProfiles({ (profiles) in
                SeriesManager.qualityProfiles = profiles
                
                if let completion = completion {
                    completion()
                }
            }, failure: failure)
        }, failure: failure)
    }
    
    private static func fetchSonarrRootFolder(_ success: ((Path) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([Path].self, from: data).first
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let results = results as? Path {
                success?(results)
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.rootFolderKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    private static func fetchSonarrQualityProfiles(_ success: (([SeriesQualityProfile]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([SeriesQualityProfile].self, from: data)
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success, let results = results as? [SeriesQualityProfile] {
                success(results)
            } else if let failure = failure {
                failure(results as! Error)
            }
        }
        
        performGetRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.profileKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func add(_ seriesSearchResult: SeriesSearchResult, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            return true
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        do {
            let searchResult = SeriesSearchResult(with: seriesSearchResult, rootFolderPath: sonarrRootFolder)
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(searchResult)
            performPostRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.seriesKey, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }
    
    public static func seriesSearch(_ seriesId: Int, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            return true
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        do {
            let dictionary: JSONDict = [Keys.name : Commands.seriesSearch, Keys.seriesId : seriesId]
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.commandKey, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }
    
    public static func seasonSearch(_ seriesId: Int, seasonNumber: Int, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            return true
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        do {
            let dictionary: JSONDict = [Keys.name : Commands.seasonSearch, Keys.seriesId : seriesId, Keys.seasonNumber : seasonNumber]
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.commandKey, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch (let error) {
            if let failure = failure {
                failure(error)
            }
        }
    }
    
    public static func episodeSearch(_ episodeId: Int, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            return true
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        do {
            let dictionary: JSONDict = [Keys.name : Commands.episodeSearch, Keys.episodeIds : [episodeId]]
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.commandKey, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }
    
    public static func series(_ sortType: SeriesSortType?, success: (([Series]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()

            do {
                let results = try decoder.decode([Series].self, from: data).filter({ $0.isValid })
                
                if let sortType = sortType {
                    return SeriesManager.sort(results, sortType: sortType)
                } else {
                    return results
                }
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success, let results = results as? [Series] {
                success(results)
            } else if let failure = failure {
                failure(results as! Error)
            }
        }
        
        performGetRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.seriesKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
        
    }
    
    public static func episodes(_ seriesId: Int, success: (([Episode]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([Episode].self, from: data)
            } catch (let error){
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            
            if let episodes = results as? [Episode] {
                if let success = success {
                    success(episodes)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.getEpisodesKey, parameters: [String(seriesId)], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func search(_ term: String, success: (([SeriesSearchResult]) -> Void)?, failure: ((Error) -> (Void))?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([SeriesSearchResult].self, from: data).filter({ $0.isValid })
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success, let results = results as? [SeriesSearchResult] {
                success(results)
            } else if let failure = failure {
                failure(results as! Error)
            }
        }
        
        performGetRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.searchSeriesKey, parameters: [term], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func delete(_ series: Series, deleteFiles: Bool = true, success: ((Bool) -> Void)?, failure: ((Error) -> ())?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            do {
                //Sonarr returns an empty json object if it succeeds, this simply checks that
                guard let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDict else {
                    return false
                }
                
                return object.keys.count == 0
            } catch {
                return false
            }
        }
        
        let completionBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        let params =  [String(series.id), String(deleteFiles)]
        
        performDeleteRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.seriesDeleteKey, parameters: params, postBody: nil, parse: parseBlock, success: completionBlock, failure: failure)
    }
    
    public static func update(_ seriesId: Int, series: Series, success: ((Series) -> Void)?, failure: ((Error) -> ())?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            do {
                let decoder = JSONDecoder()
                
                return try decoder.decode(Series.self, from: data)
                
            } catch (let error) {
                return error
            }
        }
        
        let completionBlock = { (results: Any?) -> Void in
                        
            if let success = success, let results = results as? Series {
                success(results)
            } else if let failure = failure {
                failure(results as! Error)
            }
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(series)
            
            performPutRequest(product: .sonarr, pathDictionary: ServerPaths, key: ServiceKeys.seriesIdKey, parameters: [String(seriesId)], putBody: data, parse: parseBlock, success: completionBlock, failure: failure)
            
        } catch (let error) {
            if let failure = failure {
                failure(error)
            }
        }
    }
}


