//
//  BaseService.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import domain
import Combine

class BaseService: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: UIError? = nil {
        didSet {
            if error != nil {
                self.hasError = true
            }
        }
    }
    
    var cancellables: Set<AnyCancellable> = .init()
    
    @MainActor
    func set(loading: Bool) {
        self.isLoading = loading
    }
        
    @MainActor
    func show(error: Error) {
        if let error = error as? UIError {
            self.error = error
        } else {
            self.error = error.toUIError(title: "Unknown Error", code: "null")
        }
    }
    
    func appear() {}
    
    func disappear() {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
}
