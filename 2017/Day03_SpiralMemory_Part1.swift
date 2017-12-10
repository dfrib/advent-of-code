// Advent of Code 2017 - Day 3: Spiral Memory - Part 1
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = 312051

extension Int {
    var squared: Int {
        return self*self
    }
    enum Step: Int {
        case down = -1
        case up = 1
    }
    // In lack of better words, "bounce" the integer between
    // [lowerBound, upperBound] by increments of magnitude 1.
    // (E.g. 1->2->3->2->1->0->1-> ... for LB=0 and UB=3)
    mutating func bounce(_ step: inout Int.Step,
                         _ upperBound: Int,
                         _ lowerBound: Int = 0) {
        if self == upperBound { step = .down }
        else if self == lowerBound { step = .up }
        self += step.rawValue;
    }
    var spiralSteps: Int {
        // Radial distance.
        let radDist = (0...)
            .prefix(while: {(2 * $0 + 1).squared < self})
            .reduce(0) { $1 + 1 }
        // "Angular" distance.
        let remainingSteps = self - 1 - (2 * (radDist - 1) + 1).squared
        var angDist = radDist-1
        var step = Int.Step.down
        for _ in 1...remainingSteps { angDist.bounce(&step, radDist) }
        // Total (Manhattan) distance.
        return radDist + angDist
    }
}

print(puzzleInput.spiralSteps) // 430
