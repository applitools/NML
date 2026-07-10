import XCTest
import EyesXCUI

// NML capture rendered across multiple iPhone form factors via Applitools'
// Ultrafast Grid — the NML snapshot is captured once per check and rendered
// per device on Applitools' backend, no extra simulators required.
// Eyes.setMobileCapabilities(_:apiKey:) must be called before app.launch()
// so the in-app Applitools_iOS.xcframework can hook into the NML server.
final class NMLMultiDeviceCaptureTests: XCTestCase {

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

        let batch: BatchInfo = BatchInfo(name: "XCUITest | Accessibility | NML Multi Device")
        batch.batchId = TestBatch.id

        let config = Configuration()
        config.apiKey = apiKey
        config.batch = batch
        config.addMultiDeviceTargets([
            IosMultiDeviceTarget.iPhoneSE3rdGeneration(),
            IosMultiDeviceTarget.iPhone16(),
            IosMultiDeviceTarget.iPhone16ProMax()
        ])

        eyes = Eyes()
        eyes.configuration = config
        eyes.open(withApplicationName: "AccessibilityTestUIKit", testName: "NML Multi Device")
    }

    override func tearDownWithError() throws {
        try eyes.close()
    }

    // Renders the initial screen across every configured device.
    func testMultiDeviceScreens() throws {
        eyes.check(withTag:"Multi device – default", andSettings: Target.window())

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
