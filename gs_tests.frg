#lang forge
open "definitions.frg"
open "gale_shapley.frg"

option problem_type temporal
option max_tracelength 14

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
    } is sat
}

// example constantPref is samePreferences for {
//     Man = `M0 + `M1 + `M2
//     Woman = `W0 + `W1 + `W2
//     Element = Man + Woman
//     preferences = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 3 -> `W2 +
//                 `M1 -> 1 -> `W0 + `M1 -> 2 -> `W1 + `M1 -> 3 -> `W2 +
//                 `M2 -> 1 -> `W1 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W2 +
//                 `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
//                 `W1 -> 1 -> `M0 + `W1 -> 2 -> `M1 + `W1 -> 3 -> `M2 +
//                 `W2 -> 1 -> `M1 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M2
//     preferences' = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 3 -> `W2 +
//                 `M1 -> 1 -> `W0 + `M1 -> 2 -> `W1 + `M1 -> 3 -> `W2 +
//                 `M2 -> 1 -> `W1 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W2 +
//                 `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
//                 `W1 -> 1 -> `M0 + `W1 -> 2 -> `M1 + `W1 -> 3 -> `M2 +
//                 `W2 -> 1 -> `M1 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M2
//     // Element = `M0 + `M1 + `W0 + 
// } 

// run {
//     some m0, m1, m2: Man, w0, w1, w2: Woman | {
//             preferences = m0 -> 1 -> w0 + m0 -> 2 -> w1 + m0 -> 3 -> w2 +
//                 m1 -> 1 -> w0 + m1 -> 2 -> w1 + m1 -> 3 -> w2 +
//                 m2 -> 1 -> w1 + m2 -> 2 -> w0 + m2 -> 3 -> w2 +
//                 w0 -> 1 -> m0 + w0 -> 2 -> m1 + w0 -> 3 -> m2 +
//                 w1 -> 1 -> m0 + w1 -> 2 -> m1 + w1 -> 3 -> m2 +
//                 w2 -> 1 -> m1 + w2 -> 2 -> m0 + w2 -> 3 -> m2
//             preferences' = m0 -> 1 -> w1 + m0 -> 2 -> w2 + m0 -> 3 -> w0 +
//                 m1 -> 1 -> w1 + m1 -> 2 -> w1 + m1 -> 3 -> w1 +
//                 m2 -> 1 -> w1 + m2 -> 2 -> w0 + m2 -> 3 -> w2 +
//                 w0 -> 1 -> m0 + w0 -> 2 -> m1 + w0 -> 3 -> m2 +
//                 w1 -> 1 -> m0 + w1 -> 2 -> m1 + w1 -> 3 -> m2 +
//                 w2 -> 1 -> m1 + w2 -> 2 -> m0 + w2 -> 3 -> m2
//             samePreferences
// }
// }