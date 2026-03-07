// Created by Leopold Lemmermann on 07.03.26.

import FoundationModels
import Playgrounds

@Generable
struct Almost {
    let text: String
    let tags: AlmostTags
}

@Generable
struct RuleSuggestion {
    @Guide(description: "A short summary of the recurring pattern. Max 12 words.")
    let clusterSummary: String

    @Guide(
        description: "One short operational rule. Imperative, concrete, specific. " +
        "Max 12 words. No moralizing, no vague advice."
    )
    let ruleText: String
}

let clusters: [[Almost]] = [
    [
        .init(
            text: "Packed for the trip at the last minute and almost forgot my passport on the kitchen table.",
            tags: .init(
                failureModes: [.forgetting, .poorPreparation],
                triggers: [.rushedMorning],
                contexts: [.atHome, .beforeLeaving],
                states: [.rushed]
            )
        ),
        .init(
            text: "Rushed out the door without checking my bag and almost arrived at university without my laptop.",
            tags: .init(
                failureModes: [.forgetting],
                triggers: [.rushedMorning, .noChecklist],
                contexts: [.beforeLeaving, .commuting],
                states: [.rushed]
            )
        ),
        .init(
            text: "Forgot to charge my headphones and almost had no audio for the train ride to campus.",
            tags: .init(
                failureModes: [.forgetting, .poorPreparation],
                triggers: [.noChecklist],
                contexts: [.commuting],
                states: [.rushed]
            )
        )
    ],
    [
        .init(
            text: "Almost missed dentist appointment because left too late after underestimating getting ready time.",
            tags: .init(
                failureModes: [.lateness],
                triggers: [.rushedMorning],
                contexts: [.commuting],
                states: [.rushed]
            )
        ),
        .init(
            text: "Left the house later than planned and almost missed the train because I had no margin at all.",
            tags: .init(
                failureModes: [.lateness],
                triggers: [.noBuffer],
                contexts: [.beforeLeaving, .commuting],
                states: [.rushed]
            )
        )
    ],
    [
        .init(
            text: "Stayed on my phone too long at night and almost overslept for my morning run.",
            tags: .init(
                failureModes: [.lateness],
                triggers: [.lateNight],
                contexts: [.bedtime, .workout],
                states: [.tired]
            )
        ),
        .init(
            text: "Watched videos too late and almost slept through my alarm before work.",
            tags: .init(
                failureModes: [.lateness],
                triggers: [.lateNight],
                contexts: [.bedtime, .workday],
                states: [.tired]
            )
        )
    ],
    [
        .init(
            text: "Tried to do three things at once while cooking and almost let the pan burn.",
            tags: .init(
                failureModes: [.distraction, .overload],
                triggers: [.multitasking],
                contexts: [.atHome],
                states: [.distracted]
            )
        ),
        .init(
            text: "Answered messages while making coffee and almost left the stove on.",
            tags: .init(
                failureModes: [.distraction],
                triggers: [.multitasking],
                contexts: [.atHome],
                states: [.distracted]
            )
        ),
        .init(
            text: "Started cleaning, cooking, and packing at once and almost forgot food in the oven.",
            tags: .init(
                failureModes: [.overload, .forgetting],
                triggers: [.multitasking],
                contexts: [.atHome],
                states: [.distracted, .rushed]
            )
        ),
        .init(
            text: "Got distracted by my phone while making lunch and almost boiled the pot dry.",
            tags: .init(
                failureModes: [.distraction],
                triggers: [.multitasking],
                contexts: [.atHome, .meal],
                states: [.distracted]
            )
        )
    ]
]

#Playground {
    for (index, cluster) in clusters.enumerated() {
        let session = LanguageModelSession(
            model: .default,
            instructions: """
            You help derive one practical personal rule from a cluster of recurring near-miss entries.
            
            Rules:
            - Base the suggestion only on the provided entries and tags.
            - Prefer concrete operational rules over abstract advice.
            - The rule must be short, specific, and actionable.
            - Do not moralize.
            - Do not explain.
            - Do not mention emotions unless clearly necessary.
            - Good rules sound like small instructions someone can actually follow.
            - If possible, target the repeated mechanism rather than a single event.
            - Do not introduce actions not clearly supported by the entries or tags.
            """
        )

        let response = try await session.respond(
            to: """
            Derive one cluster summary and one suggested rule from these recurring near misses:
            
            \(cluster)
            """,
            generating: RuleSuggestion.self
        )

        print("== Cluster \(index + 1) ==")
        print(response.content)
        print()
    }
}
