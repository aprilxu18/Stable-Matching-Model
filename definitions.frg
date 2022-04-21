#lang forge

abstract sig Person {
  preferences: set Int -> Person,
}

sig Men extends Person {}
sig Women extends Person {}

pred wellformed {
  all m: Men | {
    #{i: Int | i in m.preferences} = #{w: Women | w in Women}
  }
}

run {
  wellformed
} for exactly 3 Men