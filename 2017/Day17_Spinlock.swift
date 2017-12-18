// Advent of Code 2017 - Day 17: Spinlock
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = 324
let steps = puzzleInput

// Part 1: always rotate the new current position to last.
// (Every inserted value will be an appended one; after rotation).
extension Array {
    mutating func rotateToLast(idx: Int) {
        let i = idx % count
        if i != count - 1 { self = Array(self[(i+1)...] + self[0...i]) }
    }
}
var buffer = [0]
for i in 1...2017 {
    buffer.rotateToLast(idx: steps - 1)
    buffer.append(i)
}

// Part 2: a value can never be inserted before the first element,
// element==index==0, so just track each time current position hits 0.
var currentPos = 0
var valueAfterZero = 0
for i in 1...50_000_000 {
    currentPos = (currentPos + steps) % i
    if currentPos == 0 { valueAfterZero = i }
    // "Value inserted" and move position one step ahead.
    currentPos += 1
}

// Results.
print("Part 1 =", buffer[0])       // 1306
print("Part 2 =", valueAfterZero)  // 20430489
