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
- no longer checking for uniqueness of matching

## Understanding the Model + Visualization