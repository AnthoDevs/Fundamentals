enum GenericFunctions {
    static func search<T>(_ items : [T], where condition: (T) -> Bool ) -> [T] {
        var result: [T] = []
        for item in items {
            if condition(item) {
                result.append(item)
            }
        }
        return result
    }
    
    static func localSort<T>(_ items : [T], by areIncresingOrder: (T, T) -> Bool ) -> [T] {
        items.sorted(by: areIncresingOrder)
    }
}
