//
// Copyright (c) 2017 Set. All rights reserved.
// Portions copyright (c) 2015 Venture Media Labs.
// https://gist.github.com/natecook1000/3b15b8bd974c8c08b3df
//

import Foundation

internal protocol Interval {
    var start: Int? { get }
    var end: Int? { get }
    var isEmpty: Bool { get }
}

extension Interval {
    var start: Int? { return nil }
    var end: Int? { return nil }
    var isEmpty: Bool {
        guard let lower = start, let upper = end else { return false }
        return lower > upper
    }
}

internal struct EmptyRange: Interval {
    let isEmpty: Bool = true
}

internal struct IntervalRange: Interval, ExpressibleByIntegerLiteral {
    var start: Int?
    var end: Int?

    static var empty = EmptyRange()

    init(start: Int? = nil, end: Int? = nil) {
        self.start = start
        self.end = end
    }

    init(range: CountableClosedRange<Int>) {
        start = range.start
        end = range.end
    }

    init(range: CountableRange<Int>) {
        start = range.start
        end = range.end.map { $0 - 1 }
    }

    init(integerLiteral value: Int) {
        start = Optional(value)
        end = Optional(value)
    }
}

extension CountableRange: Interval {
    var start: Int? {
        return unsafeBitCast(lowerBound, to: Int.self)
    }

    var end: Int? {
        return unsafeBitCast(upperBound, to: Int.self) - 1
    }
}

extension CountableClosedRange: Interval {
    var start: Int? {
        return unsafeBitCast(lowerBound, to: Int.self)
    }

    var end: Int? {
        return unsafeBitCast(upperBound, to: Int.self)
    }
}

extension Int: Interval {
    var start: Int? { return self }
    var end: Int? { return self }
}

prefix operator ...
postfix operator ...
prefix operator ..<

extension Int {
    static prefix func ... (end: Int) -> IntervalRange {
        return IntervalRange(end: end)
    }

    static postfix func ... (start: Int) -> IntervalRange {
        return IntervalRange(start: start)
    }

    static prefix func ..< (end: Int) -> IntervalRange {
        return IntervalRange(end: end - 1)
    }
}
