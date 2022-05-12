#lang forge
open "rh_definitions.frg"

// start of gale shapley is as before: no matches nor propositions yet
pred start {
  no matches
  no proposed
}

// preferences and capacities are invariant over time
pred invariants {
  preferences = preferences'
  capacity = capacity'
}

// get all doctors that are free
fun getFreeDoctors[m: RHMatch]: set Doctor {
  {d: m.doctors | no d.matches}
}

// get the preferences of an element
fun getPreferences[e: RHElement]: set RHElement {
  Int.(e.preferences)
}

// get ranking of a candidate for an element; could be null!
fun getRanking[e: RHElement, other: RHElement]: Int {
  (e.preferences).other
}

// check whether an element e prefers an element a overr its current match (e.match)
pred prefersAnotherOverMatch[e: RHElement, a: RHElement] {
  // if no match, vacuously true
  (no e.match) or (getRanking[e, a] < getRanking[e, e.match])
}

// rip no time :(