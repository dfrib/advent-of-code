// Advent of Code 2017 - Day 16: Permutation Promenade
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = 324

extension Array {
    /*
     mutating func rotateLeft(by n: Int) {
     let nt = n % count
     self = Array(self[nt..<count] + self[0..<nt])
     }*/
    mutating func rotateToLast(idx: Int) {
        let i = idx % count
        if i != count - 1 { self = Array(self[(i+1)...] + self[0...i]) }
    }
    mutating func reverse(upTo n: Int) {
        if n >= count { self.reverse() }
        else { self = Array(self[0..<n].reversed() + self[n..<count]) }
    }
    mutating func insert(_ newElement: Element, after: Int) {
        if after >= count - 1 { self.append(newElement) }
        else { insert(newElement, at: after + 1) }
    }
}

let steps = puzzleInput

// Part 1: always rotate the new current position to last.
// (Every inserted value will be an appended one; after rotation).
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
