//
//  HomePage.swift
//  presenter
//
//  Created by Rza Ismayilov on 08.11.22.
//

import SwiftUI

struct HomePage: BasePage {
    typealias Service = HomeService

    @Environment(\.colorScheme) var theme

    var router: RouterProtocol
    @StateObject var service: HomeService
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.service.posts) { post in
                    PostCellView(post: post)
                        .padding([.top, .bottom], 8.0)
                }
                if self.service.hasNext {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(
                                    tint: DuoColor(.black, .white).color(theme)
                                )
                            )
                            .scaleEffect(1.28)
                            .onAppear {
                                Task {
                                    await self.service.loadPosts()
                                }
                            }
                        Spacer()
                    }.frame(height: 100)
                }
            }
            .navigationTitle("Home")
            .refreshable {
                await self.service.refreshPosts()
            }
            .onAppear {
                self.appear()
            }
            .onDisappear {
                self.disappear()
            }
        }.alert(isPresented: self.$service.hasError) {
            self.alertView
        }
    }
}

#if DEBUG

import domain

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        RouterMock.router.postGetAndCacheUseCaseValue = .init(
            page: 0,
            count: 4,
            hasNext: false,
            data: [
                PostEntity(
                    id: "sdfhsdjhgsergsdf",
                    title: "title",
                    type: .text("text"),
                    created: Date(),
                    updated: Date(),
                    author: AuthorEntity(
                        id: "skfjskldfjklsa",
                        username: "AuthorUsername"
                    )
                ),
                PostEntity(
                    id: "sdfhsdgsergsdf",
                    title: "title",
                    type: .image(URL(string: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.hFMVVi839wYgVJ_arBo0ZwHaHb%26pid%3DApi&f=1&ipt=491413e980fb00b8eb8b682edc9c2094698fcc1a268bbec1450edb60b0377e9c&ipo=images")!),
                    created: Date(),
                    updated: Date(),
                    author: AuthorEntity(
                        id: "skfjskldfjklsa",
                        username: "AuthorUsername"
                    )
                ),
                PostEntity(
                    id: "sdfhsdgsergsdf",
                    title: "title",
                    type: .text("text"),
                    created: Date(),
                    updated: Date(),
                    author: AuthorEntity(
                        id: "skfjskldfjklsa",
                        username: "AuthorUsername"
                    )
                ),
                PostEntity(
                    id: "sdfhsdgsergsdf",
                    title: "title",
                    type: .text("text"),
                    created: Date(),
                    updated: Date(),
                    author: AuthorEntity(
                        id: "skfjskldfjklsa",
                        username: "AuthorUsername"
                    )
                ),
                PostEntity(
                    id: "sdfhsdgsergsdf",
                    title: "title",
                    type: .text("text"),
                    created: Date(),
                    updated: Date(),
                    author: AuthorEntity(
                        id: "skfjskldfjklsa",
                        username: "AuthorUsername"
                    )
                ),
                PostEntity(
                    id: "sdfhsdgsergsdf",
                    title: "title",
                    type: .text("text"),
                    created: Date(),
                    updated: Date(),
                    author: AuthorEntity(
                        id: "skfjskldfjklsa",
                        username: "AuthorUsername"
                    )
                ),
                PostEntity(
                    id: "sdfhsdgsergsdf",
                    title: "title",
                    type: .text("text"),
                    created: Date(),
                    updated: Date(),
                    author: AuthorEntity(
                        id: "skfjskldfjklsa",
                        username: "AuthorUsername"
                    )
                )
            ]
        )
        return RouterMock.router.homePage
    }
}

#endif

