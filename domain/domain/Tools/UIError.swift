//
//  UIError.swift
//  domain
//
//  Created by Rza Ismayilov on 08.10.22.
//

public struct UIError: Error {
    public let title: String
    public let description: String
    public let code: String
    
    public init(title: String, description: String, code: String) {
        self.title = title
        self.description = description
        self.code = code
    }
}

extension Error {
    public func toUIError(
        title: String,
        code: String,
        description: String? = nil
    ) -> UIError {
        UIError(
            title: title,
            description: description ?? self.localizedDescription,
            code: code
        )
    }
}
