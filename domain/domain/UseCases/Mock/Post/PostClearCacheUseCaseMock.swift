//
//  PostClearCacheUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 21.11.22.
//

public class PostClearCacheUseCaseMock: BaseThrowsUseCase<Void, Void> {
    public override func execute(input: Void) throws -> Void {
        print("cleared caches")
    }
}
