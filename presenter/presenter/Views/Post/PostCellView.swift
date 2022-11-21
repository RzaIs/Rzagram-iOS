//
//  PostCellView.swift
//  presenter
//
//  Created by Rza Ismayilov on 19.11.22.
//

import Foundation
import SwiftUI
import Kingfisher
import domain

struct PostCellView: View {
    let post: PostEntity
    var body: some View {
        VStack {
            HStack {
                Text(post.author.username)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Spacer()
                Text(post.created.publishDate)
            }
            .padding(.bottom, 1.0)
            
            HStack {
                Text(post.title)
                    .fontWeight(.bold)
                    .dynamicTypeSize(.xLarge)
                Spacer()
            }
            
            HStack {
                switch post.type {
                case .text(let content):
                    Text(content)
                        .lineLimit(4)
                    Spacer()
                    
                case .url(let path):
                    Text(path.absoluteString)
                    
                case .image(let path):
                    KFImage(path)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(24)
                }
            }
            .padding(.top, 1.0)
            
            HStack {
                Image(systemName: "hand.thumbsup.fill")
                    .resizable(resizingMode: .stretch)
//                    .foregroundColor(.blue)
                    .frame(width: 22, height: 22)
                
                Text("12") // Like count
                    .dynamicTypeSize(.xLarge)
                    .padding([.leading ,.trailing], 8)
                
                Image(systemName: "hand.thumbsdown")
                    .resizable(resizingMode: .stretch)
//                    .foregroundColor(.red)
                    .frame(width: 22, height: 22)
                    
    
                Spacer()
                
                Image(systemName: "bubble.left")
                    .resizable(resizingMode: .stretch)
                    .frame(width: 22, height: 22)
                
                Text("12") // Comment count
                    .dynamicTypeSize(.xLarge)
                    .padding(.leading, 8)
                
                Spacer()
                
                Image(systemName: "paperplane")
                    .resizable(resizingMode: .stretch)
                    .frame(width: 22, height: 22)
                
            }.padding(.top)
        }
    }
}

struct PostCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        PostCellView(
            post: PostEntity(
                id: "hsdfjshdfkjsdhg",
                title: "The new breaking change in my app 😎",
                type: .text("This is the begging of my awsome jurney so where sould I begin? I don't even know! This is the begging of my awsome jurney so where sould I begin? I don't even know! This is the begging of my awsome jurney so where sould I begin? I don't even know!"),
//                type: .image(URL(string: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.hFMVVi839wYgVJ_arBo0ZwHaHb%26pid%3DApi&f=1&ipt=491413e980fb00b8eb8b682edc9c2094698fcc1a268bbec1450edb60b0377e9c&ipo=images")!),
                created: Date(),
                updated: Date(),
                author: AuthorEntity(
                    id: "jdfjkashdfj",
                    username: "AuthorUsername"
                )
            )
        )
    }
}
