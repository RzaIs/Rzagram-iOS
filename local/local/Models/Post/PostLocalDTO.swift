//
//  PostLocalDTO.swift
//  local
//
//  Created by Rza Ismayilov on 08.11.22.
//

import Realm
import RealmSwift

public class PostLocalDTO: Object {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var title: String = ""
    @Persisted public var content: String = ""
    @Persisted public var type: String = ""
    @Persisted public var created: String = ""
    @Persisted public var updated: String = ""
    @Persisted public var authorID: String = ""
    @Persisted public var authorUsername: String = ""
    
    public convenience init(
        id: String,
        title: String,
        content: String,
        type: String,
        created: String,
        updated: String,
        authorID: String,
        authorUsername: String
    ) {
        self.init()
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.created = created
        self.updated = updated
        self.authorID = authorID
        self.authorUsername = authorUsername
    }
}
