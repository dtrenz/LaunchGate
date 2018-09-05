//
//  WordingHandler.swift
//  LaunchGate
//
//  Created by Nicolas CHARVOZ on 03/09/2018.
//

import Foundation

open class WordingHandler {
    var requiredUpdateMessage: String?
    var optionalUpdateMessage: String?
    var alertMessage: String?
    var dismissTitle: String?
    var downloadTitle: String?

    public init(requiredUpdateMessage: String?,
                optionalUpdateMessage: String?,
                alertMessage: String?,
                dismissTitle: String?,
                downloadTitle: String?) {
        self.requiredUpdateMessage = requiredUpdateMessage
        self.optionalUpdateMessage = optionalUpdateMessage
        self.alertMessage = alertMessage
        self.dismissTitle = dismissTitle
        self.downloadTitle = downloadTitle
    }
}
