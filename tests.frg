#lang forge
open "definitions.frg"

// all Men and Women are matched with their top preference
example allGetFirstChoice is {some m: Match | stableMatch[m]} for {
    Element = `M0 + `M1 + `M2 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2
    Woman = `W0 + `W1 + `W2
    preferences = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 3 -> `W2 +
                    `M1 -> 1 -> `W1 + `M1 -> 2 -> `W2 + `M1 -> 3 -> `W0 +
                    `M2 -> 1 -> `W2 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W1 +
                    `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
                    `W1 -> 1 -> `M1 + `W1 -> 2 -> `M2 + `W1 -> 3 -> `M0 +
                    `W2 -> 1 -> `M2 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M1
    match = `M0 -> `W0 + `M1 -> `W1 + `M2 -> `W2 + 
            `W0 -> `M0 + `W1 -> `M1 + `W2 -> `M2 
}

example twoPeopleSamePreferences is {some m: Match | stableMatch[m]} for {
    Element = `M0 + `M1 + `M2 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2
    Woman = `W0 + `W1 + `W2
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

// three Women are matched to only two Men
example matchedMultipleTimes is not {some m: Match | isMatch[m]} for {
    Element = `M0 + `M1 + `M2 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2
    Woman = `W0 + `W1 + `W2
    preferences = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 3 -> `W2 +
                    `M1 -> 1 -> `W1 + `M1 -> 2 -> `W2 + `M1 -> 3 -> `W0 +
                    `M2 -> 1 -> `W2 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W1 +
                    `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
                    `W1 -> 1 -> `M1 + `W1 -> 2 -> `M2 + `W1 -> 3 -> `M0 +
                    `W2 -> 1 -> `M2 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M1
    match = `M0 -> `W0 + `M1 -> `W1 + `M2 -> `W2 + 
            `W0 -> `M0 + `W1 -> `M0 + `W2 -> `M2 
}

// a Man has a preference ranked 5 when there are only 3 Men and 3 Women
example numbersOutOfBounds is not {some m: Match | wellformed[m]} for {
    Element = `M0 + `M1 + `M2 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2
    Woman = `W0 + `W1 + `W2
    preferences = `M0 -> 1 -> `W0 + `M0 -> 2 -> `W1 + `M0 -> 5 -> `W2 +
                    `M1 -> 1 -> `W1 + `M1 -> 2 -> `W2 + `M1 -> 3 -> `W0 +
                    `M2 -> 1 -> `W2 + `M2 -> 2 -> `W0 + `M2 -> 3 -> `W1 +
                    `W0 -> 1 -> `M0 + `W0 -> 2 -> `M1 + `W0 -> 3 -> `M2 +
                    `W1 -> 1 -> `M1 + `W1 -> 2 -> `M2 + `W1 -> 3 -> `M0 +
                    `W2 -> 1 -> `M2 + `W2 -> 2 -> `M0 + `W2 -> 3 -> `M1
}

// one more Man than Woman 
example diffNumOfMenWomen is not {some m: Match | wellformed[m]} for {
    Element = `M0 + `M1 + `M2 + `M3 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2 + `M3
    Woman = `W0 + `W1 + `W2
}

// Men prefer Men and Women prefer Women
example sameGenderPreferences is not {some m: Match | wellformed[m]} for {
    Element = `M0 + `M1 + `M2 + `W0 + `W1 + `W2
    Match = `Match0
    Man = `M0 + `M1 + `M2
    Woman = `W0 + `W1 + `W2
    preferences = `M0 -> 1 -> `M0 + `M0 -> 2 -> `M1 + `M0 -> 3 -> `M2 +
                    `M1 -> 1 -> `M1 + `M1 -> 2 -> `M2 + `M1 -> 3 -> `M0 +
                    `M2 -> 1 -> `M2 + `M2 -> 2 -> `M0 + `M2 -> 3 -> `M1 +
                    `W0 -> 1 -> `W0 + `W0 -> 2 -> `W1 + `W0 -> 3 -> `W2 +
                    `W1 -> 1 -> `W1 + `W1 -> 2 -> `W2 + `W1 -> 3 -> `W0 +
                    `W2 -> 1 -> `W2 + `W2 -> 2 -> `W0 + `W2 -> 3 -> `W1
    match = `M0 -> `M0 + `M1 -> `M1 + `M2 -> `M2 + 
            `W0 -> `W0 + `W1 -> `W1 + `W2 -> `W2 
}