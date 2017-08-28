/******************************************************************************
 *
 * SeriesManager
 *
 ******************************************************************************/

import Foundation

public enum SeriesSortType {
    case name
    case airDate
}

public final class SeriesManager {
    
    public static var qualityProfiles = [SeriesQualityProfile]() {
        didSet {
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Constants.Notifications.DoneConfiguringSonarr, object: nil)
            })
        }
    }
    
    public static func qualityProfile(_ id: Int) -> SeriesQualityProfile? {
        
        guard let index = qualityProfiles.index(where: { $0.id == id }) else {
            return nil
        }
        
        return qualityProfiles[index]
    }

    public static func sort(_ series: [Series], sortType: SeriesSortType) -> [Series] {
        
        var newSeries = [Series]()
        
        switch sortType {
        case .name:
            newSeries = series.sorted(by: { $0.title.compare($1.title) == .orderedAscending })
        case .airDate:
            newSeries = series.sorted(by: {
                
                let date1String = $0.nextAiring ?? Date.distantFuture.toString(format: .custom(Constants.SonarrDateFormatString))
                let date2String = $1.nextAiring ?? Date.distantFuture.toString(format: .custom(Constants.SonarrDateFormatString))
                
                if let date1 = Date(fromString: date1String, format: .custom(Constants.SonarrDateFormatString)),
                    let date2 = Date(fromString: date2String, format: .custom(Constants.SonarrDateFormatString)) {
                    
                    if date1.compare(date2 as Date) == .orderedAscending {
                        return true
                    }
                    
                    if date1.compare(date2 as Date) == .orderedDescending {
                        return false
                    }
                    
                    if date1.compare(date2 as Date) == .orderedSame {
                        return $0.title.compare($1.title) == .orderedAscending
                    }
                    
                    return false
                } else {
                    return false
                }
            })
        }
        
        return newSeries
    }
}
