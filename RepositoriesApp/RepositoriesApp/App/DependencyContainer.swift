import Swinject

struct DependencyContainer {
    static let shared = DependencyContainer()
    
    private let assembler = AssemblerFactory().makeAssembler()
    
    func resolve<T>(_ type: T.Type) -> T? {
        assembler.resolver.resolve(T.self)
    }
}
