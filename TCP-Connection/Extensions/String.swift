//
//  String.swift
//  TCP-Connection
//
//  Created by Rana Farooq Hassan on 13/07/2021.
//

import Foundation

extension String {
        func base64Encoded() -> String? {
            return data(using: .utf8)?.base64EncodedString()
        }
        func base64Decoded() -> String? {
            if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
                        return String(data: data, encoding: .utf8)
                    }
            return nil

        }
}
