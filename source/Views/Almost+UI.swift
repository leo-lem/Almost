// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI

public extension Almost {
  protocol Tagged: Hashable, CaseIterable, RawRepresentable<String>  {
    static var category: String { get }
    static var symbol: String { get }
    static var color: Color { get }
    var label: String { get }
  }
}

public extension Almost.Tagged {
  var symbol: String { Self.symbol }
  var color: Color { Self.color }
}

extension Almost.Failure: Almost.Tagged {
  public static let category = "Failures",
                    symbol = "exclamationmark.triangle.fill",
                    color = Color.orange
  public var label: String {
    switch self {
    case .lateness: "Lateness"
    case .forgetting: "Forgetting"
    case .poorPreparation: "Poor preparation"
    case .avoidance: "Avoidance"
    case .distraction: "Distraction"
    case .overload: "Overload"
    case .unclearPlan: "Unclear plan"
    case .lowEnergy: "Low energy"
    }
  }
}

extension Almost.Trigger: Almost.Tagged  {
  public static let category = "Triggers",
                    symbol = "bolt.fill",
                    color = Color.mint
  public var label: String {
    switch self {
    case .rushedMorning: "Rushed morning"
    case .lateNight: "Late night"
    case .transition: "Transition"
    case .hunger: "Hunger"
    case .fatigue: "Fatigue"
    case .stress: "Stress"
    case .interruption: "Interruption"
    case .multitasking: "Multitasking"
    case .noChecklist: "No checklist"
    case .noBuffer: "No buffer"
    }
  }
}

extension Almost.Context: Almost.Tagged  {
  public static let category = "Contexts",
                    symbol = "square.grid.2x2.fill",
                    color = Color.blue
  public var label: String {
    switch self {
    case .atHome: "At home"
    case .beforeLeaving: "Before leaving"
    case .commuting: "Commuting"
    case .workday: "Workday"
    case .travelDay: "Travel day"
    case .meeting: "Meeting"
    case .workout: "Workout"
    case .meal: "Meal"
    case .bedtime: "Bedtime"
    case .studySession: "Study session"
    }
  }
}

extension Almost.State: Almost.Tagged  {
  public static let category = "States",
                    symbol = "heart.fill",
                    color = Color.pink
  public var label: String {
    switch self {
    case .tired: "Tired"
    case .rushed: "Rushed"
    case .stressed: "Stressed"
    case .distracted: "Distracted"
    case .hungry: "Hungry"
    case .overwhelmed: "Overwhelmed"
    case .calm: "Calm"
    }
  }
}
