// Advent of Code 2017 - Day 6: Memory Reallocation
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = """
4    1    15    12    0    9    9    5    5    8    7    3    14    5    12    3
"""

// Common.
extension String {
    var puzzleNumbers: [Int] {
        return split(separator: " ").flatMap { Int($0) }
    }
}

extension Array where Element == Int {
    mutating func removeMaxValue() -> (atIdx: Int, value: Int) {
        // Somewhat (2-pass) wasteful.
        guard let idxOfMax = self.max().flatMap({ index(of: $0) })
            else { return (-1, -1) }
        defer { self[idxOfMax] = 0 }
        return (idxOfMax, self[idxOfMax])
    }

    mutating func distribute(value: Int, startingAfterIdx idx: Int) -> () {
        for dIdx in 1...value {
            self[(idx + dIdx) % count] += 1
        }
    }

    var asString: String {
        return map(String.init).joined(separator: "_")
    }
}

// Part 1.
struct MemoryReallocator1: Sequence, IteratorProtocol {
    var bankStates: [Int]
    var seenStates = Set<String>()

    init(initialBankState: [Int]) { bankStates = initialBankState }

    mutating func next() -> Int? {
        if seenStates.update(with: bankStates.asString) == nil {
            let (idx, value) = bankStates.removeMaxValue()
            bankStates.distribute(value: value,
                                  startingAfterIdx: idx)
            return 1 // 1 re-distrubution
        }
        return nil
    }

    mutating func consumeAll() -> Int {
        var numOfRedistributions: Int = 0
        while let _ = next() { numOfRedistributions += 1 }
        return numOfRedistributions
    }
}

// Part 2.
struct MemoryReallocator2: Sequence, IteratorProtocol {
    var currentCycle = 0
    var loopSize = 0
    var bankStates: [Int]
    var seenStates = [String:Int]()

    init(initialBankState: [Int]) { bankStates = initialBankState }

    mutating func next() -> Int? {
        if let lastSeenAtCycle = seenStates
            .updateValue(currentCycle, forKey: bankStates.asString) {
            loopSize = currentCycle - lastSeenAtCycle
            return nil
        }
        let (idx, value) = bankStates.removeMaxValue()
        bankStates.distribute(value: value,
                              startingAfterIdx: idx)
        currentCycle += 1
        return 1 // 1 re-distrubution
    }

    mutating func consumeAll() -> Int {
        while let _ = next() {}
        return loopSize
    }
}

var memoryReallocator1 = MemoryReallocator1(initialBankState: puzzleInput.puzzleNumbers)
var memoryReallocator2 = MemoryReallocator2(initialBankState: puzzleInput.puzzleNumbers)

print("Part 1 =", memoryReallocator1.consumeAll()) // 6681
print("Part 2 =", memoryReallocator2.consumeAll()) // 2392

