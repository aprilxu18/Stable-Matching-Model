#lang forge
open "rh_definitions.frg"

// test well-formedness when each doctor has preferences for all hospitals, and vice versa
example basicWF is {RHWellformed[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1 + `D2
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0 + `D0 -> 2 -> `H1
              + `D1 -> 2 -> `H0 + `D1 -> 1 -> `H1
              + `D2 -> 1 -> `H0 + `D2 -> 2 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1 + `H0 -> 3 -> `D2
              + `H1 -> 3 -> `D0 + `H1 -> 2 -> `D1 + `H1 -> 1 -> `D2

  capacity = `H0 -> 1 + `H1 -> 1
}

// test well-formedness when doctors don't have preferences for all hospitals
example doctorsNotAllPrefsWF is {RHWellformed[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1 + `D2
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0
              + `D1 -> 1 -> `H1
              + `D2 -> 1 -> `H0
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1 + `H0 -> 3 -> `D2
              + `H1 -> 3 -> `D0 + `H1 -> 2 -> `D1 + `H1 -> 1 -> `D2

  capacity = `H0 -> 1 + `H1 -> 1
}

// test well-formedness when hospitals don't have preferences for all doctors
example hospitalsNotAllPrefsWF is {RHWellformed[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1 + `D2
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0 + `D0 -> 2 -> `H1
              + `D1 -> 2 -> `H0 + `D1 -> 1 -> `H1
              + `D2 -> 1 -> `H0 + `D2 -> 2 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1
              + `H1 -> 2 -> `D1 + `H1 -> 1 -> `D2

  capacity = `H0 -> 1 + `H1 -> 1
}

// test well-formedness when neither hospitals nor doctors have all preferences
example neitherAllPrefWF is {RHWellformed[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1 + `D2
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0
              + `D1 -> 1 -> `H1
              + `D2 -> 1 -> `H0 + `D2 -> 2 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1
              + `H1 -> 2 -> `D1 + `H1 -> 1 -> `D2

  capacity = `H0 -> 1 + `H1 -> 1
}


// for each matching below, we assume stability as well (to test both at once without too much repetition);
// we will explicitly indicate when something is a matching, but not stable


// basic matching: 2 doctors 2 hospitals, each with capacity 1
example basicRHM is {stableRHMatch[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0 + `D0 -> 2 -> `H1
              + `D1 -> 2 -> `H0 + `D1 -> 1 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1
              + `H1 -> 2 -> `D0 + `H1 -> 1 -> `D1

  capacity = `H0 -> 1 + `H1 -> 1

  matches = `D0 -> `H0 + `D1 -> `H1
          + `H0 -> `D0 + `H1 -> `D1
}

// only 1 hospital but with enough capacity matches all doctors
example oneHospitalManyMatches is {stableRHMatch[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0
              + `D1 -> 1 -> `H0
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1

  capacity = `H0 -> 2

  matches = `D0 -> `H0 + `D1 -> `H0
          + `H0 -> `D0 + `H0 -> `D1
}

// only 1 hospital with only one capacity matches just one doctor, but is valid
example oneHospitalOneCapacity is {stableRHMatch[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0
              + `D1 -> 1 -> `H0
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1

  capacity = `H0 -> 1

  matches = `D0 -> `H0
          + `H0 -> `D0
}

// same as above, but if there are two matches, then cannot be a match
example tooMuchCapacity is {not isRHMatch[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0
              + `D1 -> 1 -> `H0
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1

  capacity = `H0 -> 1

  matches = `D0 -> `H0 + `D1 -> `H0
          + `H0 -> `D0 + `H0 -> `D1
}

// with 2 hospitals capacity 2 for each, everyone getting their highest preference is stable
example twoHospitalsBestPrefs is {stableRHMatch[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0 + `D0 -> 2 -> `H1
              + `D1 -> 2 -> `H0 + `D1 -> 1 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1
              + `H1 -> 2 -> `D0 + `H1 -> 1 -> `D1

  capacity = `H0 -> 2 + `H1 -> 2

  matches = `D0 -> `H0 + `D1 -> `H1
          + `H0 -> `D0 + `H1 -> `D1
}

// if both doctors prefer H0 over H1 and H1 enough capacity, then H0 gets both and is stable
example oneHospitalNoMatches is {stableRHMatch[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0 + `D0 -> 2 -> `H1
              + `D1 -> 1 -> `H0 + `D1 -> 2 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1
              + `H1 -> 2 -> `D0 + `H1 -> 1 -> `D1

  capacity = `H0 -> 2 + `H1 -> 2

  matches = `D0 -> `H0 + `D1 -> `H0
          + `H0 -> `D0 + `H0 -> `D1
}

// same setup as above, but if D1 gets matched to H1 instead, not stable
example enoughCapacityUnstable is {isRHMatch[RHMatch] and not isRHStable[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0 + `D0 -> 2 -> `H1
              + `D1 -> 1 -> `H0 + `D1 -> 2 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1
              + `H1 -> 2 -> `D0 + `H1 -> 1 -> `D1

  capacity = `H0 -> 2 + `H1 -> 2

  matches = `D0 -> `H0 + `D1 -> `H1
          + `H0 -> `D0 + `H1 -> `D1
}

// same setup as above, but if enough space and D1 doesn't get matched, not stable
example enoughCapacityNoMatch is {isRHMatch[RHMatch] and not isRHStable[RHMatch]} for {
  RHMatch = `RHM0
  Doctor = `D0 + `D1
  Hospital = `H0 + `H1
  RHElement = Doctor + Hospital
  doctors = `RHM0 -> Doctor
  hospitals = `RHM0 -> Hospital

  preferences = `D0 -> 1 -> `H0 + `D0 -> 2 -> `H1
              + `D1 -> 1 -> `H0 + `D1 -> 2 -> `H1
              + `H0 -> 1 -> `D0 + `H0 -> 2 -> `D1
              + `H1 -> 2 -> `D0 + `H1 -> 1 -> `D1

  capacity = `H0 -> 2 + `H1 -> 2

  matches = `D0 -> `H0
          + `H0 -> `D0
}