# Stable-Matching-Model

## Tradeoffs 
One tradeoff in our Stable Matching Model is that 

- visualization assumes that the groups in the match will only be man/woman, 
but in our model in the code, we abstract this out so that we can have any 
two groups defined

## Assumptions and Limitations
- limit in the number of men/women, since can't do a higher order


## Change of Goals

### Property Verification

Originally, we wished to verify multiple properties of Gale-Shapley's produced matches:
- Everyone gets married.
- Marriages are stable.
- Produced matches are **man-optimal**, but not **woman-optimal**; that is, Gale-Shapley always
    yields the best results for all men, and worst results for all women.
- Gale-Shapley is truthful for men: no matter how men mis-represent their preferences, they cannot
    get a better result. In contrast, Gale-Shapley is *not* truthful for women: women can
    mis-represent their preferences and get a better result.
- If and only if the man-proposing matching result is identical to the woman-proposing matching
    result, there is a unique matching.

We also wished to verify an inherent property of the problem: a stable matching always exists.

As we've progressed, we've come to realize that some properties aren't entirely modelable using
Forge. In particular:
- verifying that a stable matching always exists for any set of `n` men and `n` women is
    computationally complex; counting *all* potential matchings is `#P`-complete, i.e. it requires
    exponential time to complete. When trying to write a test to verify this property, our Forge ran
    forever without finding a solution; we hypothesize that due to Forge's `is theorem`
    implementation, verifying a stable matching's existence is similarly complex.
        - However, we were able to verify the property with a smaller subset; after setting `n = 3`,
            we were able to prove the property.
- Proving (un)optimality turned out to be impossible given our current set-up and Forge's capabilities. The problem defines optimality as having the best preferences
    for every individual; this could involve computing the sum of each person's preference value for
    their match. However, in Forge everything is a *set*, including `Integers`; thus, it is
    impossible to compute a real sum. That is, `sum[1 + 1 + 1] = 3` is impossible to show (because
    `1 + 1 + 1 = ((1))` in Forge).
- Proving uniqueness of a matching if man-proposing == woman-proposing turned out to be impossible
    as well; because our Gale-Shapley algorithm can only run over a single `Match`, we cannot
    generate two instances of `Match`es and compare their values, as the algorithm would stop before
    generating the other `Match`. Moreover, establishing a bijection between two Matches also proved
    to be quite difficult, and we couldn't figure out how to map one element to another while
    preserving their relative preferences and matches.

We were, however, able to verify additional properties of Gale-Shapley not in our original goals;
namely, Gale-Shapley always makes progress:
- the number of proposals is monotonically increasing: the Gale-Shapley algorithm never fails to
    make proposals or decreases, until the algorithm is finished.
- the number of matches is also monotonically increasing: the Gale-Shapley algorithm never removes
    the total number of matches; even if an existing match is removed, another match will always be
    added.

We were also able to verify that the Gale-Shapley indeed terminates, and always gives a valid and
stable matching.

### Reach Goal: Rural Hospitals Theorem

Our original intent was to provide an extension over our normal stable matching problem definitions
in order to model the [Rural Hospitals Theorem](https://en.wikipedia.org/wiki/Rural_hospitals_theorem).

## Understanding the Model + Visualization
