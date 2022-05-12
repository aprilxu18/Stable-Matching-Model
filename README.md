# Stable-Matching-Model

## Tradeoffs 
One tradeoff in our Stable Matching Model is that our visualization assumes 
that the two groups in the given `Match` will be `Man` and `Woman`, as 
indicated with `M` and `W` on the nodes. This was done to simplify the 
visualization, as the Gale Shapley algorithm is best known for creating stable
matches between these two groups. However, our model in the code does not 
strictly require `groupA` to consist of elements from the `Man` sig
and `groupB` to consist of elements from the `Woman` sig. Instead, we abstract
this out so that our code could be expanded upon to include other groups. This
is accomplished by creating an abstract sig, `Element`, and having the only 
requirement be that `groupA` and `groupB` are sets consisting of sigs that 
extend the `Element` abstract class.

## Assumptions and Limitations
One key limitation of our model is that Forge is unable to support higher 
order quanitification. As a result, we are unable to verify that a stable 
matching will always exist, regardless of the number of individuals in the
two different groups. Thus, many of our tests are made up of examples, where 
we are able to explicitly define which sigs there are. 

An assumption of our model is that if we have `Man` and `Woman` as our two 
groups, they may only match with and prefer the opposite gender. This does not 
align with how we allow and accept same-sex marriage in modern day society, 
but our model does so in order to better align with the Gale Shapley algorithm,
which requires each group to exhaustively rank their preferences of individuals
in the other group. The alternative to this is that the two groups defined 
would be of the same sex, but this then excludes the possibility of individuals
who are bisexual. Because of the nuances of sexual orientation and gender, our 
model is unable to adequately account for them all.

## Change of Goals
Our goals did change a bit from our proposal. As previously mentioned, Forge
being unable to support higher order quantification placed limits on what 
we would be able to accomplish in our foundation and target goal. Initially, 
we were going to verify that a stable matching will, in a general sense, 
always exist, in addition to modeling the procedure of the Gale Shapley 
algorithm. However, we modified this so that verification occurs for a limited 
number of individuals. 

Another aspect in which our goals changed was with our
target goal; we initially were going to find a way to check if stable matchings
are unique, and this would be accomplished by seeing if the final matches are 
the same for the same instance where the `Man` proposing as the `Woman` 
proposing. However, because of the nature of this algorithm (captured in our 
`matchFreeElt` predicate), it seemed as though Forge would be unable to 
support maintaining all of this information, as these would be two separate 
instances. Consequently, our target goal ended up just being verifying a few 
basic properties of the Gale Shapley algorithm, such as how everyone gets 
married, and matches are stable.

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
For our visualization, the men are represented as blue circles and the women are 
represented as pink circles. All of the circles are labeled repectively. Also,
above each Man and below each Woman are their preferences listed in order
so that a viewer can easily see the rankings of each person. At each
state, the arrow points from a Man to a Woman, indicating the current woman
than a man is proposing to. The arrow changes at every instance since a new
proposal happens at every state until everyone is matched. The purpose of 
showing one arrow at a time is to isolate what is changing at the current state
so the viewer can get a better sense of who is proposing to who at each state. 
