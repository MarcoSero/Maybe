// Re-implementation of the Optional type

enum Maybe<T> {
  
  case Nothing
  case Just(T)
  
  init(fromOptional optional: Optional<T>) {
    switch(optional) {
    case .None: self = .Nothing
    case let .Some(value): self = .Just(value)
    }
  }
  
  func map<U>(@noescape transform: T -> U) -> Maybe<U> {
    switch (self) {
    case .Nothing: return .Nothing
    case let .Just(value): return .Just(transform(value))
    }
  }
  
  func flatMap<U>(@noescape transform: T -> Maybe<U>) -> Maybe<U> {
    switch (self) {
    case .Nothing: return .Nothing
    case let .Just(value): return transform(value)
    }
  }
  
}

infix operator >>- {
  associativity left
  precedence 120
}
func >>- <T, U>(lhs: Maybe<T>, @noescape rhs: (T -> Maybe<U>)) -> Maybe<U> {
  return lhs.flatMap(rhs)
}

// Just some utility functions to play with it
extension Int {
  static func fromString(string: String) -> Maybe<Int> {
    return Maybe(fromOptional: Int(string))
  }
}

func divideBy(divisor: Int)(number: Int) -> Maybe<Int> {
  if divisor == 0 {
    return .Nothing
  }
  return .Just(number / divisor)
}

// Let's play

// map
var maybeInt: Maybe<Int> = .Just(3)
maybeInt = maybeInt.map{ $0 + 2 }
maybeInt

// flatMap
let maybeString: Maybe<String> = .Just("20")
maybeInt = maybeString.flatMap(Int.fromString)
// with the bind operator
maybeInt = .Just("20") >>- Int.fromString >>- divideBy(10)
maybeInt = .Just("20") >>- Int.fromString >>- divideBy(0)
