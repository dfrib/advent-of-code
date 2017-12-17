// Advent of Code 2017 - Day 13: Packet Scanners
// Swift 4
// ------------------------------------------------------------------ //
import Foundation
let puzzleInput = """
0: 4
1: 2
2: 3
4: 4
6: 8
8: 5
10: 8
12: 6
14: 6
16: 8
18: 6
20: 6
22: 12
24: 12
26: 10
28: 8
30: 12
32: 8
34: 12
36: 9
38: 12
40: 8
42: 12
44: 17
46: 14
48: 12
50: 10
52: 20
54: 12
56: 14
58: 14
60: 14
62: 12
64: 14
66: 14
68: 14
70: 14
72: 12
74: 14
76: 14
80: 14
84: 18
88: 14
"""

class Layer {
    let depth: Int
    let range: Int
    init(_ depth: Int, _ range: Int) {
        self.depth = depth
        self.range = range
    }
}

// Generate void tuples for unsuccessful attempts; exhausted upon success.
struct PacketGenerator: Sequence, IteratorProtocol {
    let firewall: [Layer]
    var delay: Int

    init(_ firewall: [Layer], initialPacketDelay: Int = 0) {
        self.firewall = firewall
        self.delay = initialPacketDelay
    }

    // The scanners traverse the layers in a triangular manner, e.g.
    // for range==4: 0, 1, 2, 3, 2, 1 [full cycle], where only the
    // first position in each triangular cycle is a catching one.
    // The period of each triangular cycle is 2*(range-1), and a packet
    // is caught only if the delay+depth is an integer multiple of the
    // period.
    mutating func next() -> ()? {
        // Packet caught at any layer?
        if firewall.contains(where: { (delay+$0.depth) % (2 * ($0.range - 1)) == 0})
        { return delay += 1 }

        // Packet through safe!
        return nil
    }

    // Severity given current delay
    func severity() -> Int {
        return firewall
            .filter { (delay+$0.depth) % (2 * ($0.range - 1)) == 0 }
            .reduce(0) { $0 + $1.depth * $1.range }
    }
}

// Parse input into the generator.
var packetGenerator = PacketGenerator(puzzleInput
    .split(separator: "\n")
    .map { $0.components(separatedBy: ": ").flatMap { Int($0) } }
    .map { Layer($0[0], $0[1]) })

// Part 1.
let severityOfFirstTry = packetGenerator.severity()

// Part 2: Consume attempts until successful journey.
while let _ = packetGenerator.next() {} //

// Result.
print("Part 1 =", severityOfFirstTry)    // 648
print("Part 2 =", packetGenerator.delay) // 3933124

