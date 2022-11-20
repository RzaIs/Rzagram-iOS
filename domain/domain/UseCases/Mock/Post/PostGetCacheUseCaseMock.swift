//
//  PostGetCacheUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 19.11.22.
//

#if DEBUG

public class PostGetCacheUseCaseMock: BaseUseCase<Void, [PostEntity]> {
    
    private let value: [PostEntity]
    
    public init(value: [PostEntity]) {
        self.value = value
    }

    public override func execute(input: Void) -> [PostEntity] {
        self.value
    }
}

#endif
