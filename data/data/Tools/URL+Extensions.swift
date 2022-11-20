//
//  URL+Extensions.swift
//  data
//
//  Created by Rza Ismayilov on 08.11.22.
//

extension URL {
    init(optional: String) {
        self = URL(string: optional) ?? URL(
            string:"https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmiro.medium.com%2Fmax%2F1200%2F1*6FVkh62q28nvgoNzSZVNHA.jpeg&f=1&nofb=1&ipt=5d4ccda1e4f0852be996eb939753426fc319dade80e940daaf919c90c87d61aa&ipo=images")!
    }
}
