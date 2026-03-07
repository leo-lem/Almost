// Created by Leopold Lemmermann on 07.03.26.

import FoundationModels
import Playgrounds

@Generable
enum FailureMode: String {
    case lateness
    case forgetting
    case poorPreparation
    case avoidance
    case distraction
    case overload
    case unclearPlan
    case lowEnergy
}

@Generable
enum Trigger: String {
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

@Generable
enum ContextTag: String {
    case atHome
    case commuting
    case beforeLeaving
    case workday
    case travelDay
    case meeting
    case workout
    case meal
    case bedtime
    case studySession
}

@Generable
enum StateTag: String {
    case tired
    case rushed
    case stressed
    case distracted
    case hungry
    case overwhelmed
    case calm
}

@Generable
struct AlmostTags {
    @Guide(description: "The main structural ways this near miss happened. Pick only the most relevant ones.")
    let failureModes: [FailureMode]

    @Guide(description: "What most likely triggered or preceded the near miss. Pick only the most relevant ones.")
    let triggers: [Trigger]

    @Guide(description: "The situational context in which this happened.")
    let contexts: [ContextTag]

    @Guide(description: "The person's internal state during the near miss.")
    let states: [StateTag]
}

// swiftlint:disable line_length
#Playground {
    let model = SystemLanguageModel.default

    let testInputs = [
        "Almost missed my dentist appointment because I left home too late after underestimating how long getting ready would take.",
        "Skipped lunch, got really low on energy in the afternoon, and almost snapped at a coworker in a meeting.",
        "Packed for the trip at the last minute and almost forgot my passport on the kitchen table.",
        "Stayed on my phone too long at night and almost overslept for my morning run.",
        "Put off replying to Marcus again because I did not know exactly what to say and almost missed the payment follow-up window.",
        "Tried to do three things at once while cooking and almost let the pan burn.",
        "Forgot to charge my headphones and almost had no audio for the train ride to campus.",
        "Agreed to another evening plan even though I was already tired and almost bailed on my workout the next morning.",
        "Rushed out the door without checking my bag and almost arrived at university without my laptop.",
        "Kept tweaking the presentation too long instead of rehearsing and almost ran out of time before leaving."
    ]
    // swiftlint:enable line_length

    for input in testInputs {
        let session = LanguageModelSession(
            model: model,
            instructions: """
        You classify short near-miss notes into structured tags.
        
        Rules:
        - Only use the provided enum values.
        - Choose only tags clearly supported by the text.
        - Keep the result sparse and conservative.
        - Prefer 1 to 3 items per field.
        - Do not infer elaborate psychology or hidden causes.
        """
        )

        let response = try await session.respond(
            to: """
            Classify this near miss note into the schema.
            
            Note: \(input)
            """,
            generating: AlmostTags.self
        )

        print(response.content)
    }
}
