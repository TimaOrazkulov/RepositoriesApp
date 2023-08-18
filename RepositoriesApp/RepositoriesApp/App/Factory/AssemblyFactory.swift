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
