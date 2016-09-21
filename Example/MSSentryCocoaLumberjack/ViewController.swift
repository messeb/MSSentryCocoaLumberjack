//
//  ViewController.swift
//  MSSentryCocoaLumberjack
//
//  Created by messeb on 05/27/2016.
//  Copyright (c) 2016 messeb. All rights reserved.
//

import UIKit
import CocoaLumberjack
import MSSentryCocoaLumberjack

extension DDLogFlag {
    func stringValue() -> String {
        switch self {
        case DDLogFlag.Debug:
            return "Debug"
        case DDLogFlag.Info:
            return "Info"
        case DDLogFlag.Warning:
            return "Warning"
        case DDLogFlag.Error:
            return "Error"
        default:
            return ""
        }
    }
}

class ViewController: UITableViewController {
    
    @IBOutlet weak var dsnTextField: UITextField!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userIpAddressTextField: UITextField!
    
    @IBOutlet weak var logMessage: UITextField!
    @IBOutlet weak var logTypePicker: UIPickerView!
    
    @IBOutlet weak var extraValue1TextField: UITextField!
    @IBOutlet weak var extraValue2TextField: UITextField!
    @IBOutlet weak var extraValue3TextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var sentryLogger: MSSentryLogger?
    let pickerData = [DDLogFlag.Debug, DDLogFlag.Info, DDLogFlag.Warning, DDLogFlag.Error]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    // MARK: Event Login
    func logEvent() {
        guard let dsn = dsnTextField.text where dsn.characters.count > 0 else { return }
        guard let message = logMessage.text where message.characters.count > 0 else { return }
        let logFlag = pickerData[logTypePicker.selectedRowInComponent(0)]
        
        setUpSentryLoggerIfNeeded(dsn)
        setUser()
        setTagsAndExtraData()
        
        switch logFlag {
        case DDLogFlag.Debug:
            logDebugWithMessage(message)
        case DDLogFlag.Info:
            logInfoWithMessage(message)
        case DDLogFlag.Warning:
            logWarningWithMessage(message)
        case DDLogFlag.Error:
            logErrorWithMessage(message)
        default: break
        }
    }
    
    func logDebugWithMessage(message: String) {
        DDLogDebug(message)
    }
    
    func logInfoWithMessage(message: String) {
        DDLogInfo(message)
    }
    
    func logWarningWithMessage(message: String) {
        DDLogWarn(message)
    }
    
    func logErrorWithMessage(message: String) {
        DDLogError(message)
    }
    
    // MARK: Setup
    func setUpUI() {
        logTypePicker.dataSource = self
        logTypePicker.delegate = self
    }
    
    func setUpSentryLoggerIfNeeded(dsn: String) {
        if sentryLogger != nil { return }
        
        sentryLogger = MSSentryLogger(dsn: dsn)
        
        DDLog.addLogger(sentryLogger)
        
        dsnTextField.enabled = false
    }
    
    func setUser() {
        var userDic:[String: NSObject] = [:]
        
        if let userId = userIdTextField.text where userId.characters.count > 0 {
            userDic["id"] = userId
        }
        
        if let username = usernameTextField.text where username.characters.count > 0 {
            userDic["username"] = username
        }
        
        if let email = userEmailTextField.text where email.characters.count > 0 {
            userDic["email"] = email
        }
        
        if let ip = userIpAddressTextField.text where ip.characters.count > 0 {
            userDic["ip_address"] = ip
        }
        
        sentryLogger?.user = userDic
    }
    
    func setTagsAndExtraData() {
        var extraDic:[String: NSObject] = [:]
        
        if let extra1 = extraValue1TextField.text where extra1.characters.count > 0 {
            extraDic["key1"] = extra1
        }
        
        if let extra2 = extraValue2TextField.text where extra2.characters.count > 0 {
            extraDic["key2"] = extra2
        }
        
        if let extra3 = extraValue3TextField.text where extra3.characters.count > 0 {
            extraDic["key2"] = extra3
        }
        
        sentryLogger?.tags = extraDic
        sentryLogger?.extra = extraDic
    }
    
    func resetUI() {
        userIdTextField.text = ""
        usernameTextField.text = ""
        userEmailTextField.text = ""
        userIpAddressTextField.text = ""
        
        logMessage.text = ""
        logTypePicker.selectRow(0, inComponent: 0, animated: true)
        
        extraValue1TextField.text = ""
        extraValue2TextField.text = ""
        extraValue3TextField.text = ""
    }
    
    // MARK; IBAction
    @IBAction func sendButtonClicked(sender: UIButton?) {
        logEvent()
    }
    
    @IBAction func resetButtonClicked(sender: UIButton?) {
        resetUI()
    }

}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView,
                    titleForRow row: Int,
                                forComponent component: Int) -> String? {
        return pickerData[row].stringValue()
    }
}
