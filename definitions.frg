#lang forge

// abstract sig Response {}
// one sig Yes extends Response {}
// one sig No extends Response {}

// sig MatchStatus {
//   e: one Element,
//   r: one Response,
// }

abstract sig Element {
  // set enforces that Ints are unique for every Person
  preferences: pfunc Int -> Element,
  match: lone Element,
}

sig Man extends Element {}
sig Woman extends Element {}

sig Match {
  groupA: set Element,
  groupB: set Element
}

pred wellformed[m: Match] {
  m.groupA = Man
  m.groupB = Woman

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

// fun getPreferenceValue[s: set Element, e: Element] {
//   e in s
// }

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

run {
  wellformed[Match]
  isMatch[Match]
  isStable[Match]
} for exactly 3 Man, exactly 3 Woman, exactly 1 Match