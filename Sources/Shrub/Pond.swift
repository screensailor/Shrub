import Dispatch // TODO:❗️generalise to Schedulers
/**
 * - unflow everything?, keep .flow() as just an operator?
 * - Datum<Key, Value, Context> instead of Result<Value, Error>
 * - events vs? streams - i.e. events as streams of () or of Event value?
 * - subscribing vs observing
 * - concurrent and serial dependencies - i.e. group vs sequence
 * - flat collections (path components) vs deep documents (values)
 * - decoder & encoder of ``Shrubbery`` (`as _: A.Type` tries a cast then decode where `A: Decodable`)
 */
public struct Datum<Key, Value, Context> where Key: Hashable {
    public let source: [EitherType<Int, Key>]
    public let result: Result<Shrub<Key, Value>, Error>
    public let context: Context
}

public protocol Encoded: Shrubbery where Key == String, Value: Codable {}
public typealias Coded = Shrub<String, Codable>

public typealias Flow<A> = AnyPublisher<Result<A, Error>, Never>

public protocol Delta {
    associatedtype Fork
    typealias Route = [Fork]
    func flow<A>(of: Route, as: A.Type) -> Flow<A>
}

public protocol Geyser: Delta {
    associatedtype Value
    func gush(of: Route) -> Flow<Value>
    func source(of: Route) throws -> Route.Index // TODO:❗️-> AnyPublisher<Route.Index, Error>
}

public enum GeyserError<Route>: Error {
    case badRoute(route: Route, message: String)
}

extension Geyser where Value: Shrubbery {
    
    public func flow<A>(of route: Route, as: A.Type) -> Flow<A> {
        gush(of: route).map{ o in Result{ try o.get().as(A.self) } }.eraseToAnyPublisher()
    }
}

public class Pond<Source, Key>: Delta
where
    Key: Hashable,
    Source: Geyser,
    Source.Fork == EitherType<Int, Key>
{
    public typealias Fork = Source.Fork
    public typealias Route = Source.Route
    public typealias Basin = DeltaShrub<Key, Source.Value>
    public typealias Subject = PassthroughSubject<Result<Basin, Error>, Never>
    
    public let geyser: Source
    
    private var basin: Basin
    private var bag: Set<AnyCancellable> = []
    
    private let queue: DispatchQueue
    private var subjects: Tree<Fork, Subject>

    public init(
        geyser: Source,
        basin: Basin = .init(),
        on queue: DispatchQueue = .init(
            label: "\(Pond<Source, Key>.self).q",
            qos: .userInteractive
        ),
        subjects: Tree<Fork, Subject> = .init()
    ) {
        self.geyser = geyser
        self.basin = basin
        self.queue = queue
        self.subjects = subjects
    }
    
    deinit { // TODO:❗️test 🗑
        print("✅ 🗑", Self.self, ObjectIdentifier(self))
    }

    public func flow<A>(of route: Route, as: A.Type) -> Flow<A> {
        
        let source: Route
        
        do {
            let endIndex = try geyser.source(of: route)
            guard endIndex >= route.startIndex else {
                return "Invalid end index of the source of route \(route)".error().flow()
            }
            source = route[..<endIndex].array.peek("✅ source")
        } catch {
            return error.flow()
        }
        
        geyser.gush(of: source).sink{ result in
            self.basin.set(source, to: result)
        }.store(in: &bag)
        
        return basin.flow(of: route)
    }
}
