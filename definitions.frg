#lang forge

abstract sig Person {
  preferences: set Int -> Person
}

sig Men extends Person {}
sig Women extends Person {}

pred wellformed {
  all m: Men | {
    Int.(m.preferences) = Women

  }

  all w: Women | {
    Int.(w.preferences) = Men
  }

  // #{Women} = #{Men}
}

run {
  wellformed
} for exactly 3 Men, exactly 3 Women