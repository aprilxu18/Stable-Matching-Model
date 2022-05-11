#lang forge
open "definitions.frg"

option problem_type temporal
option max_tracelength 14

// Start of Gale-Shapley: no man has proposed to any woman yet, and no matches have been made
pred start {
  // no one should currently have a match
  no match
  // no one should have proposed to anyone yet
  no proposed
}

// enforce that preferences always remain the same over a trace
pred samePreferences {
  preferences' = preferences
}

// get a set of free elements
fun getFreeElts[m: Match]: set Element {
  {a: m.groupA | no a.match}
}

// get the preferences of an element
fun getPreferences[e: Element]: set Element {
  Int.(e.preferences)
}

// get ranking of a candidate for an element
fun getRanking[e: Element, other: Element]: Int {
  (e.preferences).other
}

// TODO: WE SUCK AT NAMES
pred prefersAnotherOverMatch[e: Element, a: Element] {
  // if no match, vacuously true
  (no e.match) or (getRanking[e, a] < getRanking[e, e.match])
}

// get highest unproposed candidate for an element
fun highestUnproposed[e: Element]: Element {
  // for e's preferences, get the element that
  let prefs = getPreferences[e] | {
    {highest: prefs | {
      // has not yet been proposed to
      highest not in e.proposed
      // no other unproposed element has a higher ranking
      no other: (prefs - e.proposed) | {
        getRanking[e, other] < getRanking[e, highest]
      }
    }}
  }
}

// potentially assign a matching for the free element
pred matchFreeElt[m: Match, free: Element] {
  // given the most preferred unproposed candidate for `free`:
  let candidate = highestUnproposed[free] | {
    // if the highest ranked unproposed candidate also prefers free over its current match:
    // prefersAnotherOverMatch[candidate, free] => {
    //   // potentially remove the candidate's current match, and add the match here
    //   some candidate.match => {
    //     match' = match + (free->candidate) + (candidate->free) - (candidate->(candidate.match))
    //   } else {
    //     match' = match + (free->candidate) + (candidate->free)
    //   }
    // } else {
    //   // otherwise, don't do anything
    //   match' = match
    // }

    // add to proposed values
    // proposed' = proposed + (free->candidate)
    proposed' = proposed
  }
}

pred galeShapley[m: Match] {
  let freeElts = getFreeElts[m] | {
    some freeElts => {
      one f: freeElts | {
        matchFreeElt[m, f]
      }
      // let f = {one e: Element | e in freeElts} | {
      //   matchFreeElt[m, f]
      // }
    }
    // TODO: do nothing ?
  }

  // TODO: is this necessary?
  preferences' = preferences
}

// End of Gale-Shapley: no man is free / has anyone to propose to
pred done[m: Match] {
  // TODO: here or elsewhere?
  isMatch[m]

  // no man is free
  all a: m.groupA | {
    some a.match
  }
}

// generate traces of Gale-Shapley
pred traces {
  // enforce that at the start, there are no matches and no proposed
  start
  // preferences must remain the same, and matches must always be well-formed
  always samePreferences
  all m: Match | always wellformed[m]

  // run da algorithm
  // all m: Match | (galeShapley[m] until done[m])
  some m: Match, f: Element | (matchFreeElt[m, f])
}

run {
  traces
} for three_people