//
//  shortcuts_http_handler.swift
//  shortcuts-http-handler
//
//  Created by Tim Vergenz on 11/17/23.
//

import AppIntents

struct shortcuts_http_handler: AppIntent {
    static var title: LocalizedStringResource = "shortcuts-http-handler"
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
