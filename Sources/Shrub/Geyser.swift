public protocol Geyser {

    associatedtype Key: Hashable
    associatedtype Value

    typealias Fork = EitherType<Int, Key>
    typealias Route = [Fork]
    typealias EndIndex = Route.Index

    func gush(of: Route) -> Flow<Value>
    func source(of: Route) throws -> EndIndex // TODO:❗️-> AnyPublisher<EndIndex, Error>
}

public enum GeyserError<Route>: Error {
    case badRoute(route: Route, message: String)
}

