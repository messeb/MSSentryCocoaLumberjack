//
//  MSSentryLogger.swift
//  Pods
//
//  Created by messeb on 24.05.16.
//
//

import Foundation
import CocoaLumberjack
import RavenSwift

extension RavenLogLevel {
    
    public static func convertFromDDLogFlag(flag: DDLogFlag) -> RavenLogLevel {
        var ravenLogLevel: RavenLogLevel
        
        switch flag {
        case DDLogFlag.Debug:
            ravenLogLevel = RavenLogLevel.Debug
        case DDLogFlag.Warning:
            ravenLogLevel = RavenLogLevel.Warning
        case DDLogFlag.Error:
            ravenLogLevel = RavenLogLevel.Error
        case DDLogFlag.Info:
            ravenLogLevel = RavenLogLevel.Info
        default:
            ravenLogLevel = RavenLogLevel.Info
        }
        
        
        return ravenLogLevel
    }
}

public class MSSentryLogger: DDAbstractLogger {
    
    public var extra: [String: NSObject]?
    public var tags: [String: NSObject]?
    public var user: [String: NSObject]?
    
    public init(dsn: String) {
        super.init()
        
        initSentryWithDSN(dsn)
    }
    
    override public func logMessage(logMessage: DDLogMessage!) {
        let additionalExtra = self.extrasCombinedWithMessageExtras(logMessage.message)
        let additionalTags = self.extrasCombinedWithMessageExtras(logMessage.message)
        let ravenLogLevel = RavenLogLevel.convertFromDDLogFlag(logMessage.flag)
        
        RavenClient.sharedClient?.user = self.user
        
        RavenClient.sharedClient?.captureMessage(logMessage.message, level: ravenLogLevel, additionalExtra: additionalExtra, additionalTags: additionalTags, method: logMessage.function, file: logMessage.file, line: Int(logMessage.line))
    }
    
    private func initSentryWithDSN(dsn:String) {
        RavenClient.clientWithDSN(dsn)
    }
    
    func tagsCombinedWithMessageTags(message: String) -> [String: NSObject] {
        let messageTags = self.extractTags(fromMessage: message)
        
        return self.combine(dict: self.tags ?? [:], withDict:messageTags)
    }
    
    private func extrasCombinedWithMessageExtras(message: String) -> [String: NSObject] {
        let messageExtras = self.extractExtras(fromMessage: message)
        
        return self.combine(dict: self.extra ?? [:], withDict:messageExtras)
    }
    
    private func extractTags(fromMessage message: String) -> [String: NSObject] {
        let regex = "(?<=\\[).+?(?=\\])"
        let tags = extractDictionary(fromMessage: message, withRegEx: regex)
        
        return tags
    }
    
    private func extractExtras(fromMessage message: String) -> [String: NSObject] {
        let regex = "(?<=\\{).+?(?=\\})"
        let tags = extractDictionary(fromMessage: message, withRegEx: regex)
        
        return tags
    }
    
    private func extractDictionary(fromMessage message: String, withRegEx regex:String) -> [String: NSObject] {
        var tags:[String: NSObject] = [:]
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = message as NSString
            let results = regex.matchesInString(message, options: [], range: NSMakeRange(0, nsString.length))
            results.forEach {
                let valuesString = nsString.substringWithRange($0.range)
                let values = valuesString.componentsSeparatedByString(";")
                values.forEach {
                    let splitted = $0.componentsSeparatedByString("=")
                    if splitted.count == 2 {
                        let key = splitted[0]
                        let value = splitted[1]
                        
                        tags[key] = value
                    }
                }
            }
            
            return tags
        } catch {
            return [:]
        }
    }
    
    private func combine(dict dict01: [String: NSObject], withDict dict02: [String: NSObject]) -> [String: NSObject] {
        let combinedDict = dict01.reduce(dict02) { (var d, p) in
            d[p.0] = p.1
            return d
        }
        
        return combinedDict
    }
}