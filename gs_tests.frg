#lang forge
open "definitions.frg"
open "gale_shapley.frg"

test expect {
    // preferences stay the same
    constantPrefs: {
        some m0, m1, m2: Man, w0, w1, w2: Woman | {
            preferences = m0 -> 1 -> w0 + m0 -> 2 -> w1 + m0 -> 3 -> w2 +
                m1 -> 1 -> w0 + m1 -> 2 -> w1 + m1 -> 3 -> w2 +
                m2 -> 1 -> w1 + m2 -> 2 -> w0 + m2 -> 3 -> w2 +
                w0 -> 1 -> m0 + w0 -> 2 -> m1 + w0 -> 3 -> m2 +
                w1 -> 1 -> m0 + w1 -> 2 -> m1 + w1 -> 3 -> m2 +
                w2 -> 1 -> m1 + w2 -> 2 -> m0 + w2 -> 3 -> m2
            preferences' = m0 -> 1 -> w0 + m0 -> 2 -> w1 + m0 -> 3 -> w2 +
                m1 -> 1 -> w0 + m1 -> 2 -> w1 + m1 -> 3 -> w2 +
                m2 -> 1 -> w1 + m2 -> 2 -> w0 + m2 -> 3 -> w2 +
                w0 -> 1 -> m0 + w0 -> 2 -> m1 + w0 -> 3 -> m2 +
                w1 -> 1 -> m0 + w1 -> 2 -> m1 + w1 -> 3 -> m2 +
                w2 -> 1 -> m1 + w2 -> 2 -> m0 + w2 -> 3 -> m2
            samePreferences
        }
    } is sat

    onePrefChanges: {
        some m0, m1, m2: Man, w0, w1, w2: Woman | {
            m0 != m1
            m1 != m2
            m0 != m2
            w0 != w1
            w1 != w2
            w0 != w2

            m0.preferences = (1->w0) + (2->w1) + (3->w2)
            m1.preferences = (1->w0) + (2->w1) + (3->w2)
            m2.preferences = (1->w0) + (2->w1) + (3->w2)
            w0.preferences = (1->m0) + (2->m1) + (3->m2)
            w1.preferences = (1->m0) + (2->m1) + (3->m2)
            w2.preferences = (1->m0) + (2->m1) + (3->m2)
            m0.preferences' = (1->w1) + (2->w2) + (3->w0)
            m1.preferences' = (1->w0) + (2->w1) + (3->w2)
            m2.preferences' = (1->w0) + (2->w1) + (3->w2)
            w0.preferences' = (1->m0) + (2->m1) + (3->m2)
            w1.preferences' = (1->m0) + (2->m1) + (3->m2)
            w2.preferences' = (1->m0) + (2->m1) + (3->m2)
            samePreferences
        }
    } is unsat

    // number of proposals is monotonically increasing:
    // - if algorithm is still matching, proposed must increase
    // - otherwise, proposed should stay the same
    numProposalsAlwaysIncrease: {
      all m: Match | traces => always {
        some getFreeElts[Match] => {
          (proposed in proposed') and (proposed != proposed')
        } else {
          proposed = proposed'
        }
      }
    } for exactly 1 Match is theorem

    // numMatchesAlwaysIncrease: {

    // }

    // When running the algorithm, if we get A ==matched to==> B, then:
    // - we must have B ==matched to==> A
    // - there cannot be any C such that C==matched to==>B as well
    atMostOneMatch: {
      all m: Match | traces => always {
        all e: Element | some e.match => {
          one f: Element | f.match = e
        }
      }
    } for exactly 1 Match is theorem

    // gale-shapley produces a match
    makesMatch: {
      all m: Match | traces => eventually isMatch[Match]
    } for exactly 1 Match is theorem // restrict matches to prevent huge search space

    // gale-shapley's match is stable
    makesStableMatch: {
      all m: Match | traces => eventually stableMatch[Match]
    } for exactly 1 Match is theorem // restrict matches to prevent huge search space
}
