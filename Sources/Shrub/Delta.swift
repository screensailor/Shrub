
extension Delta {
    
    public subscript<A>(of: Key, as _: A.Type = A.self) -> Flow<A> {
        self.stream(of: of, as: A.self)
    }
}

extension Delta where Key: RangeReplaceableCollection {
    
    public func stream<A>(of: Key.Element..., as: A.Type = A.self) -> Flow<A> {
        self.stream(of: Key(of), as: A.self)
    }
    
    public subscript<A>(of: Key.Element..., as _: A.Type = A.self) -> Flow<A> {
        self.stream(of: Key(of), as: A.self)
    }
}

