#lang forge

option problem_type temporal
option max_tracelength 14

abstract sig Element {
  // set enforces that Ints are unique for every Person
  preferences: pfunc Int -> Element,
  var match: lone Element,

  // record who they have already proposed to
  var proposed: set Element
}

sig Man extends Element {}
sig Woman extends Element {}

sig Match {
  groupA: set Element,
  groupB: set Element
}

pred wellformed[m: Match] {
  // m.groupA = Man
  // m.groupB = Woman

  // Enforce that there are the same number of men and women
  #{m.groupA} = #{m.groupB}
  // elements in group A and group B are disjoint
  no m.groupA & m.groupB

  // Enforce that for every man:
  all a: m.groupA | {
    all i: (a.preferences).(m.groupB) | {
      i >= 1
      i <= #{m.groupA}
    }

    Int.(a.preferences) = m.groupB
    #{a.preferences} = #{m.groupB}
  }

  // Enforce the same for every woman
  all b: m.groupB | {
    all i: (b.preferences).(m.groupA) | {
      i >= 1
      i <= #{m.groupB}
    }

    Int.(b.preferences) = m.groupA
    #{b.preferences} = #{m.groupA}
  }
}

// Enforces that the instance is a Match
pred isMatch[m: Match] {
  all a: m.groupA | {
    a.match != none
    (a.match).match = a
  }
  m.groupA.match = m.groupB

  all b: m.groupB | {
    b.match != none
    (b.match).match = b
  }
  m.groupB.match = m.groupA
}

pred isStable[m: Match] {
  all a: m.groupA | {
    let matchPref = (a.preferences).(a.match) | {
      no other: m.groupB | {
        (a.preferences).other < matchPref
        (other.preferences).a < (other.preferences).(other.match)
      }
    }
  }
}

pred stableMatch[m: Match] {
  wellformed[m]
  isMatch[m]
  isStable[m]
}

pred init {
  all m: Match | {
    wellformed[m]
  }
}

inst two_people {
  Match = `Match0
  Man = `M0 + `M1
  Woman = `W0 + `W1
  Element = Man + Woman
  groupA = `Match0 -> Man
  groupB = `Match0 -> Woman
}

inst three_people {
  Match = `Match0
  Man = `M0 + `M1 + `M2
  Woman = `W0 + `W1 + `W2
  Element = Man + Woman
  groupA = `Match0 -> Man
  groupB = `Match0 -> Woman
}

inst five_people {
  Match = `Match0
  Man = `M0 + `M1 + `M2 + `M3 + `M4
  Woman = `W0 + `W1 + `W2 + `W3 + `W4
  Element = Man + Woman
  groupA = `Match0 -> Man
  groupB = `Match0 -> Woman
}