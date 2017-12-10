// Advent of Code 2017 - Day 3: Spiral Memory - Part 2
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = 312051

// Pre-study (paper and pen!)
// ------------------------------------------------------------------ //

// Let "a quadrant" relate to the numbers FROM the first number
// after a corner value, and up until and including the next corner
// value.
// A new layer always start just after visiting the fourth quadrant,
// i.e., leaving the final corner value of that layer.
// We shall relate each value of a given layer as a linear combination
// of the values from the previous layer. I.e., for all values of a
// given layer, we compute the linear coefficients for that value
// relating to values of the previous layer. Note that contributions
// from same-layer neighbours can also we written in terms of values
// from the previous layer.

// We study a concrete example to see the pattern in the coefficient
// matrix.
// Assume we are starting traversing the 4th layer (counting the
// single 1 as the 0th layer).

// 1st quadrant
// ------------
// Then for numbers 1 -> (quadrantSize - 2) the coefficients grow as
// Row 1: [1, 0, 0, 0, 0, 0, 0, ..., 1]
// Row 2: [2, 1, 0, 0, 0, 0, 0, ..., 1]
// Row 3: [3, 2, 1, 0, 0, 0, 0, ..., 1]
// Row 4: [3, 3, 2, 1, 0, 0, 0, ..., 1]
// Row 5: [3, 3, 3, 2, 1, 0, 0, ..., 1]
// Row 6: [3, 3, 3, 3, 2, 1, 0, ..., 1]

// For the number (quadrantSize - 1) (i.e., before corner), the prior
// coefficients will no longer expand to relate to new values in the
// previous layer, but the last two non-zero coefficients (excluding
// the final) will instead increase by 1.
// E.g., for quadrantSize-1 == 7.
// Row 7: [3, 3, 3, 3, 3, 2, 0, ..., 1]

// Finally, for the corner number, the single non-zero coefficient
// (exclusing the final) increase by one.
// E.g., for quadrantsize == 8.
// Row 8: [3, 3, 3, 3, 3, 3, 0, ..., 1]

// 2nd quadrant
// ------------
// When reaching quadrant 2 (_after_ the corner value), all coefficients
// will kind of "double" as the two previous rows will both be same-layer
// neighbours, and hence both participate in the first new value in the
// quadrant. So, to continue the the example above:
// Row 9: [6, 6, 6, 6, 6, 5, 1, ..., 1]

// From here on, we can repeat the study and will see a quite apparent
// pattern in the coefficients, a quite quadrant-generic one, which will
// only need some corrections around the corner between first and fourth
// quadrant.

// ------------------------------------------------------------------ //

// Implementation!
// ------------------------------------------------------------------ //
// To solve this quickly, use a stupid row-major "matrix" which is just
// and array or arrays (row-wise w.r.t. coefficients).
extension Array where Element == [Int] {
    init(rows: Int, cols: Int, defaultValue: Int = 0) {
        self.init(repeating: Array<Int>(repeating: defaultValue, count: cols),
                  count: rows)
    }
}

// Comptes coefficients for a layers.
struct SpiralCoefficients {

    // Coefficients of 1st layer, relating to the value(s) of the first layer.
    static let firstLayerCoefficients = [
        [1],
        [2],
        [4],
        [5],
        [10],
        [11],
        [23],
        [25]]

    // For each square in a given layer, compute its value by relating the
    // value to coefficients of the numbers of the previous layer. This allows
    // us to recursively compute values bottom (0th layer) up until we are
    // satiesfied (i.e., exceed our puzzle input).
    static func getCoefficients(forLayer n: Int) -> [[Int]] {
        assert(n > 0, "No coefficients for root layer: they cannot relate to a previous layer.")

        if n == 1 { return firstLayerCoefficients }

        // Setup base pattern.
        let (rows, cols) = (layerSize(n), layerSize(n-1))
        var coefs = Array(rows: rows, cols: cols)
        for j in 0..<cols/4 {
            for i in j..<(rows/4 - 1) {
                // Progressing blocks (1, 0, 0 \ 2, 1, 0 \ 3, 2, 1 \ ... )
                for (di, dj) in zip(stride(from: 0, to: rows, by: rows/4),
                                    stride(from: 0, to: cols, by: cols/4))
                {
                    coefs[i+di][j+dj] = min(i - j % (cols/4) + 1, 3)
                    if i == (rows/4 - 2) {
                        coefs[i+di+1][j+dj] = 3
                    }
                }
                // Visited blocks (increased by sub-corner doubling).
                if i == j {
                    // 6, 6, ..., 7 blocks
                    for (di, dj) in
                        zip(stride(from: rows/4, to: rows, by: rows/4),
                            stride(from: 0, to: 3*cols/4, by: cols/4)) {
                        // Final column for all but first row is 7.
                        (0..<rows/4).forEach {
                            coefs[$0+di][j+dj] =
                                $0 != 0 && j == cols/4 - 1 ? 7 : 6
                        }
                    }
                    // 12, 12, ..., 14 blocks.
                    for (di, dj) in
                        zip(stride(from: rows/2, to: rows, by: rows/4),
                            stride(from: 0, to: cols/2, by: cols/4)) {
                        // Final column always 14.
                        (0..<rows/4).forEach {
                            coefs[$0+di][j+dj] = j == cols/4 - 1 ? 14 : 12
                        }
                    }
                    // 24, 24, ..., 28 block.
                    for (di, dj) in
                        zip(stride(from: 3*rows/4, to: rows, by: rows/4),
                            stride(from: 0, to: cols/4, by: cols/4)) {
                        // Final column always 28.
                        (0..<rows/4).forEach {
                            coefs[$0+di][j+dj] = j == cols/4 - 1 ? 28 : 24
                        }
                    }
                }
            }
        }

        // Final column correction
        for (quadrant, baseRow) in
            stride(from: 0, to: rows, by: rows/4).enumerated() {
            (0..<rows/4).forEach {
                coefs[baseRow+$0][cols-1] = (0...quadrant)
                    .reduce(1) { p, _ in p * 2 }
            }
            if quadrant == 0 { coefs[baseRow][cols-1] = 1 }
        }

        // Final three rows correction (approaching final corner / return to start)
        for (relativeIdx, row) in ((rows-3)..<rows).enumerated() {
            coefs[row][0] += relativeIdx
            coefs[row][cols-1] += 1 + relativeIdx * 2
        }

        return coefs
    }

    private static func layerSize(_ layerNum: Int) -> Int {
        if layerNum == 0 { return 1 }
        return layerNum * 8
    }
}

// Store values of a given layer, and allowing morphing into values of
// the next layer using the SpiralCoefficients if the next layer.
struct SpiralLayer {
    var layerNum: Int = 0
    var layerValues: [Int] = [1]
    var count: Int { return layerValues.count }

    subscript(idx: Int) -> Int { return layerValues[idx] }

    mutating func morphIntoNext() {
        layerNum += 1
        let nextLayerCoefficients = SpiralCoefficients
            .getCoefficients(forLayer: layerNum)
        var newLayerValues: [Int] = []
        for row in nextLayerCoefficients {
            newLayerValues.append(zip(layerValues, row)
                .reduce(0) { $0 + ($1.0 * $1.1) })
        }
        layerValues = newLayerValues
    }
}

// Generator of stress test value for the spiral memory.
struct SpiralMemoryStressTestGenerator: Sequence, IteratorProtocol {
    var nextValueIdx: Int = 0
    var currentSpiralLayer = SpiralLayer()

    mutating func next() -> Int? {
        defer { prepareNextValue() }
        return currentSpiralLayer[nextValueIdx]
    }

    mutating func prepareNextValue() {
        // Next value still in current layer?
        if nextValueIdx + 1 < currentSpiralLayer.count {
            nextValueIdx += 1
        }
        // Move on to next layer.
        else {
            currentSpiralLayer.morphIntoNext()
            nextValueIdx = 0
        }
    }
}

// Consume until we've hit the predicate.
var stressValueGenerator = SpiralMemoryStressTestGenerator()
var largerThanPuzzleInput: Int = 0
while let consume = stressValueGenerator.next(),
    consume < puzzleInput ? true : (largerThanPuzzleInput = consume, false).1 {}
print(largerThanPuzzleInput) // 312453
