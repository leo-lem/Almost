// Created by Leopold Lemmermann on 28.07.25.

import XCTest

final class AlmostUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app.launch()
  }

  override func tearDown() {
    app.terminate()
    super.tearDown()
  }

  func testAppLaunchesWithoutCrashing() {
    XCTAssertTrue(app.state == .runningForeground || app.state == .runningBackground)
  }

  func testMainInterfaceHasUIElements() {
    let exists = app.buttons.count > 0 || app.textFields.count > 0 || app.staticTexts.count > 0
    XCTAssertTrue(exists)
  }

  func testLaunchPerformance() {
    measure(metrics: [XCTApplicationLaunchMetric()]) {
      XCUIApplication().launch()
    }
  }

  func testDeviceOrientationSupport() {
    let device = XCUIDevice.shared

    device.orientation = .portrait
    XCTAssertTrue(app.state == .runningForeground || app.state == .runningBackground)

    device.orientation = .landscapeLeft
    XCTAssertTrue(app.state == .runningForeground || app.state == .runningBackground)

    device.orientation = .portrait
  }

  func testBackgroundForegroundTransition() {
    XCTAssertEqual(app.state, .runningForeground)

    XCUIDevice.shared.press(.home)
    sleep(1)

    app.activate()
    XCTAssertEqual(app.state, .runningForeground)
  }

  func testAccessibilityElementsExist() {
    let elements = app.descendants(matching: .any).allElementsBoundByAccessibilityElement
    XCTAssertFalse(elements.isEmpty)
  }

  func testFavoriteButtonExists() {
    // Looks for a button labeled "Favorite" or with a heart symbol
    let favoriteButton = app.buttons.matching(identifier: "Favorite").firstMatch
    let heartButton = app.buttons.containing(.image, identifier: "heart").firstMatch

    XCTAssertTrue(favoriteButton.exists || heartButton.exists)
  }

  func testAddInsightButtonExists() {
    let addButton = app.buttons["Add"]
    XCTAssertTrue(addButton.exists || app.buttons["+"].exists)
  }

  func testDeleteButtonExistsInSettingsOrDetail() {
    let delete = app.buttons["Delete"]
    XCTAssertTrue(delete.exists || app.buttons["🗑️"].exists)
  }

  func testSettingsPersistAcrossRelaunch() {
    // This would check persistent state (e.g., UserDefaults-backed UI state)
    // Ideally test with a toggle switch
    let toggle = app.switches.firstMatch
    if toggle.exists {
      let initialValue = toggle.value as? String
      toggle.tap()
      app.terminate()
      app.launch()
      XCTAssertNotEqual(toggle.value as? String, initialValue)
    }
  }
}
