// Advent of Code 2017 - Day 10: Knot Hash - Part 1
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = """
46,41,212,83,1,255,157,65,139,52,39,254,2,86,0,204
"""
var list = Array(0...255)

extension Array {
    mutating func rotateLeft(by n: Int) {
        let nt = n % count
        self = Array(self[nt..<count] + self[0..<nt])
    }
    mutating func reverse(upTo n: Int) {
        let nt = n % count
        self = Array(self[0...nt].reversed() + self[(nt+1)..<count])
    }
}

let puzzleNumbers = puzzleInput
    .split(separator: ",")
    .flatMap{Int($0)}
    .enumerated()

var totalShift = 0
for (skipSize, n) in puzzleNumbers {
    totalShift += n + skipSize
    list.reverse(upTo: n)
    list.rotateLeft(by: n + skipSize)
}
list.rotateLeft(by: list.count - totalShift % list.count)

// Result.
print("Part 1 =", list[0]*list[1])

