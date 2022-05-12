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

## Understanding the Model + Visualization