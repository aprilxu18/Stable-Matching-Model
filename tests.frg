#lang forge
open "definitions.frg"

example twoPeopleSamePreferences is {some m: Match | stableMatch[m]} for {
  Match = `Match0
  Man = `M0 + `M1 + `M2
  Woman = `W0 + `W1 + `W2
  Element = Man + Woman
  groupA = `Match0 -> Man
  groupB = `Match0 -> Woman

  // M0 and M1 prefer same women in same order,
  // W0 and W1 prefer same men in same order
  preferences = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 3 -> `W2 +
                `M1 -> 1 -> `W0 + `M1 -> 2 -> `W1 + `M1 -> 3 -> `W2 +
                `M2 -> 1 -> `W1 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W2 +
                `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
                `W1 -> 1 -> `M0 + `W1 -> 2 -> `M1 + `W1 -> 3 -> `M2 +
                `W2 -> 1 -> `M1 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M2
  match = `M0 -> `W0 + `M1 -> `W1 + `M2 -> `W2 +
          `W0 -> `M0 + `W1 -> `M1 + `W2 -> `M2
}

// Cannot have two people with the same match
example noSameMatches is not {some m: Match | isMatch[m]} for {
    Element = `M0 + `M1 + `M2 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2
    Woman = `W0 + `W1 + `W2
    preferences = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 3 -> `W2 +
                    `M1 -> 1 -> `W0 + `M1 -> 2 -> `W1 + `M1 -> 3 -> `W2 +
                    `M2 -> 1 -> `W1 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W2 +
                    `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
                    `W1 -> 1 -> `M0 + `W1 -> 2 -> `M1 + `W1 -> 3 -> `M2 +
                    `W2 -> 1 -> `M1 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M2
    match = `M0 -> `W0 + `M1 -> `W1 + `M2 -> `W1 +
            `W2 -> `M0 + `W1 -> `M1 + `W0 -> `M2
}

// Cannot have more/less than 3 matches for both sides
example mustHaveThreeMatches is not {some m: Match | isMatch[m]} for {
    Element = `M0 + `M1 + `M2 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2
    Woman = `W0 + `W1 + `W2
    preferences = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 3 -> `W2 +
                    `M1 -> 1 -> `W0 + `M1 -> 2 -> `W1 + `M1 -> 3 -> `W2 +
                    `M2 -> 1 -> `W1 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W2 +
                    `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
                    `W1 -> 1 -> `M0 + `W1 -> 2 -> `M1 + `W1 -> 3 -> `M2 +
                    `W2 -> 1 -> `M1 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M2
    match = `M0 -> `W0 + `M1 -> `W1 + `M2 -> `W1 +
            `W2 -> `M0 + `W1 -> `M1
}
