// Advent of Code 2017 - Day 15: Dueling Generators
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = (genA: 277, genB: 349)

struct Generator1: Sequence, IteratorProtocol {
    var value: Int
    let factor: Int
    let divisor: Int

    init(_ value: Int, _ factor: Int, _ divisor: Int = 2147483647) {
        self.value = value
        self.factor = factor
        self.divisor = divisor
    }

    mutating func next() -> Int? {
        value = (factor * value) % divisor
        return value & 0xffff
    }
}

struct Generator2: Sequence, IteratorProtocol {
    var value: Int
    let factor: Int
    let divisor: Int
    let criteria: Int

    init(_ value: Int, _ factor: Int, _ criteria: Int, _ divisor: Int = 2147483647) {
        self.value = value
        self.factor = factor
        self.criteria = criteria
        self.divisor = divisor
    }

    mutating func next() -> Int? {
        repeat { value = (factor * value) % divisor } while value % criteria != 0
        return value & 0xffff
    }
}

// Part 1.
var genA1 = Generator1(puzzleInput.genA, 16807)
var genB1 = Generator1(puzzleInput.genB, 48271)
var judgeCount1 = 0
for _ in 1...40_000_000 where genA1.next() == genB1.next() { judgeCount1 += 1 }

// Part 2.
var genA2 = Generator2(puzzleInput.genA, 16807, 4)
var genB2 = Generator2(puzzleInput.genB, 48271, 8)
var judgeCount2 = 0
for _ in 1...5_000_000 where genA2.next() == genB2.next() { judgeCount2 += 1 }

// Result.
print("Part 1 =", judgeCount1) // 592
print("Part 2 =", judgeCount2) // 320
