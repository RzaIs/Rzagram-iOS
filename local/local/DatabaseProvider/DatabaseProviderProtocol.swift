//
//  DatabaseProviderProtocol.swift
//  local
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Realm
import RealmSwift

protocol DatabaseProviderProtocol {
    func read<T: Object>() -> [T]
    func write<T: Object>(objects: [T]) throws
    func deleteAll<T: Object>(of: T.Type) throws
    func observe<T: Object>(object: T, onChange: @escaping (T?) -> Void)
    func observe<T: Object>(of: T.Type, onChange: @escaping ([T]) -> Void)
    func delete<T: Object>(of: T.Type, when: @escaping (T) -> Bool) throws
    func deleteAll() throws
    
    func cache<T: Codable>(data: T, key: UserDefaultDataKey) throws
    func cacheSafe<T: Codable>(data: T, key: KeyChainDataKey) throws
    
    func getCache<T: Codable>(key: UserDefaultDataKey) -> T?
    func getSafeCache<T: Codable>(key: KeyChainDataKey) -> T?
    
    func deleteCache(key: UserDefaultDataKey)
    func deleteSafeCache(key: KeyChainDataKey) throws
}
