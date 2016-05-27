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
    
    public var extra: [String: AnyObject]?
    public var tags: [String: AnyObject]?
    public var user: [String: AnyObject]?
    
    public init(dsn: String) {
        super.init()
        
        initSentryWithDSN(dsn)
    }
    
    override public func logMessage(logMessage: DDLogMessage!) {
        let additionalExtra = extra ?? [:]
        let additionalTags = tags ?? [:]
        let ravenLogLevel = RavenLogLevel.convertFromDDLogFlag(logMessage.flag)
        
        RavenClient.sharedClient?.user = self.user
        
        RavenClient.sharedClient?.captureMessage(logMessage.message, level: ravenLogLevel, additionalExtra: additionalExtra, additionalTags: additionalTags, method: logMessage.function, file: logMessage.file, line: Int(logMessage.line))
    }
    
    private func initSentryWithDSN(dsn:String) {
        RavenClient.clientWithDSN(dsn)
    }
}