// Created by Leopold Lemmermann on 08.03.26.

public extension Almost {
  static let previewData: [Almost] = [
    Almost(
      text: "Packed for the trip at the last minute and almost forgot my passport on the kitchen table.",
      failures: [.forgetting, .poorPreparation],
      triggers: [.rushedMorning],
      contexts: [.atHome, .beforeLeaving],
      states: [.rushed]
    ),
    Almost(
      text: "Rushed out the door without checking my bag and almost arrived at university without my laptop.",
      failures: [.forgetting],
      triggers: [.rushedMorning, .noChecklist],
      contexts: [.beforeLeaving, .commuting],
      states: [.rushed]
    ),
    Almost(
      text: "Forgot to charge my headphones and almost had no audio for the train ride to campus.",
      failures: [.forgetting, .poorPreparation],
      triggers: [.noChecklist],
      contexts: [.commuting],
      states: [.rushed]
    ),
    Almost(
      text: "Stayed on my phone too long at night and almost overslept for my morning run.",
      failures: [.lateness],
      triggers: [.lateNight],
      contexts: [.bedtime, .workout],
      states: [.tired]
    ),
    Almost(
      text: "Watched videos too late and almost slept through my alarm before work.",
      failures: [.lateness],
      triggers: [.lateNight],
      contexts: [.bedtime, .workday],
      states: [.tired]
    ),
    Almost(
      text: "Tried to do three things at once while cooking and almost let the pan burn.",
      failures: [.distraction, .overload],
      triggers: [.multitasking],
      contexts: [.atHome],
      states: [.distracted]
    )
  ]
}
