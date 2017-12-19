// Advent of Code 2017 - Day 16: Permutation Promenade
// Swift 4
// ------------------------------------------------------------------ //
let puzzleInput1 = """
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
"""

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

var register1 = ["p": 0]
var queue1 = [Int]()
var register2 = ["p": 1]
var queue2 = [Int]()
var (i, j, cont, sendCount1) = (0, 0, (true, true), 0)
while ((cont.0 || cont.1) && max(i, j) < instructions.count) {
    cont = (true, true)
    func foo(_ it: inout Int, _ reg: inout [String: Int],
             _ rqueue: inout [Int], _ squeue: inout [Int], _ isProgram0: Bool = true) {
        switch(instructions[it]) {
        case let .snd(v): squeue = [v.intValue ?? reg[v] ?? 0] + squeue
                          sendCount1 += isProgram0 ? 0 : 1
        case let .set(r, v): reg[r] = v.intValue ?? reg[v] ?? 0
        case let .add(r, v): let val = v.intValue ?? reg[v] ?? 0; reg[r]? += val
        case let .mul(r, v): let val = v.intValue ?? reg[v] ?? 0; reg[r]? *= val
        case let .mod(r, v): let val = v.intValue ?? reg[v] ?? 0; reg[r]? %= val
        case let .rcv(r): if rqueue.count > 0 { reg[r] = rqueue.popLast()! }
        else if isProgram0 { cont.0 = false; return }
        else               { cont.1 = false; return }
        case let .jgz(v1, v2):
            if v1.intValue ?? reg[v1] ?? 0 > 0 {
                it += v2.intValue ?? reg[v2] ?? 0
                return
            }
        }
        it += 1
    }
    foo(&i, &register1, &queue1, &queue2)
    foo(&j, &register2, &queue2, &queue1, false)
}

// Result.
print("Part 2 =", sendCount1)  // 7493




