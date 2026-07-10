import XCTest
import EyesXCUI

// Eyes XCUITest SDK – pixel screenshot capture (no NML).
final class EyesSDKTests: XCTestCase {

    private var app: XCUIApplication!
    private var eyes: Eyes!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        let batch: BatchInfo = BatchInfo(name: "XCUITest | Accessibility | Eyes SDK")
        batch.batchId = TestBatch.id

        let config = Configuration()
        config.batch = batch
        config.apiKey = ProcessInfo.processInfo.environment["APPLITOOLS_API_KEY"] ?? ""

        eyes = Eyes()
        eyes.configuration = config
        eyes.open(withApplicationName: "AccessibilityTestUIKit", testName: "Eyes SDK")
    }

    override func tearDownWithError() throws {
        try eyes.close()
    }

    // Captures the initial screen exactly as the app launches.
    func testDefaultState() throws {
        eyes.check(withTag: "Initial screen", andSettings: Target.window())

        // Query across all element types since XCUITest inconsistently
        // classifies this row as either "Other" or "StaticText".
        let screenReaderRow = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH 'Screen reader.'"))
            .firstMatch
        XCTAssertTrue(screenReaderRow.waitForExistence(timeout: 5))
        screenReaderRow.tap()
        eyes.check(withTag: "Screen reader row toggled on", andSettings: Target.window())

        app.buttons["Standard priority"].tap()
        eyes.check(withTag: "Standard priority selected", andSettings: Target.window())

        let field = app.textFields["Tester name"]
        field.tap()
        field.typeText("Shreya")
        eyes.check(withTag: "Tester name entered", andSettings: Target.window())

        // Dismiss the keyboard so it doesn't cover "Start accessibility test"
        // further down the screen.
        app.keyboards.buttons["Done"].tap()

        app.buttons["Start accessibility test"].tap()

        // "Start accessibility test" triggers a brief 0.1s UIView.animate
        // pulse; tapping immediately afterward can hit-test mid-animation.
        Thread.sleep(forTimeInterval: 0.3)

        app.buttons["Reset accessibility test form"].tap()
        eyes.check(withTag: "After reset", andSettings: Target.window())

        // The entry point sits below the fold at the bottom of the form.
        app.swipeUp()
        app.swipeUp()

        let playgroundButton = app.buttons["openVisualAIPlaygroundButton"]
        XCTAssertTrue(playgroundButton.waitForExistence(timeout: 5))
        playgroundButton.tap()

        let playgroundScrollView = app.scrollViews["visualAIPlaygroundScrollView"]
        XCTAssertTrue(playgroundScrollView.waitForExistence(timeout: 5))
        eyes.check(withTag: "Visual AI Playground", andSettings: Target.window())

        // Second checkpoint: edit the Strict Match card's input so this
        // checkpoint's baseline exercises Eyes' strict (pixel-exact) matching
        // against a real content change, not just a fresh screen.
        let strictInput = app.textFields["strictMatchInput"]
        XCTAssertTrue(strictInput.waitForExistence(timeout: 5))
        strictInput.tap()
        if let existingText = strictInput.value as? String, !existingText.isEmpty {
            let deleteKeys = String(repeating: XCUIKeyboardKey.delete.rawValue, count: existingText.count)
            strictInput.typeText(deleteKeys)
        }
        strictInput.typeText("Eyes Visual AI Playground")
        app.keyboards.buttons["Done"].tap()

        eyes.check(withTag: "Visual AI Playground - Strict match updated", andSettings: Target.window())
    }

}
