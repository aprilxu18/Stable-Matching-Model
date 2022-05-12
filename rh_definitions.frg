#lang forge

option problem_type temporal
option max_tracelength 14

// almost same structure as before, except we now move
abstract sig RHElement {
  preferences: pfunc Int -> RHElement,
  var matches: set RHElement
}

sig Doctor extends RHElement {
  // record who they have already proposed to
  var proposed: set RHElement
}

sig Hospital extends RHElement {
  // each hospital has a limited capacity
  capacity: one Int
}

sig RHMatch {
  doctors: set Doctor,
  hospitals: set Hospital
}

pred RHWellformed[m: RHMatch] {
  // we have a more concrete situation here, rather than "Elements"
  m.doctors = Doctor
  m.hospitals = Hospital

  // now, no requirements on number of doctors/hospitals; however still must be disjoint
  no m.doctors & m.hospitals

  // enforce that for every doctor:
  all d: m.doctors | {
    // their hospital preferences are strictly ordered from 1 to the number of preferences they have
    // note that #{m.hospitals} != #{d.preferences} necessarily!
    all i: (d.preferences).(m.hospitals) | {
      i >= 1
      i <= #{d.preferences}
    }

    // each doctor's preferences must be in the set of hospitals
    Int.(d.preferences) in m.hospitals
    // number of preferences a doctor has must be <= the total number of hospitals
    #{d.preferences} <= #{m.hospitals}
  }

  // and for every hospital:
  all h: m.hospitals | {
    // the hospitals' preferences for doctors are strictly ordered by the number of preferences they have
    all i: (h.preferences).(m.doctors) | {
      i >= 1
      i <= #{h.preferences}
    }

    // each hospital's preferences must be in the set of doctors
    Int.(h.preferences) in m.doctors
    // number of preferences a hospital has must be <= # doctors
    #{h.preferences} <= #{m.doctors}
  }
}

// enforces that the instance is a RHMatch
pred isRHMatch[m: RHMatch] {
  // for every doctor, it must either have 0 or 1 matches (they cannot be assigned many times)
  all d: m.doctors | {
    #{d.matches} in 0 + 1
    // if matched, the hospital must also have the doctor as one of their matches
    some d.matches => {
      d in (d.matches).matches
    }
  }
  // the doctor's matches must be in the set of hospitals
  m.doctors.matches in m.hospitals

  // for every hospital, it must have between 0 to capacity matches (hospitals cannot have more than
  // a certain amount of matches)
  all h: m.hospitals | {
    #{h.matches} >= 0 and #{h.matches} <= h.capacity
    // every doctor in h's matches is matched to h
    all d: h.matches | {
      d.matches = h
    }
  }

  // the hospital's matches must be in the set of doctors
  m.hospitals.matches in m.doctors
}

// stability is more challenging here, since not everyone has to be matched
pred isRHStable[m: RHMatch] {
  // for every doctor:
  all d: m.doctors | {
    // if they are matched,
    some d.matches => {
      let matchPref = (d.preferences).(d.matches) | {
        // there is no hospital such that:
        no h: m.hospitals | {
          // d prefers h over its match
          (d.preferences).h < matchPref
          // h also prefers d over at least one of its matches
          no d1: h.matches | {
            (h.preferences).d < (h.preferences).d1
          }
        }
      }
    } else {
      // otherwise, if they are not matched, there is no hospital such that:
      no h: m.hospitals | {
        // h prefers d over at least one of its matches
        no d1: h.matches | {
          (h.preferences).d < (h.preferences).d1
        }
      }
    }
  }
}

pred stableRHMatch[m: RHMatch] {
  RHWellformed[m]
  isRHMatch[m]
  isRHStable[m]
}

pred init {
  all m: RHMatch | {
    RHWellformed[m]
  }
}

inst two_doctor_one_hospital {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  capacity = `H0 -> 1
}

run {
  stableRHMatch[RHMatch]
} for two_doctor_one_hospital