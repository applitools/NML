import XCTest
import EyesXCUI

// NML capture – renders from the accessibility/native view tree.
// Eyes.setMobileCapabilities(_:apiKey:) must be called before app.launch()
// so the in-app Applitools_iOS.xcframework can hook into the NML server.
final class NMLCaptureTests: XCTestCase {

    private var app: XCUIApplication!
    private var eyes: Eyes!

    override func setUpWithError() throws {
        continueAfterFailure = false

        let apiKey = ProcessInfo.processInfo.environment["APPLITOOLS_API_KEY"] ?? ""
        app = XCUIApplication()

        // Terminate any lingering session so setMobileCapabilities can be called
        // on a not-yet-running app, as the SDK requires.
        app.terminate()

        // Wire NML before launch so the embedded framework starts its server.
        Eyes.setMobileCapabilities(app, apiKey: apiKey)
        app.launch()

        let batch: BatchInfo = BatchInfo(name : "XCUITest | Accessibility | NML ")
        batch.batchId = TestBatch.id

        let config = Configuration()
        config.apiKey = apiKey
        config.batch = batch

        eyes = Eyes()
        eyes.configuration = config
        eyes.open(withApplicationName: "AccessibilityTestUIKit", testName: "NML")
    }

    override func tearDownWithError() throws {
        try eyes.close()
    }

    // Full-window NML capture of the initial screen.
    func testNMLScreens() throws {
        eyes.check(withTag:"Full screen – default", andSettings: Target.window())

        // The entry point sits below the fold at the bottom of the form.
        app.swipeUp()
        app.swipeUp()

        let playgroundButton = app.buttons["openVisualAIPlaygroundButton"]
        XCTAssertTrue(playgroundButton.waitForExistence(timeout: 5))
        playgroundButton.tap()

        let playgroundScrollView = app.scrollViews["visualAIPlaygroundScrollView"]
        XCTAssertTrue(playgroundScrollView.waitForExistence(timeout: 5))
        eyes.check(withTag: "Visual AI Playground", andSettings: Target.window().fully())
    }
}
