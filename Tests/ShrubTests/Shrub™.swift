@_exported import Hope
@_exported import Peek
@_exported import Shrub
@_exported import Combine

extension String: Error {}

class Shrub™: Hopes {
    
    func test_subscript() throws { 
        
        var o: JSON
            
        o = nil
        o = []
        o = [:]
        
        o[] = "👋"
        hope(o[]) == "👋"
        
        o["one"] = 1
        hope(o["one"]) == 1
        
        o["one", 2] = 2
        hope(o["one", 2]) == 2
        
        o["one", 3] = nil
        hope(o["one"]) == [nil, nil, 2] // did not append
        
        o["one", 2] = nil
        hope.true(isNilAfterFlattening(o["one"])) // none left
        
        o["one", "two"] = nil
        hope.true(isNilAfterFlattening(o["one", "two"]))
    }
    
    func test_expressible() throws {
        
        let o: JSON = ^[
            "one": ^[
                "two": [
                    3, 4, 5
                ]
            ],
            "and": ["so", "on", "..."]
        ]

        hope(o["and", 2]) == "..."
    }
}

extension Shrub™ {

    func test_ShrubAny_get() throws {

        var any: Any = 1
        try hope(JSON.get([], in: any) as? Int) == 1
        hope.throws(try JSON.get("one", in: any))

        any = ["one": 1]
        try hope(JSON.get("one", in: any) as? Int) == 1
        hope.throws(try JSON.get("two", in: any))

        any = ["one": ["two": ["three": 3]]]
        try hope(JSON.get("one", "two", "three", in: any) as? Int) == 3

        any = [any, any, any]
        try hope(JSON.get(1, "one", "two", "three", in: any) as? Int) == 3
    }

    func test_ShrubAny_set() throws {

        var any: Any? = 1
        try JSON.set([], in: &any, to: 2)
        hope(any as? Int) == 2

        any = ["one": 1]
        try JSON.set("two", in: &any, to: 2)
        try hope(JSON.get("two", in: any) as? Int) == 2

        any = [:]
        try JSON.set("one", "two", "three", in: &any, to: 3)
        try hope(JSON.get("one", "two", "three", in: any) as? Int) == 3

        any = 0
        try JSON.set(2, "three", 4, "five", in: &any, to: "😃")
        try hope(JSON.get(2, "three", 4, "five", in: any) as? String) == "😃"
    }
    
    func test_debugDescription() throws {
            
        let routes = testRoutes //testRoutesAndPrint()
        
        var json: JSON = nil
        
        var print = ""
            
        for i in 1...10 {
            for (j, route) in routes.enumerated() {
                try json.set(route, to: j)
            }
            if i == 1 {
                print = json.debugDescription
            } else {
                hope(json.debugDescription) == print
            }
            json = nil
        }
    }
    
    private func testRoutesAndPrint() -> [JSON.Route] {
        print("private let testRoutes: [JSON.Route] = [")
        let routes = (1...1000).map{ i -> JSON.Route in
            
            let route = JSON.Fork.randomRoute(
                in: Array(0...3),
                and: "qwwertyuiopasdfghjklzxcvbnm".map(String.init),
                bias: 0.1,
                length: 3...7
            )
            
            let r = route.map{ $0.intValue?.description ?? "\"\($0.stringValue)\"" }.joined(separator: ", ")
            
            print("\t[\(r)],")
            
            return route
        }
        print("]")
        return routes
    }
}

private let testRoutes: [JSON.Route] = [
    ["n", "u", "m", "r"],
    ["n", "r", "b", 2, 2],
    ["t", "h", "w"],
    ["w", 3, "c", "l", "f", "a"],
    ["q", "j", "w"],
    ["l", "e", 1, "h", "d", "d"],
    ["l", 3, "i", "d", 2, "g", "w"],
    ["l", "b", "v", "r", "a", "r"],
    ["a", 2, 2],
    ["w", "j", "k", "l", "l", "z", "a"],
    ["c", "t", "i", "u", "s", "h", "p"],
    ["d", 2, "n", "b", "x", "p"],
    ["x", "p", "d"],
    ["n", "b", "v", "m", "g", "r"],
    ["w", "r", "w", 2, 2, "l", "k"],
    ["u", "e", "y", "l", "s", "r"],
    ["x", "e", "h", "o", "k", "j", "w"],
    ["p", "c", "y", "o", "o", "m", "w"],
    [0, "d", "g", "y", "d", "f"],
    ["m", "m", "l", "t"],
    ["h", "f", "d", "i"],
    ["c", "n", "r", "r", "m"],
    ["y", "j", 1, "h", "p"],
    ["z", "p", "q", "f", "p", "w"],
    [2, "x", "d"],
    [3, "h", "k", "a", "y", "g", "t"],
    ["e", "g", "k"],
    ["l", "q", "j", 0, "y"],
    ["w", "g", "v", "s"],
    ["s", "g", "k", "b", "a", "b", "h"],
    ["n", "p", "w"],
    ["o", "f", "f", 3, "b"],
    ["l", "b", "i", "q"],
    ["t", "l", "t", 1, "f", "k", "y"],
    ["h", 2, "t", "k", "m", "c", 1],
    ["c", "j", "u", "i"],
    ["c", "s", "r", "m", "p", 1],
    ["a", "m", "h", "m"],
    [0, 2, "w"],
    ["m", "o", "l", 3],
    ["w", "o", "l", "y"],
    ["w", "l", "c", "t", "n"],
    ["z", "e", 3, "n", "q", "h"],
    ["z", "q", "e"],
    ["l", "y", "j", "x", "f", "w", "u"],
    ["q", "o", "i", "t"],
    ["w", "n", 2, "s", "p", "h"],
    ["s", "z", "z", "b", "w", "h"],
    ["s", "h", "j"],
    ["f", "z", "c"],
    ["s", "w", "w", "v"],
    ["m", "b", "a", "e", "m"],
    ["h", "w", "c", "w", 1, "q"],
    ["w", "w", "f", 3],
    ["v", 0, "j", "o", "o", "q", "t"],
    ["m", "t", "l", "b", "x", "y"],
    ["w", "f", "u", "n", "t", "o", "p"],
    ["n", "f", "p"],
    ["l", "o", "h", "i", "v"],
    [1, "p", "y", "m", "t", "x", "w"],
    ["t", "c", "f", 0],
    ["h", "w", "a", "u"],
    ["g", "v", "d", "d", "s", "s"],
    ["f", 0, "c", "e", "i", 1],
    ["d", "f", "v", "j", "u", "j", "x"],
    ["k", "s", "b", "a"],
    ["j", "n", 0, "s", "a", "y", "m"],
    ["o", "f", "h", "q"],
    ["h", "f", "q"],
    ["t", "k", "q"],
    ["x", "u", 3, "u"],
    ["a", "x", "e", "w", "j", "g", "u"],
    ["x", "l", "c", "p", "v"],
    [2, 2, "a", "u"],
    ["w", "r", "l", "c", "b"],
    ["e", "w", "b", "i"],
    ["c", "z", "k", "z", "w", "m"],
    ["m", "s", "r", "p", "q"],
    ["i", "c", "b", "x", "e", "f", "k"],
    ["b", "h", "w", "z", "i", "t", 1],
    ["b", "j", "w", "w", "k", "g", "o"],
    ["q", "o", "w", "b", "e"],
    ["z", "v", "d", "x", "z", "u"],
    ["v", "h", "i", "x"],
    ["k", "f", "n", "o", 1, "m"],
    [3, "o", "k", "x"],
    ["v", "q", "e"],
    ["u", "i", 3, "n"],
    ["m", "x", "c", "q", "m", "y"],
    ["j", "j", "n", 0, "j"],
    ["y", "m", "u", "u", "k", "p"],
    ["z", 2, "x"],
    ["j", "h", "m", "c"],
    ["b", "n", "n", "h"],
    ["a", "o", "a", "j"],
    ["e", "i", "f"],
    ["a", "x", "i", "t"],
    ["l", "m", "u", "k", "x", "j"],
    ["v", "r", "x", "z", "i"],
    ["o", "t", 1, "u", "c"],
    ["s", "h", "h", "s"],
    ["o", "y", "j"],
    ["q", "v", "d", "l", "t", "f", "l"],
    ["q", "q", "y", "t", 2, "n"],
    ["m", "u", "d"],
    ["k", "c", "m", "o", "i", "j", "b"],
    ["j", "b", "a", "f", "w", "r"],
    [1, 3, "v", "g", "w", "v"],
    ["o", "z", "w", "m", "n", "n", "h"],
    ["f", "g", "y", "m", "d"],
    ["l", "i", "l", 3, "r", "l"],
    ["n", "e", 0, "o", "b", "b"],
    ["r", "o", "o", "o", "z", 1],
    ["w", "s", "o", "f", "d", "n"],
    ["k", "b", "v", "t"],
    ["j", "u", "s", "s", 0],
    ["w", "n", "i", "p", "i"],
    ["e", "b", "k"],
    ["w", "t", "w", "c"],
    ["z", "t", "i", "x", "h", "k"],
    ["e", "k", "t"],
    ["y", "r", "u"],
    ["l", 3, "r", "t", "q"],
    [1, "d", "s"],
    ["m", 3, "s"],
    ["r", "j", "n", "h", "j", "y", "u"],
    ["n", "w", 2],
    ["t", "d", "s"],
    ["y", "r", "e", "x"],
    [1, "w", "z", "w"],
    [3, "e", "w", 2, "z", 3, "d"],
    ["m", "q", "o", "s", 2],
    ["j", "y", "g", "x", "b", "b"],
    ["t", "v", "n", "x", "x"],
    ["l", "g", "q", "g", "l"],
    ["z", 0, 0, 1, 3],
    ["n", "u", "a", "t", "l", "p"],
    ["r", "p", "b", "d"],
    ["n", "m", "d", "q"],
    ["w", "s", "l"],
    ["g", "b", "e", 2, "w", "p", "k"],
    ["d", "h", "a"],
    ["l", "f", "i", "w", "t", "q"],
    ["z", 3, "h", "c", "s", "q"],
    ["k", "p", "u"],
    ["f", "c", "c", "a", "m", "t"],
    ["u", 3, "d"],
    ["q", 1, "a", "a"],
    ["v", "i", "o", "d", "h"],
    ["h", "y", "m", "s", "n", "f", "u"],
    ["m", "t", "g"],
    ["t", "h", "b", "p", 0, "h", 1],
    ["b", 0, 3, "j", "e", 3, "c"],
    ["b", 1, "w", "g", "m"],
    ["u", "g", "m", "v"],
    ["u", "z", "v", "d", "z", "f", 2],
    ["c", "d", "n", "m", "e", "s"],
    ["y", "w", "b", "v", "g", "u", "h"],
    ["q", "v", "c", "j", "t", "j"],
    ["l", "i", "v"],
    ["v", "s", "z", "b"],
    ["p", "w", "v", 1, "r"],
    ["u", 1, "y", "v", "c", "m"],
    ["e", "p", "g"],
    ["k", "l", "p", "q", "f", "u", "i"],
    ["g", "w", "e", "z", "n", "j", "f"],
    ["k", "z", "o", "v", "d", "g", "e"],
    ["u", "c", "w", "a", "c"],
    ["b", "i", "p"],
    ["v", "w", "p", "p", "u", "m", "p"],
    ["j", "u", "w", "x", "x", "z"],
    ["q", "t", "l", "k", "s", "u"],
    ["v", "x", "z", "f", "n"],
    ["h", "g", "y", "f", "y", "q", "v"],
    ["o", "c", "e", "t"],
    ["n", "n", "x", 2],
    ["f", "s", "y", "w", 2],
    ["k", "y", "w", "a", "e", "t", "b"],
    ["r", "w", "d", "r", 1, "d", "e"],
    ["q", "v", "i", "x"],
    ["x", "y", "s"],
    ["s", "r", "d", "i"],
    ["m", "g", "e", "v", "g"],
    ["g", "z", "i", "f"],
    ["h", "t", "b", "w", "m", "x", "h"],
    ["v", "f", 1, "f", "x"],
    ["r", "j", "y"],
    [3, 0, "r", 0, "x", "z", "t"],
    ["t", "w", "o", "u", "f", "q"],
    ["n", "j", "g"],
    ["a", "t", "b", "r", "y", "h"],
    [3, "o", "u", "m", 2],
    ["h", "k", "w", "b", 2],
    ["g", "p", "d", "v", "z"],
    ["w", "g", "a", "z", "m", "v"],
    ["w", "b", "w", "c"],
    ["h", "m", "u", "g", 1, "w", "w"],
    ["z", "v", "b"],
    ["j", "h", 1, "w"],
    ["s", "y", "x", "y", "p", "w", "m"],
    ["l", "k", "b"],
    ["i", "w", "i", "s"],
    ["o", "w", "h"],
    ["z", "r", "y", 3, "p"],
    ["r", "w", "c"],
    ["p", "l", "r"],
    ["c", "j", "m", "d"],
    ["t", "z", "m"],
    ["e", "c", "z", "s", "r"],
    ["z", "v", "f"],
    ["q", "j", "h", "d"],
    ["l", "g", "s"],
    ["z", "t", "u", "p"],
    ["t", 1, 2, "p", "i", 1, "e"],
    [1, "e", "g", "d", "y"],
    ["m", "s", "a"],
    ["e", "c", "c"],
    ["b", "q", "w", "i"],
    [0, "r", "r", "z"],
    ["g", "l", "r", "y", "b", "f", 3],
    ["t", "k", "e", "r"],
    ["a", "i", "x"],
    ["l", "w", 2, "w"],
    ["a", "c", 1],
    ["d", "d", "c"],
    [3, "z", "z", "h", "w"],
    [0, "n", "u", "c", "k"],
    ["a", "r", 0, "w"],
    ["m", "e", 2, "l", "m", "y"],
    ["e", "d", 2, "q", 3, "x", "t"],
    ["n", "c", "s"],
    ["o", "k", "a", "k", "x", "v"],
    ["s", "a", 1, "u"],
    ["p", "u", "l", "b", "w", "i", "g"],
    ["o", "a", "q", "z"],
    ["g", "o", "w", "w", "x", "i", "v"],
    ["k", "s", "g", "k", "v"],
    ["v", "o", 2, "u"],
    [3, "y", 0, "y"],
    [3, "b", "w", "l", "z"],
    ["o", 3, "a", "d"],
    ["z", "f", "d", "v", "t", "y", "p"],
    ["x", "n", "f"],
    ["w", "w", "v", 3],
    ["z", "e", "h", 3],
    ["p", "z", "q"],
    [2, "j", "q", "p", 2, "a", "j"],
    ["o", "s", "w", "b", "t", "b", "h"],
    ["o", "r", "t", "b"],
    ["w", "b", "c", "l"],
    ["v", 3, "d", "k", "l"],
    ["u", "l", "g", "h", "i", 3, "g"],
    ["h", "z", "c"],
    ["h", "t", 1, "h", 2, "x", "w"],
    ["o", "e", "c", 0, "j", "z"],
    ["c", "w", "j", "v"],
    ["e", "o", "g", "q", "s"],
    ["u", "c", "p"],
    ["y", "e", 1, 3, "p"],
    ["a", "j", "u", "m", "r"],
    ["x", "h", "e", "d", "l", "t"],
    ["e", 2, "d", "p"],
    ["r", "w", "q", "y", 3, "f"],
    ["x", "x", "h", "b", "r", "h"],
    ["g", "r", "c", "e", "g", "h"],
    ["m", "u", "m", "v", "w", "i", "o"],
    ["w", "b", "j", "u", "i", "u", 2],
    ["w", "i", "x", "a"],
    ["q", "f", 3],
    [1, "y", "l"],
    ["x", "v", 0, "y"],
    [2, "x", "n", "p", "e"],
    [2, "u", "l", "c", "z"],
    ["d", "t", "w", "e", "u", "m"],
    ["c", "p", "u", "x", "o", "i"],
    ["x", 1, "k"],
    ["v", 0, "h", "h", "q"],
    ["r", "z", "w", "f", "g", 3],
    ["u", "t", "y"],
    ["d", "i", "t", "t", "b", "m", "l"],
    ["t", "w", "b", "q", "v", "e", "q"],
    ["j", "z", "b", "j", "w"],
    [1, "u", "e", "v", "d", "w"],
    ["o", "y", "t", "c"],
    ["n", "y", "r", "k"],
    ["s", 3, "v", "h", 3, "v"],
    ["v", "v", "t", "z", "q", "o"],
    ["y", "d", "k", "m"],
    ["r", "a", "z", "w", "q"],
    [2, "d", "r", "r", "b", "k", "g"],
    ["d", "z", "s", "t", "g", "p", "u"],
    ["b", "p", "w", 0, "i"],
    ["k", "j", "l"],
    ["f", "f", "k", "x", "t", 3, "d"],
    ["u", "s", "c", "h"],
    ["a", "n", "h"],
    ["i", "p", "l", "a", "w"],
    ["o", "p", "v", "r", "r", "r", "y"],
    ["c", "g", "h"],
    ["i", "v", "t", "t", "j", "g"],
    ["n", "d", "b"],
    ["x", "o", "l"],
    ["y", "a", "b", "g"],
    ["w", 3, "u"],
    ["m", "o", "e", "u", "p", "u", "j"],
    ["m", "u", "s", "j", "j", "a"],
    ["q", "h", "m", "z", "z", "a"],
    ["z", "n", "c", "e", "v"],
    ["s", "r", "x", 2],
    ["m", "d", "d", "x", "a", "o"],
    ["k", "d", "e", "l"],
    ["b", "w", "t", "q", "w", "c"],
    ["z", "r", "o", "a"],
    ["k", "n", 3, "m", "i", "q", "i"],
    ["y", "n", "t", "h", "t", "a", "l"],
    [3, "u", "f", "g"],
    ["m", "t", "c", "v"],
    ["u", "w", "a", "v", "l"],
    ["d", "n", "c", "d", 1, "f"],
    ["c", "d", "r", "h", "c", "q"],
    ["j", "j", 1],
    ["r", "s", "t", "g", "l", "a"],
    ["n", "g", "p", "g", 1, "r"],
    ["j", "f", "d", "v", "n", "b"],
    ["a", "v", "t", "g", "f", 3],
    ["o", "r", "l", "i", "p", "p"],
    ["f", "p", "n"],
    ["l", "j", "y", "c", "n", "y", "u"],
    ["p", "n", "u", "g", "b", "h"],
    ["k", "n", "w"],
    ["u", "e", "k", "y"],
    ["x", "a", "c", "w", "x"],
    ["z", "k", 3, "x"],
    ["n", "d", "i", "c", "e"],
    ["y", "i", 1, "m"],
    ["q", "s", "q", "t", "z", "w", "a"],
    ["w", "v", "t", "w", "d", "y"],
    ["p", "s", "f", "d"],
    ["m", "o", "b", "i", "f", "f"],
    ["x", "s", "h", "f", "g"],
    [0, "r", 3, "j", "c", "u"],
    ["w", "g", "q", "v"],
    ["v", 3, "u", "s", "p", "t"],
    ["s", "z", 2],
    ["t", "h", "h"],
    ["q", "u", "r", "w"],
    ["x", "y", "d", "r", "h", "q"],
    ["g", "e", "c", "e", "b", 3],
    ["g", 0, "s", "p"],
    ["j", "y", "k", "m", "c"],
    ["v", "p", "k", "u", 3],
    ["c", "w", "j"],
    ["a", "c", "z"],
    [3, "w", "e", "j", "r"],
    ["l", "h", 2],
    ["r", "d", "d", "l", "t", "u", 1],
    ["s", "g", "g", "f"],
    ["z", "o", "b"],
    ["v", "f", "r", 3, "n", "v"],
    ["n", "c", "v"],
    ["c", "s", "x", "u"],
    ["y", "z", "m", "x"],
    ["x", 0, 3, "u"],
    ["u", 0, 0, "y", "y", "y", "n"],
    ["d", "n", "h", "s", "p"],
    ["s", 2, "d", "v", "s", 2, "k"],
    ["x", "j", "t", "t", "p"],
    ["t", "q", "u", "j", "w"],
    ["s", "w", "s", "z", "t"],
    ["d", "p", "f", "q", 3, "d"],
    ["u", "y", 1, "m"],
    [3, "r", "q"],
    ["o", "x", "d", "c", "p"],
    ["o", "q", 0, "p", "h", "b"],
    ["p", "u", "v", "e", "v", "j", "w"],
    ["y", "u", "m", "t", "i", "u"],
    ["g", "z", "s", "x", 1],
    ["a", 1, "m", "o"],
    ["w", "t", "l", "z", "i", "u"],
    ["p", "t", "o", 1, "q", "y"],
    ["g", "d", "d"],
    ["d", "m", 1, "a", "s"],
    ["w", "h", "o", "e", "b", "r", "k"],
    ["m", "b", "b"],
    ["q", "b", "x", "a", "u"],
    ["w", "n", "a", "c", 0, "e"],
    ["y", "e", "o", "n"],
    ["t", "v", "m", "n", "c", "q", "q"],
    ["z", "w", "s", "h"],
    ["l", "f", 1, "g", "j", "r", "b"],
    ["w", "x", "t", "r", "b"],
    [0, "j", "k", "c", 2],
    ["p", "d", "d"],
    ["n", "j", "z", "y"],
    ["l", "h", "s"],
    ["t", "o", "z", "a", "t", "m"],
    ["h", "p", "v", "h", "p"],
    ["w", "l", "d", "y", 0, "c", "a"],
    ["k", "a", "t", "q", "v", "w"],
    ["p", "w", "g"],
    ["k", "a", "d", "z", "h", "a"],
    ["f", "a", "q", "e"],
    ["w", "n", "s", "y", "k", "m", "w"],
    ["y", "j", "q", "w"],
    ["g", "x", "h", "j"],
    ["a", "q", "v", "d"],
    ["k", "m", "b"],
    ["q", "q", "h", "t", "t", "i"],
    ["r", 0, "j"],
    ["f", "y", "o", "v"],
    ["i", 1, "u", "u", "a"],
    ["o", "a", "a", "o", "m"],
    ["y", "x", "v", "e", "q"],
    ["l", "v", "v", "z", "y"],
    ["u", "b", "s"],
    ["l", "l", "o"],
    ["e", "b", "j", "b"],
    ["y", "z", "l", 2, "o", "w", "a"],
    ["k", "o", "q", "h", "s", "w"],
    ["w", 0, "r", "y", "m"],
    ["w", 0, "w", "y"],
    ["k", "w", "m", "r", "h"],
    ["i", "q", "g"],
    ["r", "k", "e", "y", "i", "c"],
    ["z", "s", "r", "e", "p", "q"],
    ["a", "b", 1],
    ["c", "r", "o", "a", "h"],
    ["f", "g", "v", "r", "p", "w", "g"],
    ["r", "b", "k", "o"],
    ["b", "b", "j", "l", "k", "n", "o"],
    ["h", "i", "v", "h", 3, "y", "b"],
    ["e", "y", "a", "v"],
    [2, "u", "w", 0, "m"],
    ["y", "m", "a"],
    ["f", "j", "s", "w", "i", "s"],
    ["d", "f", "i", 3],
    [3, "f", "c"],
    ["a", "u", "j", "w", "t", "w", "n"],
    ["s", "u", "h", "e", "y"],
    ["w", "u", "m", "x"],
    ["o", "r", "e", "h"],
    ["f", 1, "a"],
    [3, "q", "q"],
    ["t", "a", 0, 3, "i", "g", "o"],
    ["a", 2, "k", "d", "l", "m"],
    ["s", "i", "l"],
    ["v", "q", "t", "s"],
    ["b", "p", "g"],
    ["a", "f", "q"],
    ["k", "d", "t", "b", "p"],
    [2, "g", "t", "a"],
    [3, 2, "n", "h", "j"],
    ["u", "u", 1, "q", "d"],
    ["j", "k", "u"],
    ["g", "d", "x", "y", 1],
    ["l", "d", "d", "z", "n", "m"],
    ["n", 0, "e", "v", "s", 2, "l"],
    ["p", "s", "a", "m", "v"],
    ["d", "u", "q"],
    ["y", "w", "i", "v", "d"],
    ["d", "k", "f", "c", "c"],
    ["y", 3, "l"],
    [1, "j", "f", "w", "q", "k"],
    ["t", "w", "w", "f", "t", "k"],
    ["o", "m", "t", "g"],
    ["j", "x", "d"],
    [3, "j", 3, 0, "s", "b"],
    ["e", "y", "j"],
    [3, 3, "m", "s", "t", "v"],
    ["l", "t", "z", "n"],
    ["n", "o", "f", 3, "v"],
    ["v", 1, "q", "t", "i", "s"],
    ["s", "p", "s", "f", 3, "u", 3],
    ["k", "q", 3],
    [3, "h", "b", "x"],
    ["c", "u", "p", "t", "n", "k"],
    ["r", "k", "p", "l", "m", "t", "z"],
    ["w", "p", "m", "l", "v"],
    [0, "h", 1, "x", "t", "k"],
    ["u", "y", "y"],
    ["x", "h", "z", "a"],
    ["i", 1, 1, "o", "l"],
    ["b", "s", 3, "u", "t", "p", "o"],
    ["b", "e", "n"],
    ["j", "a", "n", "o", "h"],
    [3, "w", "u"],
    ["w", "f", "k", "v", "p", "w"],
    ["h", "z", "p", "h", "b"],
    ["s", "u", "s", "w", "h", "k", "a"],
    ["v", "t", "j", "c"],
    ["o", "m", 2, "w", 2, "k"],
    ["t", "z", "e", "t"],
    ["w", "j", "d", "v", "l", 2, "q"],
    ["w", "x", "e", "o"],
    ["z", "d", "i", "j", "c", "c", "f"],
    [0, 2, "n"],
    ["d", "z", "y", "i", "y", "s"],
    ["a", "v", "v", "k", "a"],
    ["h", "n", "o", "z"],
    ["v", "n", "t", "q", "c", "o"],
    ["f", "f", "m"],
    ["j", "u", "m"],
    ["x", "r", "t", "z", "w"],
    ["u", "t", "d", "n", "v", "u", "d"],
    ["r", "b", "g", "l", "x", "r"],
    ["s", "w", "f", 3, "w", "t", "n"],
    ["t", "h", "r", "y", "n"],
    ["w", "j", "d"],
    ["u", "v", "m", 1, 3, "t", "i"],
    ["e", "i", 2, "j"],
    ["d", "p", "h", 3, "y", "w", "o"],
    [3, "p", "i"],
    [1, "e", "x", "p", "w"],
    ["z", "g", "y", "p", "d", "r"],
    ["d", "d", "n"],
    ["n", "j", "f", "w", "v", "k"],
    ["v", "n", "y", "s", "z"],
    ["r", "j", "b", "f", "z"],
    ["p", "c", 3],
    ["g", "l", "o", "o", "m", "z", "z"],
    [3, "j", "b", "k", "x"],
    ["v", "o", "t"],
    ["o", "o", "b", "w", "h"],
    ["s", "e", 1, "r", "m", "x", "i"],
    ["n", "m", "s"],
    ["s", "b", 1],
    ["j", "z", "b", "h"],
    ["w", "j", "g", "g", "d"],
    ["o", "w", 1],
    ["h", "c", "d"],
    ["b", "e", 3, "y"],
    [2, "z", 1, "l", "p", "e"],
    [0, "f", "e", "r", "e", "w"],
    ["g", "x", "g", "w", "m"],
    ["n", "u", "w"],
    ["b", "o", "a", "i"],
    ["p", "x", "m", "y", "k", "a", "z"],
    ["v", "k", "s", "s", "e", "l", "m"],
    ["h", "f", "z"],
    ["v", "l", 3],
    ["b", "i", "v", "g", "o", "l"],
    ["c", "s", "b", "m"],
    [2, "p", "p", "d", "o"],
    ["u", "w", "r", 3, "p", "g", "o"],
    ["j", "p", "c", "a", 3, "s"],
    ["o", "w", "o", "h", "u", "b", "g"],
    ["x", "g", "z", "i", "b", "r"],
    ["w", "g", "c", "t", "z", "u"],
    ["h", 3, "l", "v", "j", "a"],
    ["z", "z", "r", "k", "r", "o", "y"],
    ["z", "k", "y", "f", 3, "m"],
    ["o", "g", "f", "f", "x"],
    ["i", "z", "x", "e", "d"],
    [1, "t", "v", "e", "c", "r", "k"],
    ["y", "y", "t", 0, "s", 0, "m"],
    [0, "h", "u", "e", "h", "t"],
    ["o", "m", "h", "v", "z", "p", "q"],
    ["w", "n", "p", "d", "k", "l", "f"],
    ["p", "k", "l", 2],
    ["r", "c", "i", "i", "y", 1],
    ["j", "a", "u", "w", "y"],
    ["o", "z", "z", "s", "x", "k"],
    ["q", "d", 3, "z", "i", "g"],
    ["f", "v", "a", "w", "d", "w"],
    ["p", "h", "x"],
    ["z", "y", "h", "m", "r", "w"],
    ["g", "p", 2, "h", 0, "l"],
    [0, "w", "l", "o"],
    ["c", "v", "v", "s"],
    ["q", "z", "u", "p", 2, "l", "q"],
    ["s", "z", "l", "f"],
    ["n", "u", "p"],
    [1, "d", "w", "s", 3],
    ["s", "v", "u", "c", 2, "y"],
    ["j", "y", "h", "f"],
    ["p", "i", "a", "m", "w", 3, "v"],
    ["n", "w", "d", "e"],
    ["m", "t", "q"],
    ["r", "x", "c", "x", "x", "w"],
    ["b", "d", "u", 1, "l", "l", "q"],
    ["f", "p", "r", "o", "u", "v", 0],
    ["l", 2, "e", "n", "m", "e"],
    ["c", "x", 2, "k", "z", "v"],
    ["b", "z", "j"],
    ["t", "c", "d"],
    [2, "m", "d", "a", "e", "x", "g"],
    ["s", 0, "w", 1, "s", "s", 1],
    ["i", "o", "p", "x", "j", "z", "q"],
    ["x", "u", 1, "t", "b", "i"],
    [2, "h", "h", "p", "b"],
    ["f", "w", "z", 1, "h"],
    ["w", "n", "p", "d", "e", "o", "e"],
    ["k", "i", "g", "v", "s", "d", "p"],
    [2, "u", "c"],
    [1, "j", "v", "c", "w", "k"],
    [0, "v", "h", "s"],
    ["l", "e", "r", 2, 0],
    ["n", 0, "l", "i", "g", "t"],
    ["z", "d", "q", "q", "f", "i", "x"],
    ["r", 3, "o", "v", "o"],
    ["t", "w", "e", "w", 0, "e"],
    ["m", 2, "m"],
    ["a", "n", "a", "f", "r", "q"],
    ["e", "d", "x", "a"],
    ["e", "y", "g", "n"],
    ["u", "j", "x"],
    [2, "c", "c", "s", "u", 3],
    ["r", "k", "p", "g"],
    ["u", "b", "w", "v", "t", 2, "y"],
    ["y", "o", 2, "a", "z", "f", 2],
    ["l", 2, "e", "v"],
    ["c", "a", "a", "w", "z"],
    ["u", "w", "w", "g"],
    [0, "k", "k"],
    ["n", "z", "c", "s"],
    ["j", "m", 3, 1],
    ["g", "a", "n", "r", "w", "u", "y"],
    ["n", "a", "m", "f", "a", "i", "i"],
    ["n", "g", "c", "a", "i", "z", "f"],
    ["n", "g", "b", "r", "x"],
    ["c", "d", "a"],
    ["p", "j", "r", "d", 1],
    ["u", "g", "w", "z", 3, "u", "u"],
    ["s", "b", "m", 1, 0, "w", "y"],
    ["l", "d", "h", "i", "d", "z", "j"],
    ["g", "x", "o", "o", "i", "y"],
    ["s", "f", "z", 3, "w", "o", "d"],
    [1, "t", "x", "a", "b"],
    ["x", "d", 2, "z"],
    ["h", "q", "s", "g", "o"],
    ["v", "n", "t", "p", "p"],
    ["d", 1, "l", "n"],
    ["e", "w", "d"],
    [0, "a", "t", "m", "d"],
    ["l", 3, "d"],
    ["w", 1, "t", "o", "n", "b"],
    ["c", "f", "n", "g", "k", "w"],
    ["s", "v", 1, "y", "d", "w", 0],
    ["z", "m", "g"],
    ["y", "p", "p", "n", "m", "l"],
    ["p", "k", "k", "q", "t", "f", 2],
    [1, "p", "s"],
    ["i", "h", "h", 0, "r", "w", "o"],
    ["h", "l", "m"],
    ["r", "v", "i", "g"],
    ["w", "m", "c", "x", "u", "o", "m"],
    ["d", "y", "o", "p", 0],
    ["n", "r", "p", "m", "n", "z", "b"],
    ["s", "y", "d"],
    [2, "m", "r", 3, "s", "j"],
    ["c", "x", "g", "g", "z"],
    ["w", "q", "z", "p", 0, "t"],
    ["y", "t", "q", "f", "z", "q", "n"],
    ["q", 0, 0, "b", "p", "f"],
    ["p", "q", "s", "r"],
    ["y", "a", "l", "b", "g", "c"],
    ["w", "k", "q", "a", "z", 1, "b"],
    ["a", "l", 2, "k", "n"],
    [3, 0, "t", "c", 1, "x"],
    ["c", "r", "w"],
    ["o", "d", "p", "q", 0, "l"],
    ["m", "f", "n", 2],
    ["o", "w", "z", "x", "a"],
    ["g", "l", "j", "p", "n", "b", "n"],
    ["z", "q", "m", "w", "p", "y", "e"],
    ["p", "p", "d", "k"],
    ["l", "y", "s", "t", "g", "a", 0],
    ["n", "q", "b", "s", "r", "i", "h"],
    ["r", "g", 0, "w", "h", "i", "j"],
    [2, 3, 0, 0, "n"],
    ["u", "u", "i", "n", "k", "s", "w"],
    ["m", "q", "k", "t", "v", "q", 1],
    ["k", "p", "d"],
    ["y", "d", "c", "r"],
    ["z", 0, "w", 0, "i", "f", "q"],
    ["u", "g", "o", "e", "c", "z", "n"],
    ["y", "j", "h", "f", "f"],
    ["k", "j", 3, "w"],
    ["p", 2, "l", "h"],
    ["m", "c", "a", 1, "e", "d"],
    [0, "o", "p", "r"],
    [0, 1, "w", "h"],
    ["l", "i", "k", "s"],
    [3, "l", "n", "u", "i", "t"],
    ["w", "p", "a"],
    ["y", "n", "p", "u"],
    ["k", "g", "m", "l", "d"],
    ["p", 3, "s", "e", "h"],
    ["s", "t", "s", 0, "n"],
    ["r", "n", "r", "v", 2, "w"],
    [3, "b", "j"],
    ["m", "v", "n", "x", "g", "m"],
    ["l", "e", "l", "u", 0, "l", 0],
    ["a", "r", "n"],
    ["k", "h", "l", "m", "w", "m", "w"],
    ["b", "a", "m", 3, "g"],
    ["s", "h", "r", "p"],
    ["x", "j", "t", "r"],
    ["x", "p", "o", "i", "a", "n"],
    ["r", "q", "d", "p", "g", 1],
    ["k", "v", "e", 0, "x", "t", "h"],
    ["d", "x", "a", "f", "t", "t"],
    ["l", "s", "w", "y", "j", 3],
    ["k", "o", "o", "o", "s"],
    ["r", "x", "r", "e", "q", "w"],
    ["u", "e", "x", "k"],
    ["n", 3, "u", "v", "w", "f"],
    ["v", "f", "a"],
    ["z", "y", "o", "d"],
    ["j", "a", "h", "h", "k", "y"],
    ["k", "h", "x", 0, "s", "h"],
    ["w", "g", "q", "u", "j", "g"],
    ["t", "k", "p", "c"],
    ["q", "v", "w", "u", "p", "s", "u"],
    ["d", "b", "k", "q"],
    ["v", 3, "w", "p", "j", "s", "h"],
    ["f", "q", "o"],
    ["d", "b", "w", 2],
    ["p", 3, "p", "k", 3, "g"],
    ["h", "a", "i", "y"],
    ["s", "f", "k", 0, "w", "y", "r"],
    ["g", "f", "v", "u", 3, "y", "c"],
    ["d", "z", "t", "u", "c"],
    ["g", 1, "r", "d"],
    ["z", "b", "b"],
    ["r", "f", "m", "r"],
    ["m", 0, "n", "a", "g", "r"],
    ["j", 0, "s", "h", "j", 0],
    ["j", 3, "p", "k"],
    ["k", "a", "l", "k", "e"],
    ["g", "w", "f", "c", "t", "l", "j"],
    ["y", "j", "p", "j", 0, "l"],
    ["e", "h", "u"],
    ["g", "s", "w", "u"],
    ["a", "q", "b", "x", "u", "r", "n"],
    ["f", "o", "j"],
    ["p", "k", 2],
    ["j", 3, "a"],
    ["u", 3, "x"],
    ["l", 3, "f", "a", "k", "j", "t"],
    ["g", "q", "w", 0],
    ["b", "p", "e", "c", "j", "e"],
    ["l", "n", "t", "n"],
    ["t", "q", "q", "g", "p", "l", "d"],
    ["a", "w", "m", "c", "k", "u", "h"],
    ["v", "h", "k"],
    ["n", "z", "e"],
    ["f", "i", "s", "r", "a", "q", "u"],
    ["r", "q", "n", 0],
    ["w", "i", "m", "q", "m"],
    ["u", "e", "g", "o", "d", "p", "f"],
    ["z", "x", "n"],
    ["k", "q", "m", "w", "w", 1],
    ["j", "m", "n", "h", "v", "a", "i"],
    ["b", "t", "k", "m"],
    ["b", 2, "r", "d", "v"],
    ["p", "i", "l", "p"],
    ["i", "p", "c", "u"],
    ["s", "g", "m", "l"],
    [0, "f", "z", "x"],
    ["n", "r", "t", "w", "h", "y", "j"],
    ["y", "r", "p", "y", "d", "v"],
    ["w", "a", "i", "r"],
    ["j", "t", "n", "g", "u", "o", "r"],
    [1, "y", "f", "k", "c"],
    ["x", "t", "r", "d", 3, "k", 0],
    ["f", "i", "z", "d", "c", "t", 3],
    ["j", "q", 3],
    ["u", "r", "m"],
    ["q", "f", "n", "j", "y"],
    ["f", "m", "t", "t"],
    ["y", "e", "a", 3, "u"],
    ["x", "i", "w", "w", "h"],
    ["w", "p", "h", "k"],
    ["o", "w", "t", "q", "w", 0],
    ["f", "r", "k", "u", "w", "u"],
    ["u", "u", "x", "x", "o", 1, "s"],
    ["a", 0, "m"],
    ["u", "u", "w", "g", "l", "v", "z"],
    ["i", "h", 1, "y", "h", "b"],
    ["b", "i", "y", 2, "h"],
    ["y", "i", "t", "i", "a"],
    [0, "f", "x", "w", "o"],
    ["x", "n", "g"],
    ["x", "v", "b", "q"],
    ["z", "l", 2, "o", "b", "y"],
    [1, "x", "y", "j", "o"],
    ["b", "n", "d", "g"],
    ["t", "k", "g"],
    ["o", 0, "g", "x"],
    ["g", 2, "o", "h", "l"],
    ["a", "c", "g"],
    ["u", "m", "c", "x", "t", "x", "d"],
    ["m", "g", "s", "g", "k", "v"],
    ["t", "q", "g", "b", "k"],
    ["l", "g", "j"],
    ["p", "y", "x", "c", "h"],
    ["v", "i", 1, "z", "e", "i"],
    [1, "y", "i"],
    ["h", "g", "g", "o", "w", "x", "m"],
    ["l", 0, "m", "h", "e", "z"],
    ["l", "u", "z", "j", 1],
    [1, "s", "b", "l"],
    ["q", "i", "r", "r", "g", "z", "n"],
    ["n", "a", "w", "f"],
    ["g", "i", "g", "b", "w"],
    ["q", "s", "d", "h", "c"],
    ["p", "c", "i"],
    ["b", "c", "u"],
    [0, "h", "i", "d", "h", "e"],
    ["w", 0, "j", "j"],
    ["i", "n", "p", "f", 0, "t"],
    ["f", 1, "e", "q"],
    [1, "e", "h", "p", "r", "d"],
    ["n", 2, 0, "q", "y", "y", "j"],
    ["m", 3, "e"],
    ["t", "s", "n", "v", "m", "s"],
    ["b", "h", "l"],
    ["k", "a", "r", "i", "b", "l", "s"],
    ["h", "a", 0, "l"],
    ["i", "r", "c", "z", "w", "o"],
    ["m", "i", "k", "n", "a", "w"],
    ["v", "h", 1, "w", "p"],
    ["f", "w", "p", "v", "r", "s", "k"],
    [3, "w", "x"],
    [3, "z", "b", "h", "k"],
    ["b", "k", "v", "o", 0, "b"],
    ["y", "u", "w", 1],
    ["y", "x", "n", "r", "f", "u", "d"],
    [0, "i", "x", "w", "f", "a"],
    ["e", "f", "c"],
    ["u", "f", "a"],
    ["o", "j", "j"],
    ["h", "j", "w", "s", "p", "a", "c"],
    ["w", "p", "r", "w", "q", "q", "t"],
    ["v", "v", 3, 0],
    ["b", "b", "i"],
    ["e", "w", "u", "g", "z", "w"],
    ["f", "o", "k", "r", "b"],
    ["r", 1, "h"],
    ["u", "k", "x", "n", "j", "e"],
    ["i", "h", "l", "r", "v", "g"],
    ["o", "b", "l", "s", "p"],
    ["t", "b", "q", "f", "a", "p", "q"],
    ["g", "c", "j"],
    ["z", "u", "l"],
    ["w", "m", "v", "g", "k", "f", "b"],
    ["e", "d", "s", "t", "r", "j", "f"],
    ["n", "h", "q", "n", "v", 3],
    ["b", "y", "t", "e", "m", "o"],
    ["s", "k", "s", "w", "d", 3, 2],
    [3, 0, "e", "q", "v"],
    [1, "b", "m", "n", "k", "e"],
    [0, "k", "n", "k", "s", "p", "t"],
    ["n", "f", "f", "f", "s", "i", "g"],
    [3, "s", "g"],
    ["p", "w", 1],
    ["g", "g", "w"],
    ["y", "o", "o", "b", "i", "w", "k"],
    ["r", "v", 1, "z", "u", "m", "x"],
    ["o", "g", "p"],
    ["g", "a", "j", "k", "e"],
    ["h", 3, "z", "q", "l", 2],
    ["v", 2, "q"],
    [0, "i", "s", "x"],
    ["w", "p", "s", "w", 2],
    ["y", "s", "z", 0],
    ["f", "j", "g", "x"],
    ["v", "r", 2, "a", "y"],
    ["c", "a", "t"],
    ["g", "w", "g", "h", "i"],
    ["m", "l", "y", "n", "r"],
    ["u", "u", "h", "t", "l", 0, "t"],
    ["m", 0, "v"],
    ["o", "t", "c", "c", "p", 3, "m"],
    ["o", "y", "c"],
    ["k", "p", "v"],
    ["f", "v", 3, "e"],
    ["i", "h", "a"],
    ["m", "t", 1, "r", "t", "d"],
    ["z", "u", 0],
    ["g", "q", "f", "m", "w", "a"],
    ["p", "w", "y", "m", "k", "x", "w"],
    ["m", "p", "a", "d", "u", "a", "u"],
    ["t", "z", "y", "p", "b"],
    ["w", "b", "k", "h", "c", "t", "u"],
    [3, "t", 3, "t", "t", "b"],
    [1, "o", 1, "b"],
    ["h", "a", "n", "x", 1, "x"],
    ["j", "u", "v", "n"],
    ["r", "h", "a"],
    ["m", "o", "b", "q"],
    ["t", "a", "o", "o", "t", "r"],
    ["a", "c", "h", 1],
    ["n", "c", "f"],
    ["a", "i", "w", "w"],
    ["e", "h", "t"],
    ["n", "k", "t", "h", "i", "b", "e"],
    ["l", "s", "p", "l", "s"],
    [1, "i", "o", "x", 2],
    ["m", "t", "b", "k", "s", "e", "q"],
    ["w", "m", 3],
    ["v", "v", "y", "w", "q", "l"],
    ["q", "t", 1],
    ["n", "j", "z", 0, "n", "z"],
    ["u", "z", 2, "k", "g", "u"],
    ["e", "y", "c"],
    ["e", "c", "h", "v"],
    [2, "v", "w", "h"],
    ["q", "g", "x", "t", "f"],
    ["c", "w", "v", "f", "r"],
    ["x", "g", "f", "w", "h", 3, "v"],
    ["o", "o", "c", "l", "a", "e", "w"],
    ["z", "l", 0, "r", "y"],
    ["l", "a", "e", "g", "s", "m", "g"],
    ["c", "m", "z", "x", "y", 0],
    ["s", "a", "l", "e"],
    ["h", "n", "l", "p"],
    ["q", 3, "u", "o", "n", "j", "b"],
    ["a", "n", "y", "l", "f"],
    ["k", "i", "t", "v", "f"],
    ["s", "i", "g"],
    ["m", "h", "l", "r", "s", "w"],
    ["y", "i", 3, "r", "x", "z", 0],
    ["s", "p", "d"],
    ["w", "s", "z", "g", 1, "j", 3],
    ["o", "z", "q", "e", "e", "x", "o"],
    ["d", "a", "c", "f"],
    ["k", "x", "g", "d", "q", "t"],
    ["z", "t", "h"],
    ["h", "s", "b", "i", "f"],
    ["f", "g", "c", "w"],
    ["w", "c", "i", "l", 2],
    ["f", "x", "p", "m", "o", "w", "a"],
    ["d", "n", 1, 0],
    ["l", "w", 0, "s", "x", "g"],
    ["f", "p", "i"],
    ["e", "f", "n", 2],
    ["r", "p", "n", "k"],
    ["g", "h", "g", "u", "t", 0, "s"],
    ["f", "i", "t", "e", "u", "m", "k"],
    [3, "v", "e", 1],
    ["h", "l", "t", "z", "w", "z"],
    ["j", "t", "j", "x", "k", "a", "l"],
    ["w", "l", "x"],
    ["p", "z", "i", "v", "j", "m", "i"],
    ["u", "t", "w", "q", "x", "v"],
    [1, 3, "e", "j"],
    ["x", "t", "d", 1, "m", "t", "l"],
    ["a", "v", "s"],
    ["g", "r", "c", "i"],
    ["j", "c", "g", "s", "z", "e"],
    ["j", "r", "k"],
    ["j", "v", "k", "k", "o", "p"],
    ["c", 3, "e"],
    ["w", "z", 3, "z", 3, "d", "g"],
    ["v", 2, "b"],
    ["d", "q", "n"],
    [2, "r", "o", "y", 3, "u", 0],
    ["r", "y", "a"],
    ["f", "v", "w", "w", "w", "n", "z"],
    ["q", 1, "q"],
    ["d", "g", "s", "f", 2, "i", "n"],
    ["f", "c", "p", "q", "z"],
    ["w", "h", "v", "t"],
    ["k", "r", 3, "m", "d", "a", "t"],
    ["i", "i", "v"],
    ["a", "m", 3, "c", "q", "d", "o"],
    [3, "o", "m", 3, "h"],
    [0, "v", 2, "n"],
    ["i", "s", "h", "d", "z", "x"],
    ["d", "f", "k", "p", "q"],
    ["f", "w", "d", "h", "h", "f", "n"],
    ["n", "a", "r", "r", "u", "h"],
    [0, "w", "m", "p"],
    ["a", "y", "z", "z", "h", "o", 3],
    ["f", "h", "f", "w", "o", "y"],
    ["q", "g", "w", "g", 3],
    ["h", "c", "t", "f"],
    ["s", "h", "l", "n", "v"],
    ["y", "q", "f", "m", "r", "e"],
    ["t", "l", "h", "a", "y", "w", 0],
    [1, "a", "y", 2, "d", "p"],
    ["o", "w", "w"],
    ["b", "n", "s", "g", "l"],
    ["m", "a", 0, "n", "h"],
    ["w", "f", "m", "f", "l", "i"],
    ["h", "s", "p", "c", "r", "e", "b"],
    ["l", "l", "d", "p", "w", 1, "m"],
    ["e", "u", "x"],
    ["f", "h", "t", "l", "n"],
    ["n", 2, "p", "o", "o", "p"],
    ["h", "i", 3, 1, "b", "i", "h"],
    ["q", 3, "n"],
    ["q", "p", "a", "d", "h", "c"],
    ["l", "c", "p", "a", "h", "b", "y"],
    ["u", "l", "d", "i", "i", "q", "l"],
    ["y", "i", "w"],
    ["i", "r", "u", "t"],
    ["w", "x", "i", "y", "t"],
]
