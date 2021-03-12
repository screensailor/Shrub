class DeltaShrub™: Hopes {
    
    private var bag: Set<AnyCancellable> = []

    func test() throws {
        
        var result: Result<Int, Error> = .failure("😱")
        
        var delta = DeltaJSON()

        let route: JSONRoute = [1, "two", 3]
        
        delta.store[route] = 4

        delta.flow(of: route).sink{ result = $0 ¶ "✅ 1" }.store(in: &bag)
        delta.flow(of: route).sink{ result = $0 ¶ "✅ 2" }.store(in: &bag)
        delta.flow(of: route).sink{ result = $0 ¶ "✅ 3" }.store(in: &bag)
        
        hope(result) == 4
        
        delta.store[route] = 5
        
        hope(result) == 5
        
        delta.store[route] = 6
        
        hope(result) == 6
        
        delta = DeltaJSON()
    }
}
