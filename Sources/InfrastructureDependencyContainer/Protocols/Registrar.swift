public protocol Registrar
{
    func register<T>(service: T.Type, withProvider: @escaping () -> T)
}
