// Advent of Code 2017 - Day 14: Disk Defragmentation - Part 1
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = "hxtvlmkl"

// ------------------------------------------------------------------ //
// From Day 10 - Part 2 (slightly modified: bit pattern hash)
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

// Wrap single hash knot from Daty 10 into a function repeated hash calls.
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
// ------------------------------------------------------------------ //

// ------------------------------------------------------------------ //
// From Day 12
var groups: [Set<Int>] = []
while !adjacencyList.isEmpty {
    // First first run: explicitly use start with 0, thereafter
    // choose arbitrarily (list is non-empty, so .first exists).
    let fromId = adjacencyList[0] != nil ? 0 : adjacencyList.keys.first!

    var group = Set<Int>([fromId])
    var queue = adjacencyList[fromId] ?? []
    while !queue.isEmpty {
        if let next = queue.popLast(), !group.contains(next) {
            queue += adjacencyList[next] ?? []
            group.update(with: next)
        }
    }

    // Add group to groups list and remove its members from adj. list
    groups.append(group)
    for id in group {
        adjacencyList.removeValue(forKey: id)
    }
}
// ------------------------------------------------------------------ //

// Start of Day 14 - Part 2
extension Character {
    var intValue: Int? { return Int(String(self)) }
}

// Construct grid
let grid = (0...127)
    .map { knotHashBitPattern(puzzleInput + "-" + String($0)).flatMap { $0.intValue } }

// 128x128 isn't so bad, so brute-force all bits into an adjacancy list
// of the the Day 12 form, and apply Day 12 solution to it.
var adjacencyList = [Int:[Int]]()
var id = -1
for (i, row) in grid.enumerated() {
    for (j, bit) in row.enumerated() where (id += 1, bit == 1).1 {
        var neighbours = [Int]()
        // Above of.
        if i > 0 && grid[i-1][j] == 1 { neighbours.append(id-128) }
        // Left of.
        if j > 0 && grid[i][j-1] == 1 { neighbours.append(id-1) }
        // Right of.
        if j < 127 && grid[i][j+1] == 1 { neighbours.append(id+1) }
        // Below of.
        if i < 127 && grid[i+1][j] == 1 { neighbours.append(id+128) }

        adjacencyList[id] = neighbours
    }
}

// Result.
print("Part 2 =", groups.count)  // 1093
