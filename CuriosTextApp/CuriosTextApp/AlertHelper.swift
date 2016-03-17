//
//  AlertHelper.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/17/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

private struct AlertText {
    // MARK: - Common
    static let attenstion = LocalStrings.Attension.description
    static let cancel = LocalStrings.Cancel.description
    static let done = LocalStrings.Done.description
    
    struct Editor {
        static let EditorDismissMessage = LocalStrings.EditorDismissMessage.description
    }
}

func alert_EditorDismiss(Done:() -> ()) -> UIAlertController {
    let message = AlertText.Editor.EditorDismissMessage
    return alert_Dismiss(message, Done: Done)
}

private func alert_Dismiss(message: String, Done:() -> ()) -> UIAlertController {
    
    let cancelTitle = AlertText.cancel
    let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel, handler: nil)
    
    let doneTitle = AlertText.done
    let doneAction = UIAlertAction(title: doneTitle, style: .Default) {_ in Done()}
    
    let alertTitle = AlertText.attenstion
    let alertMessage = message
    let alertStyle: UIAlertControllerStyle = .Alert
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertStyle)
    
    alert.addAction(cancelAction)
    alert.addAction(doneAction)
    
    return alert
}


