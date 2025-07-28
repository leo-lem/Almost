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
    XCTAssertTrue(app.wait(for: .runningBackground, timeout: 2))

    app.activate()
    XCTAssertEqual(app.state, .runningForeground)
  }

  func testAccessibilityElementsExist() {
    let elements = app.descendants(matching: .any).allElementsBoundByAccessibilityElement
    XCTAssertFalse(elements.isEmpty)
  }

  func testAddInsightButtonExists() {
    let addButton = app.buttons["Add"]
    XCTAssertTrue(addButton.exists || app.buttons["Add Insight"].exists)
  }
}
