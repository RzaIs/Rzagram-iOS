//
//  BaseService.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import domain

class BaseService: ObservableObject{
    @Published var isLoading: Bool
    @Published var hasError: Bool
    @Published var error: UIError
    
    init(
        isLoading: Bool = false,
        hasError: Bool = false,
        error: UIError = UIError(title: "title", description: "description", code: "code")
    ) {
        self.isLoading = isLoading
        self.hasError = hasError
        self.error = error
    }
    
    @MainActor
    func set(loading: Bool) {
        self.isLoading = loading
    }
        
    @MainActor
    func show(error: Error) {
        if let error = error as? UIError {
            self.error = error
            self.hasError = true
        } else {
            self.error = error.toUIError(title: "Unknown Error", code: "null")
            self.hasError = true
        }
    }
}
