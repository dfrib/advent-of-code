// Advent of Code 2017 - Day 10: Knot Hash - Part 2
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = """
46,41,212,83,1,255,157,65,139,52,39,254,2,86,0,204
"""
var list = Array(0...255)
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
    var knotHash: String {
        return map { ($0 < 16 ? "0" : "") + String($0, radix: 16)}.joined()
    }
}

// Parse chars to ASCII codes.
let lengthSequence = puzzleInput
    .unicodeScalars.map { Int($0.value) } + standardSuffix

// Run knot hash rounds.
var totalShift = 0
var accumulatedGlobalSkipSize = 0
var answer1 = 0
for _ in 1...64 {
    for n in lengthSequence {
        totalShift += n + accumulatedGlobalSkipSize
        list.reverse(upTo: n)
        list.rotateLeft(by: n + accumulatedGlobalSkipSize)
        accumulatedGlobalSkipSize += 1
    }
}
list.rotateLeft(by: list.count - totalShift % list.count)

// Result.
print("Part 2 =", list.denseHash.knotHash) // 7f94112db4e32e19cf6502073c66f9bb

