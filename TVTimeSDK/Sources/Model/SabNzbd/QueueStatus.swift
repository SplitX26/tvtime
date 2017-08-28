/******************************************************************************
 *
 * QueueStatus
 *
 ******************************************************************************/

import Foundation

public struct QueueStatus: Codable {
    
    public struct Version: Codable {
        let version: String
    }
    
    public struct Result: Codable {
        
        public struct NewsServer: Codable {
            let ID: Int
            let Active: Bool
        }
        
        enum CodingKeys : String, CodingKey {
            case remainingSizeLo = "RemainingSizeLo"
            case remainingSizeHi = "RemainingSizeHi"
            case remainingSizeMB = "RemainingSizeMB"
            case forcedSizeLo = "ForcedSizeLo"
            case forcedSizeHi = "ForcedSizeHi"
            case forcedSizeMB = "ForcedSizeMB"
            case downloadedSizeLo = "DownloadedSizeLo"
            case downloadedSizeHi = "DownloadedSizeHi"
            case downloadedSizeMB = "DownloadedSizeMB"
            case articleCacheLo = "ArticleCacheLo"
            case articleCacheHi = "ArticleCacheHi"
            case articleCacheMB = "ArticleCacheMB"
            case downloadRate = "DownloadRate"
            case averageDownloadRate = "AverageDownloadRate"
            case downloadLimit = "DownloadLimit"
            case threadCount = "ThreadCount"
            case parJobCount = "ParJobCount"
            case postJobCount = "PostJobCount"
            case urlCount = "UrlCount"
            case upTimeSec = "UpTimeSec"
            case downloadTimeSec = "DownloadTimeSec"
            case serverPaused = "ServerPaused"
            case downloadPaused = "DownloadPaused"
            case download2Paused = "Download2Paused"
            case serverStandBy = "ServerStandBy"
            case postPaused = "PostPaused"
            case scanPaused = "ScanPaused"
            case freeDiskSpaceLo = "FreeDiskSpaceLo"
            case freeDiskSpaceHi = "FreeDiskSpaceHi"
            case freeDiskSpaceMB = "FreeDiskSpaceMB"
            case serverTime = "ServerTime"
            case resumeTime = "ResumeTime"
            case feedActive = "FeedActive"
            case queueScriptCount = "QueueScriptCount"
            case newsServers = "NewsServers"
        }
        
        public let remainingSizeLo: Int
        public let remainingSizeHi: Int
        public let remainingSizeMB: Int
        public let forcedSizeLo: Int
        public let forcedSizeHi: Int
        public let forcedSizeMB: Int
        public let downloadedSizeLo: Int
        public let downloadedSizeHi: Int
        public let downloadedSizeMB: Int
        public let articleCacheLo: Int
        public let articleCacheHi: Int
        public let articleCacheMB: Int
        public let downloadRate: Int
        public let averageDownloadRate: Int
        public let downloadLimit: Int
        public let threadCount: Int
        public let parJobCount: Int
        public let postJobCount: Int
        public let urlCount: Int
        public let upTimeSec: Int
        public let downloadTimeSec: Int
        public let serverPaused: Bool
        public let downloadPaused: Bool
        public let download2Paused: Bool
        public let serverStandBy: Bool
        public let postPaused: Bool
        public let scanPaused: Bool
        public let freeDiskSpaceLo: Int
        public let freeDiskSpaceHi: Int
        public let freeDiskSpaceMB: Int
        public let serverTime: Int
        public let resumeTime: Int
        public let feedActive: Bool
        public let queueScriptCount: Int
        public let newsServers: [NewsServer]
    }
    
    public let result: Result
    
    public func downloadRate() -> String {
        
        let oneMegaByte = 1024.0
        let rate = Double(result.downloadRate) / oneMegaByte
        var value = "-- MB/s"
        
        if rate >= oneMegaByte {
            value = String(format: "%.1f MB/s", rate / oneMegaByte)
        } else if result.downloadRate > 0 {
            value = String(format: "%d Bytes/s", result.downloadRate)
        }
        
        return value
    }
}
