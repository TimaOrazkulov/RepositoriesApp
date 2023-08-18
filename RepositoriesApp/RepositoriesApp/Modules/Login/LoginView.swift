//
//  ContentView.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import SwiftUI

struct LoginView: View {
    @State var tokenText = ""
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            vStack
        }
        .navigationBarBackButtonHidden()
    }

    private var vStack: some View {
        VStack {
            title
            textField
            HStack {
                actionButton
            }
        }
        .padding()
        .modifier(ErrorAlertModifier(isPresented: $viewModel.showError, error: viewModel.error))
    }

    private var title: some View {
        Text("sign_in")
            .font(.title)
            .bold()
    }

    private var textField: some View {
        TextField("enter_generated_token", text: $tokenText)
            .padding(8)
            .overlay(
                RoundedRectangle(
                    cornerRadius: 8
                )
                .stroke(Color.blue, lineWidth: 1)
            )
    }

    private var actionButton: some View {
        LoadingButtonView(isLoading: $viewModel.userIsLoading, title: "sign_in", action: {
            viewModel.getUser(with: tokenText)
        })
        .disabled(tokenText.isEmpty)
        .padding(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
