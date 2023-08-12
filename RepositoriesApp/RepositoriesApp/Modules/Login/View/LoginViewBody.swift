//
//  LoginViewBody.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import SwiftUI

struct LoginViewBody: View {
    @State var tokenText: String = ""
    @State var isPressed = false

    var body: some View {
        ZStack {
            VStack {
                Text("sign_in")
                    .font(.title)
                    .bold()
                TextField("enter_generated_token", text: $tokenText)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                        .stroke(Color.blue, lineWidth: 1)
                    )
                Button("sign_in") {
                    isPressed = true
                }
                .padding(8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct LoginViewBody_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewBody()
    }
}
