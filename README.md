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

### Target/Foundation Goals: Stable Matching Problem and Gale-Shapley

Our goals did change a bit from our proposal. As previously mentioned, Forge
being unable to support higher order quantification placed limits on what 
we would be able to accomplish in our foundation and target goal.

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
    as well; our Gale-Shapley algorithm can only run over a single `Match`, and we cannot
    generate two instances of `Match`es and compare their values: the algorithm could stop before
    generating another `Match`, and Forge wouldn't be able to distinguish between the two separate
    instances. Finally, establishing a bijection between two Matches also proved
    to be quite difficult, and we couldn't figure out how to map one element to another while
    preserving their relative preferences and matches.

We were, however, able to implement the Gale-Shapley algorithm and verify additional properties not
in our original goals. Specifically, we showed that Gale-Shapley always made progress:
- the number of proposals is monotonically increasing: the Gale-Shapley algorithm never fails to
    make proposals or decreases, until the algorithm is finished.
- the number of matches is also monotonically increasing: the Gale-Shapley algorithm never removes
    the total number of matches; even if an existing match is removed, another match will always be
    added.

We were also able to verify that the Gale-Shapley indeed terminates, that in the end everyone gets
married, and that it produces a valid and stable matching.

### Reach Goal: Rural Hospitals Theorem

Our original intent was to provide an extension over our normal stable matching problem definitions
in order to model the [Rural Hospitals Theorem](https://en.wikipedia.org/wiki/Rural_hospitals_theorem). This turned out to be rather 
tricky, as there were some fundamental differences between the two problems:
- What it meant for the initial set-up to be "wellformed" differed between the stable matching
    problem and the rural hospitals problem: in the prior, everyone in one group (i.e. men) had to
    have a preference for everyone in the other group (i.e. women), while in the latter, not every
    doctor needed a preference for every hospital, and vice versa.
- Similarly, the meaning of a valid "Match" was different: in the stable matching problem, every man
    had to have a match with one and only one woman, and no individual could have no matches.
    However, in the rural hospitals problem, every doctor could have either 0 or 1 matches, and
    every hospital's number of matches was limited only by their capacity and the total number of
    doctors; thus, it was valid for one hospital to be matched with 3 doctors and another to be
    matched with none, and for a doctor to have no matches.
- Finally, a stable matching had a different meaning as well. Because of the situation listed above,
    a stable matching in the rural hospitals problem instead required that:
    - if a doctor is matched to a hospital, the hospital doesn't prefer any other doctor over the
        current doctor; and if the doctor isn't matched to a hospital, there is no hospital that
        *has* capacity and *isn't* matched to the doctor.

Additionally, each element now had to support a variable number of matches, rather than just `0` or
`1`, and hospitals had a capacity value. Thus, we ended up coming up with new `sig`s and predicates
for this problem.

In the end, we were able to complete half of our reach goal: we successfully modeled the problem of
the rural hospitals theorem, and verified correctness of our predicates (like before, we were unable
to verify the existence and uniqueness of a stable matching, due to Forge's lack of higher-order
quantification). However, the extension to Gale-Shapley's algorithm that supported the rural
hospitals theorem proved a lot trickier than we had imagined, as significant modifications had to be
made when determining whether to assign a doctor to a hospital or switch a doctor-hospital matching
with another matching.

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

## Link to Demo Video!
https://drive.google.com/file/d/1mSPoOqqK9pDgTn3JSfLjHOIq3LfQ5WDk/view?usp=sharing

