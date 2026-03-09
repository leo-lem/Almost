// Created by Leopold Lemmermann on 09.03.26.

import Foundation
import UserNotifications

@MainActor
public final class Notifications {
  public static let shared = Notifications()

  private let center = UNUserNotificationCenter.current()

  private enum NotificationID {
    static let reviewReminder = "review-reminder"
  }

  private init() {}

  public func refreshReviewReminder(openPatternCount: Int) async {
    if openPatternCount > 0 {
      await scheduleReviewReminder(openPatternCount: openPatternCount)
    } else {
      removeReviewReminder()
    }
  }

  public func removeReviewReminder() {
    center.removePendingNotificationRequests(withIdentifiers: [NotificationID.reviewReminder])
  }

  private func scheduleReviewReminder(openPatternCount: Int) async {
    let content = UNMutableNotificationContent()
    content.title = String(localized: .reviewPatternsInAlmosts)
    content.body = String(localized: .youHaveNewPatternsInAlmost(openPatternCount))
    content.sound = .default
    content.userInfo = ["destination": "review"]

    // Sunday 10:00
    var date = DateComponents()
    date.weekday = 1
    date.hour = 10
    date.minute = 0

    #if DEBUG
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    #else
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
    #endif

    let request = UNNotificationRequest(
      identifier: NotificationID.reviewReminder,
      content: content,
      trigger: trigger
    )

    do {
      removeReviewReminder()
      try await center.add(request)
    } catch {
      assertionFailure("Failed to schedule review reminder: \(error.localizedDescription)")
    }
  }
}

extension Notification.Name {
  static let openReviewFromNotification = Notification.Name("openReviewFromNotification")
}
