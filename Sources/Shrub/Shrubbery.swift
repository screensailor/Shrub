import Peek

public protocol Shrubbery:
    AnyWrapper,
    ExpressibleByArrayLiteral,
    ExpressibleByDictionaryLiteral where Key: Hashable
{
    typealias Fork = EitherType<Int, Key> where Key: Hashable
    typealias Route = [Fork]

    func get(_ route: Route) throws -> Self
    
    mutating
    func set(_ route: Route, to: Any?) throws

    mutating
    func delete(_ route: Route)
}

// MARK: as

extension Shrubbery {
    
    public func cast<A>(to: A.Type = A.self) throws -> A {
        try self.as(A.self)
    }
        
    public func `as`<A>(_: A.Type) throws -> A {
        guard let a = unwrapped as? A ?? self as? A else {
            throw "Expected \(A.self) but got \(type(of: unwrapped))".error()
        }
        return a
    }
}

// MARK: subscript

extension Shrubbery {

    public subscript(_ route: Fork...) -> Self? {
        get { self[route] }
        set { self[route] = newValue }
    }

    public subscript<Route>(_ route: Route) -> Self?
    where
        Route: Collection,
        Route.Element == Fork
    {
        get {
            do {
                return try get(route)
            }
            catch {
                if #available(iOS 14.0, *) {
                    "\(error)".peek(as: .debug)
                }
            }
            return nil
        }
        set {
            do {
                try set(route.array, to: newValue)
            }
            catch {
                if #available(iOS 14.0, *) {
                    "\(error)".peek(as: .debug)
                }
            }
        }
    }
}

extension Shrubbery {

    public subscript<A>(_ route: Fork..., as _: A.Type = A.self) -> A? {
        get { self[route, as: A.self] }
        set { self[route, as: A.self] = newValue }
    }

    public subscript<A, Route>(_ route: Route, as _: A.Type = A.self) -> A?
    where
        Route: Collection,
        Route.Element == Fork
    {
        get {
            do {
                return try get(route.array, as: A.self)
            }
            catch {
                if #available(iOS 14.0, *) {
                    "\(error)".peek(as: .debug)
                }
            }
            return nil
        }
        set {
            do { try set(route.array, to: newValue) }
            catch {
                if #available(iOS 14.0, *) {
                    "\(error)".peek(as: .debug)
                }
            }
        }
    }
}

// MARK: get

extension Shrubbery {
    
    public func get<A>(_ route: Fork..., as: A.Type = A.self) throws -> A {
        try get(route.array).as(A.self)
    }
    
    public func get<A, Route>(_ route: Route, as: A.Type = A.self) throws -> A
    where
        Route: Collection,
        Route.Element == Fork
    {
        try get(route.array).as(A.self)
    }
}

// MARK: set

extension Shrubbery {

    public mutating func set<A>(_ route: Fork..., to value: A) throws {
        try set(route, to: value as Any?)
    }
    
    public mutating func set<A, Route>(_ route: Route, to value: A) throws
    where
        Route: Collection,
        Route.Element == Fork
    {
        try set(route.array, to: value as Any?)
    }
    
    public mutating func delete<Route>(_ route: Route)
    where
        Route: Collection,
        Route.Element == Fork
    {
        delete(route.array)
    }
}

// MARK: expresible

extension Shrubbery {

    public init(arrayLiteral elements: Value...) {
        self.init(elements)
    }
    
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(Dictionary(elements){ _, last in last })
    }
}

// MARK: lift

public prefix func ^ <S: Shrubbery>(array: [S]) -> S {
    S(array.map(\.unwrapped).ifNotEmpty)
}

public prefix func ^ <S: Shrubbery>(dictionary: [S.Key: S]) -> S {
    S(dictionary.mapValues(\.unwrapped).ifNotEmpty)
}

// MARK: peek

extension Shrubbery {
    
    public var description: String {
        String(describing: unwrapped ?? "nil")
    }
}
