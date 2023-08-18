//
//  AssemblyFactory.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 13.08.2023.
//

import Swinject

final class AssemblerFactory {
    func makeAssembler() -> Assembler {
        Assembler(
            [
                SessionAssembly(),
                BaseURLAssembly(),
                NetworkAssembly(),
                UserAssembly(),
                RepositoriesAssembly(),
                RouterAssembly()
            ]
        )
    }
}
