// Created by Leopold Lemmermann on 07.03.26.

import Foundation

public typealias Pattern = [Almost]

public extension Pattern {
  var isValid: Bool { count >= 2 }

  var score: Int {
    guard isValid else { return 0 }

    var total = 0

    for i in indices {
      for j in index(after: i)..<endIndex {
        total += self[i].overlapScore(with: self[j])
      }
    }

    return total
  }

  var createdAtRange: ClosedRange<Date>? {
    guard
      let minDate = map(\.createdAt).min(),
      let maxDate = map(\.createdAt).max()
    else { return nil }

    return minDate...maxDate
  }
}

public extension Almost {
  func overlapScore(with other: Self) -> Int {
    let sharedFailures = failures.intersection(other.failures).count
    let sharedTriggers = triggers.intersection(other.triggers).count
    let sharedContexts = contexts.intersection(other.contexts).count
    let sharedStates = states.intersection(other.states).count

    return sharedFailures * 3
    + sharedTriggers * 2
    + sharedContexts * 2
    + sharedStates
  }

  func isRelated(to other: Self, minimumScore: Int) -> Bool {
    overlapScore(with: other) >= minimumScore
  }
}

public extension [Almost] {
  func patterns(minimumScore: Int, minimumPatternSize: Int = 2) -> [Pattern] {
    guard count >= minimumPatternSize else { return [] }

    let adjacency = makeAdjacency(minimumScore: minimumScore)
    let components = connectedComponents(using: adjacency)

    return components
      .filter { $0.count >= minimumPatternSize }
      .sorted(by: Self.patternSort)
  }

  private func makeAdjacency(minimumScore: Int) -> [Int: Set<Int>] {
    var adjacency = Dictionary(uniqueKeysWithValues: indices.map { ($0, Set<Int>()) })

    for i in indices {
      for j in index(after: i)..<endIndex where self[i].isRelated(to: self[j], minimumScore: minimumScore) {
        adjacency[i, default: []].insert(j)
        adjacency[j, default: []].insert(i)
      }
    }

    return adjacency
  }

  private func connectedComponents(using adjacency: [Int: Set<Int>]) -> [Pattern] {
    var visited = Set<Int>()
    var components: [Pattern] = []

    for start in indices where !visited.contains(start) {
      let component = component(startingAt: start, using: adjacency, visited: &visited)

      if component.isValid {
        components.append(component)
      }
    }

    return components
  }

  private func component(
    startingAt start: Int,
    using adjacency: [Int: Set<Int>],
    visited: inout Set<Int>
  ) -> Pattern {
    var stack = [start]
    var component: Pattern = []

    while let current = stack.popLast() {
      guard visited.insert(current).inserted else { continue }

      component.append(self[current])

      let unvisitedNeighbors = adjacency[current, default: []]
        .filter { !visited.contains($0) }

      stack.append(contentsOf: unvisitedNeighbors)
    }

    return component
  }

  private static func patternSort(lhs: Pattern, rhs: Pattern) -> Bool {
    if lhs.score != rhs.score {
      return lhs.score > rhs.score
    }

    return (lhs.createdAtRange?.upperBound ?? .distantPast) >
    (rhs.createdAtRange?.upperBound ?? .distantPast)
  }
}
