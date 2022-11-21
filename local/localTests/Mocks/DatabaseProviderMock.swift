//
//  DatabaseProviderMock.swift
//  localTests
//
//  Created by Rza Ismayilov on 06.11.22.
//

@testable import local
import Realm
import RealmSwift
import Combine

class DatabaseProviderMock: DatabaseProviderProtocol {
    
    var writeInput: PassthroughSubject<Any, Never> = .init()
    var observeOneInput: PassthroughSubject<Any, Never> = .init()
    var observeManyInput: PassthroughSubject<Any, Never> = .init()
    var deleteAllInput: PassthroughSubject<Any, Never> = .init()
    var deleteInput: PassthroughSubject<(Any, Any), Never> = .init()
    var cacheInput: PassthroughSubject<(Codable, UserDefaultDataKey), Never> = .init()
    var cacheSafeInput: PassthroughSubject<(Codable, KeyChainDataKey), Never> = .init()
    var getCacheInput: PassthroughSubject<UserDefaultDataKey, Never> = .init()
    var getSafeCacheInput: PassthroughSubject<KeyChainDataKey, Never> = .init()
    var deleteCacheInput: PassthroughSubject<UserDefaultDataKey, Never> = .init()
    var deleteSafeCacheInput: PassthroughSubject<KeyChainDataKey, Never> = .init()
    
    var readResult: Any? = nil
    var writeResult: Result<Void, Error> = .success(Void())
    var deleteAllResult: Result<Void, Error> = .success(Void())
    var deleteResult: Result<Void, Error> = .success(Void())
    var cacheResult: Result<Void, Error> = .success(Void())
    var cacheSafeResult: Result<Void, Error> = .success(Void())
    var getCacheResult: Result<Any, Error> = .success(0)
    var getSafeCacheResult: Result<Any, Error> = .success(0)
    var deleteSafeCacheResult: Result<Void, Error> = .success(Void())
    
    func read<T: Object>() -> [T] {
        if let data = self.readResult as? [T] {
            return data
        } else {
            return []
        }
    }
    
    func write<T: Object>(objects: [T]) throws {
        self.writeInput.send(objects)
        switch self.writeResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func observe<T: Object>(object: T, onChange: @escaping (T?) -> Void) {
        self.observeOneInput.send((object, onChange))
    }
    
    func observe<T: Object>(of: T.Type, onChange: @escaping ([T]) -> Void) {
        self.observeManyInput.send((of, onChange))
    }
    
    func deleteAll<T: Object>(of: T.Type) throws {
        self.deleteAllInput.send(of)
        switch self.deleteAllResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func delete<T: Object>(of: T.Type, when: @escaping (T) -> Bool) throws {
        self.deleteInput.send((of, when))
        switch self.deleteResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func deleteAll() throws {
        switch self.deleteAllResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func cache<T: Codable>(data: T, key: UserDefaultDataKey) throws {
        self.cacheInput.send((data, key))
        switch self.cacheResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func cacheSafe<T: Codable>(data: T, key: KeyChainDataKey) throws {
        self.cacheSafeInput.send((data, key))
        switch self.cacheSafeResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func getCache<T: Codable>(key: UserDefaultDataKey) -> T? {
        self.getCacheInput.send(key)
        switch self.getCacheResult {
        case .success(let cache):
            return cache as? T
        case .failure(_):
            return nil
        }
    }
    
    func getSafeCache<T: Codable>(key: KeyChainDataKey) -> T? {
        self.getSafeCacheInput.send(key)
        switch self.getSafeCacheResult {
        case .success(let safeCache):
            return safeCache as? T
        case .failure(_):
            return nil
        }
    }
    
    func deleteCache(key: UserDefaultDataKey) {
        self.deleteCacheInput.send(key)
    }
    
    func deleteSafeCache(key: KeyChainDataKey) throws {
        self.deleteSafeCacheInput.send(key)
        switch self.deleteSafeCacheResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
}
