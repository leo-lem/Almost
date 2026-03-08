// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI

public extension Almost.Tag {
  var symbol: String {
    switch self {
    case .failure: "exclamationmark.triangle.fill"
    case .trigger: "bolt.fill"
    case .context: "square.grid.2x2.fill"
    case .state: "heart.fill"
    }
  }

  var color: Color {
    switch self {
    case .failure: .orange
    case .trigger: .mint
    case .context: .blue
    case .state: .pink
    }
  }
}

public extension Almost {
  var relativeTimestamp: String {
    RelativeDateTimeFormatter().localizedString(for: createdAt, relativeTo: .now)
  }
}

public protocol Labeled {
  var label: String { get }
}

extension Almost.Failure: Labeled {
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

extension Almost.Trigger: Labeled {
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

extension Almost.Context: Labeled {
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

extension Almost.State: Labeled {
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
