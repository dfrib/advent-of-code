// Advent of Code 2017 - Day 14: Disk Defragmentation - Part 1
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = "hxtvlmkl"
let standardSuffix = [17, 31, 73, 47, 23]

extension Array where Element == Int {
    mutating func rotateLeft(by n: Int) {
        let nt = n % count
        self = Array(self[nt..<count] + self[0..<nt])
    }
    mutating func reverse(upTo n: Int) {
        if n >= count { self.reverse() }
        else { self = Array(self[0..<n].reversed() + self[n..<count]) }
    }
    func chunk(size n: Element) -> [SubSequence] {
        var result: [SubSequence] = []
        var (i, j) = (startIndex, 0)
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            result.append(self[i..<j])
            i = j
        }
        return result
    }
    var xorSum: Int { return reduce(0) { $0 ^ $1 } }
    var denseHash: [Element] {
        return chunk(size: 16).map { Array($0).xorSum }
    }
    // Skip the hex step.
    var knotHashBitPattern: String {
        return map {
            let bits = String($0, radix: 2)
            return String(repeating: "0", count: 8 - bits.count) + bits
            }.joined()
    }
}

func knotHashBitPattern(_ input: String) -> String {
    var list = Array(0...255)
    let standardSuffix = [17, 31, 73, 47, 23]

    // Parse chars to ASCII codes.
    let lengthSequence = input
        .unicodeScalars.map { Int($0.value) } + standardSuffix

    // Run knot hash rounds.
    var totalShift = 0
    var accumulatedGlobalSkipSize = 0
    for _ in 1...64 {
        for n in lengthSequence {
            totalShift += n + accumulatedGlobalSkipSize
            list.reverse(upTo: n)
            list.rotateLeft(by: n + accumulatedGlobalSkipSize)
            accumulatedGlobalSkipSize += 1
        }
    }
    list.rotateLeft(by: list.count - totalShift % list.count)

    return list.denseHash.knotHashBitPattern
}

extension Character {
    var intValue: Int? { return Int(String(self)) }
}

// Part 1.
let numSquares = (0...127)
    .map { knotHashBitPattern(puzzleInput + "-" + String($0)) }
    .joined().flatMap { $0.intValue }.reduce(0, +)

// Result.
print("Part 1 =", numSquares) // 8214
