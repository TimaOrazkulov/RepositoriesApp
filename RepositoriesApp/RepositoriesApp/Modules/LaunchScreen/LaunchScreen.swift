//
//  LaunchScreen.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import SwiftUI

struct LaunchScreen: View {
    @ObservedObject var viewModel: LaunchScreenViewModel

    var body: some View {
        ZStack {
            Color(.blue)
                .ignoresSafeArea()
            Text("repository_app")
                .font(.largeTitle)
                .foregroundColor(.white)
        }.onAppear(perform: viewModel.showNextScreen)
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen(
            viewModel: LaunchScreenViewModel(
                router: Router.shared,
                networkClient: assembler.resolver.resolve(NetworkClient.self)!,
                authCredentialsProvider: assembler.resolver.resolve(AuthCredentialsProvider.self)!
            )
        )
    }
}
