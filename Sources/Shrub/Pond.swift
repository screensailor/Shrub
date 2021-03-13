/**
 * - Datum<Key, Value, Context> instead of Result<Value, Error>
 * - events vs? streams - i.e. events as streams of () or of Event value?
 * - subscribing vs observing
 * - concurrent and serial dependencies - i.e. group vs sequence
 * - flat collections (path components) vs deep documents (values)
 * - decoder & encoder of ``Shrubbery`` (`as _: A.Type` tries a cast then decode where `A: Decodable`)
 */
public struct Datum<Key, Value, Context> where Key: Hashable {
    public let source: Route<Key>
    public let result: Result<Shrub<Key, Value>, Error>
    public let context: Context
}

public protocol Encoded: Shrubbery where Key == String, Value: Codable {}
public typealias Coded = Shrub<String, Codable>

public typealias Flow<A> = AnyPublisher<Result<A, Error>, Never>

public typealias Fork<Key> = EitherType<Int, Key> where Key: Hashable
public typealias Route<Key> = [Fork<Key>] where Key: Hashable

public protocol Delta {
    associatedtype Key: Hashable
    func flow<A>(of: Key, as: A.Type) -> Flow<A>
}

public protocol Geyser {
    
    associatedtype Key: Hashable, Collection
    associatedtype Value
    
    typealias PrefixCount = Int
    
    func gush(of: Key) -> Flow<Value>
    func source(of: Key) -> AnyPublisher<PrefixCount, Error>
}

public class Pond<Source, Value>: Delta where Source: Geyser {
    
    public typealias Key = Source.Key
    public typealias Store = DeltaShrub<Key, Value>
    
    public let source: Source
    private var store: Store
    
    public init(
        source: Source,
        store: Store = .init()
    ) {
        self.source = source
        self.store = store
    }

    public func flow<A>(of: Key, as: A.Type) -> Flow<A> {
        fatalError()
    }
}
