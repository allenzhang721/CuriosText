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
    static let attenstion = LocalStrings.attension.description
    static let cancel = LocalStrings.cancel.description
    static let done = LocalStrings.done.description
    
    struct Editor {
        static let EditorDismissMessage = LocalStrings.editorDismissMessage.description
    }
}

func alert_EditorDismiss(_ Done: @escaping () -> ()) -> UIAlertController {
    let message = AlertText.Editor.EditorDismissMessage
    return alert_Dismiss(message, Done: Done)
}

private func alert_Dismiss(_ message: String, Done: @escaping () -> ()) -> UIAlertController {
    
    let cancelTitle = AlertText.cancel
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
    
    let doneTitle = AlertText.done
    let doneAction = UIAlertAction(title: doneTitle, style: .default) {_ in Done()}
    
    let alertTitle = AlertText.attenstion
    let alertMessage = message
    let alertStyle: UIAlertControllerStyle = .alert
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertStyle)
    
    alert.addAction(cancelAction)
    alert.addAction(doneAction)
    
    return alert
}


