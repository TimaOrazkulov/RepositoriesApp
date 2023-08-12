//
//  ContentView.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import SwiftUI

struct LoginView: View {

    var body: some View {
        LoginViewBody()
            .navigationBarBackButtonHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
