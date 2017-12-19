// Advent of Code 2017 - Day 18: Duet - Part 1
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput = """
set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 618
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19
"""

enum Instruction {
    case snd(String)
    case set(String, String)
    case add(String, String)
    case mul(String, String)
    case mod(String, String)
    case rcv(String)
    case jgz(String, String)
    init?(_ instruction: String, _ oper1: String, _ oper2: String? = nil) {
        switch(instruction) {
        case "snd": self = .snd(oper1)
        case "set": self = .set(oper1, oper2 ?? "_")
        case "add": self = .add(oper1, oper2 ?? "_")
        case "mul": self = .mul(oper1, oper2 ?? "_")
        case "mod": self = .mod(oper1, oper2 ?? "_")
        case "rcv": self = .rcv(oper1)
        case "jgz": self = .jgz(oper1, oper2 ?? "_")
        default: return nil
        }
    }
}

extension String {
    var intValue: Int? { return Int(self) }
}

let instructions = puzzleInput.split(separator: "\n")
    .map { $0.split(separator: " ") }
    .flatMap { s -> Instruction? in
        let s2 = String(s[1])
        let s3 = s.count > 2 ? String(s[2]) : nil
        return Instruction(String(s[0]), s2, s3)
}

var register = [String: Int]()
var (i, cont, recovered) = (0, true, -1)
while (cont && i < instructions.count) {
    switch(instructions[i]) {
    case let .snd(v): register["freq"] = v.intValue ?? register[v] ?? 0
    case let .set(r, v): register[r] = v.intValue ?? register[v] ?? 0
    case let .add(r, v): let val = v.intValue ?? register[v] ?? 0; register[r]? += val
    case let .mul(r, v): let val = v.intValue ?? register[v] ?? 0; register[r]? *= val
    case let .mod(r, v): let val = v.intValue ?? register[v] ?? 0; register[r]? %= val
    case let .rcv(v): v != "0"
        ? (register["freq"].map { recovered = $0 } )
        : nil; cont = false; continue
    case let .jgz(v1, v2):
        if v1.intValue ?? register[v1] ?? 0 > 0 {
            i += v2.intValue ?? register[v2] ?? 0
            continue
        }
    }
    i += 1
}

// Result.
print("Part 1 =", recovered)  // 3423





