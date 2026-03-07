// Created by Leopold Lemmermann on 07.03.26.

import Foundation

public struct Almost: Codable, Identifiable, Hashable, Sendable {
  public let id: String
  public let createdAt: Date

  public var text: String
  public var failureModes: Set<Failure>
  public var triggers: Set<Trigger>
  public var contexts: Set<Context>
  public var states: Set<State>

  public init(
    id: String = UUID().uuidString,
    createdAt: Date = .now,
    text: String,
    failureModes: Set<Failure> = [],
    triggers: Set<Trigger> = [],
    contexts: Set<Context> = [],
    states: Set<State> = []
  ) {
    self.id = id
    self.createdAt = createdAt

    self.text = text
    self.failureModes = failureModes
    self.triggers = triggers
    self.contexts = contexts
    self.states = states
  }
}

public extension Almost {
  enum Failure: String, Codable, CaseIterable, Sendable {
    case lateness
    case forgetting
    case poorPreparation
    case avoidance
    case distraction
    case overload
    case unclearPlan
    case lowEnergy
  }

  enum Trigger: String, Codable, CaseIterable, Sendable {
    case rushedMorning
    case lateNight
    case transition
    case hunger
    case fatigue
    case stress
    case interruption
    case multitasking
    case noChecklist
    case noBuffer
  }

  enum Context: String, Codable, CaseIterable, Sendable {
    case atHome
    case beforeLeaving
    case commuting
    case workday
    case travelDay
    case meeting
    case workout
    case meal
    case bedtime
    case studySession
  }

  enum State: String, Codable, CaseIterable, Sendable {
    case tired
    case rushed
    case stressed
    case distracted
    case hungry
    case overwhelmed
    case calm
  }
}

public extension Almost {
  static let minimumPatternOverlapScore = 4

  func overlapScore(with other: Self) -> Int {
    let sharedFailures = failureModes.intersection(other.failureModes).count
    let sharedTriggers = triggers.intersection(other.triggers).count
    let sharedContexts = contexts.intersection(other.contexts).count
    let sharedStates = states.intersection(other.states).count

    return sharedFailures * 3
      + sharedTriggers * 2
      + sharedContexts * 2
      + sharedStates
  }

  func isRelated(
    to other: Self,
    minimumScore: Int = Self.minimumPatternOverlapScore
  ) -> Bool {
    overlapScore(with: other) >= minimumScore
  }
}
