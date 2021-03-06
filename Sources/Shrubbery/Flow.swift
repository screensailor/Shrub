@_exported import Combine

public typealias Flow<A> = AnyPublisher<Result<A, Error>, Never>

extension Publisher {
    
    public func flow() -> Flow<Output> {
        self
            .map{ .success($0) }
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}

extension Publisher
where
    Output: Droplet,
    Failure == Never
{
    
    public func unflow() -> AnyPublisher<Output.Value, Error> {
        self
            .tryMap{ try $0.get() }
            .eraseToAnyPublisher()
    }
    
    public func flowMap<A>(_ ƒ: @escaping (Output.Value) throws -> A) -> Flow<A> {
        self
            .map{ x in Result{ try ƒ(x.get()) } }
            .eraseToAnyPublisher()
    }
    
    public func flowFlatMap<A>(_ ƒ: @escaping (Output.Value) throws -> Flow<A>) -> Flow<A> {
        self
            .map{ x -> Flow<A> in
                do {
                    return try ƒ(x.get())
                } catch {
                    return Fail(error: error).flow()
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

extension Publisher
where
    Output: Droplet,
    Output.Value: Equatable,
    Failure == Never
{
    public func removeDuplicates() -> Flow<Output.Value> {
        unflow().removeDuplicates().flow()
    }
}

extension Error {
    
    public func flow<A>(of: A.Type = A.self) -> Flow<A> {
        Just(Result<A, Error>.failure(self)).eraseToAnyPublisher()
    }
}
