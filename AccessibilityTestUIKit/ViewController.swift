import UIKit

// MARK: - Data Models

struct AccessibilityTest {
    let key: String
    let title: String
    let description: String
}

// MARK: - ViewController

class ViewController: UIViewController {

    // MARK: State

    private var notificationsEnabled: Bool = true
    private var selectedPriority: String = "Large text"
    private var completedTests: [String: Bool] = [
        "font": true,
        "reader": false,
        "contrast": false,
        "touch": false,
    ]

    private let tests: [AccessibilityTest] = [
        AccessibilityTest(key: "font",     title: "Font scaling",   description: "Increase system font size and confirm text wraps cleanly."),
        AccessibilityTest(key: "reader",   title: "Screen reader",  description: "Use VoiceOver or TalkBack to check labels, roles, and state."),
        AccessibilityTest(key: "contrast", title: "Contrast",       description: "Confirm selected, disabled, and body text remain readable."),
        AccessibilityTest(key: "touch",    title: "Touch targets",  description: "Buttons and controls should remain easy to tap at large text."),
    ]

    private let priorities: [String] = ["Standard", "Large text", "Screen reader"]

    // MARK: Colors

    private let colorBackground   = UIColor(hex: "#f5f7fb")!
    private let colorHeroNavy     = UIColor(hex: "#102a43")!
    private let colorHeroBadgeBg  = UIColor(hex: "#163a59")!
    private let colorHeroBadgeBdr = UIColor(hex: "#2a5272")!
    private let colorEyebrow      = UIColor(hex: "#9fb3c8")!
    private let colorWhite        = UIColor.white
    private let colorSubtitle     = UIColor(hex: "#d9e2ec")!
    private let colorBlue         = UIColor(hex: "#005ea8")!
    private let colorBlueBg       = UIColor(hex: "#eef6ff")!
    private let colorBorder       = UIColor(hex: "#d0d5dd")!
    private let colorMidBorder    = UIColor(hex: "#98a2b3")!
    private let colorLabel        = UIColor(hex: "#344054")!
    private let colorTitle        = UIColor(hex: "#101828")!
    private let colorDarkLabel    = UIColor(hex: "#182230")!
    private let colorCaption      = UIColor(hex: "#667085")!
    private let colorInputBg      = UIColor(hex: "#f9fafb")!
    private let colorMetricLabel  = UIColor(hex: "#344054")!

    // MARK: UI References for dynamic update

    private var fontScaleBadgeValueLabel: UILabel!
    private var textSizeBadgeValueLabel: UILabel!
    private var metricFontScaleValueLabel: UILabel!
    private var metricChecklistValueLabel: UILabel!
    private var checklistRowViews: [ChecklistRowView] = []
    private var priorityButtons: [UIButton] = []
    private var nameTextField: UITextField!
    private var notificationsSwitch: UISwitch!
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorBackground
        setupScrollView()
        buildUI()
        refreshDynamicValues()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Scroll + Stack Setup

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
        ])
    }

    // MARK: Build UI

    private func buildUI() {
        stackView.addArrangedSubview(buildHeroCard())
        stackView.addArrangedSubview(buildMetricPanel())
        stackView.addArrangedSubview(buildReadingSampleCard())
        stackView.addArrangedSubview(buildChecklistCard())
        stackView.addArrangedSubview(buildInputCard())
        stackView.addArrangedSubview(buildPriorityCard())
        stackView.addArrangedSubview(buildActionRow())
        stackView.addArrangedSubview(buildVisualAIPlaygroundLink())
    }

    // MARK: Hero Card

    private func buildHeroCard() -> UIView {
        let card = UIView()
        card.backgroundColor = colorHeroNavy
        card.layer.cornerRadius = 8
        card.clipsToBounds = true

        let inner = UIStackView()
        inner.axis = .vertical
        inner.spacing = 10
        inner.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(inner)

        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            inner.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -22),
        ])

        // Eyebrow
        let eyebrow = makeLabel("ACCESSIBILITY TEST", style: .subheadline, weight: .bold, color: colorEyebrow)
        eyebrow.accessibilityTraits = .header
        inner.addArrangedSubview(eyebrow)

        // Title
        let title = makeLabel("Dynamic Type Playground", style: .largeTitle, weight: .heavy, color: colorWhite)
        title.numberOfLines = 0
        title.accessibilityTraits = .header
        inner.addArrangedSubview(title)

        // Badge row (two badges side by side, wrapping)
        let badgeRow = buildBadgeRow()
        inner.addArrangedSubview(badgeRow)

        // Spacer for margin
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 4).isActive = true
        inner.addArrangedSubview(spacer)

        // Subtitle
        let subtitle = makeLabel(
            "Increase the system font size, enable bold text, or turn on a screen reader to check whether this screen remains readable and usable.",
            style: .body, weight: .regular, color: colorSubtitle
        )
        subtitle.numberOfLines = 0
        inner.addArrangedSubview(subtitle)

        return card
    }

    private func buildBadgeRow() -> UIView {
        let container = UIView()

        // Text size badge
        let textSizeBadge = buildBadge(label: "Current text size")
        textSizeBadgeValueLabel = textSizeBadge.valueLabel

        // Font scale badge
        let fontScaleBadge = buildBadge(label: "Font scale")
        fontScaleBadgeValueLabel = fontScaleBadge.valueLabel

        let stack = UIStackView(arrangedSubviews: [textSizeBadge.view, fontScaleBadge.view])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    private func buildBadge(label labelText: String) -> (view: UIView, valueLabel: UILabel) {
        let badge = UIView()
        badge.backgroundColor = colorHeroBadgeBg
        badge.layer.cornerRadius = 8
        badge.layer.borderWidth = 1
        badge.layer.borderColor = colorHeroBadgeBdr.cgColor

        let labelLbl = makeLabel(labelText.uppercased(), style: .caption1, weight: .bold, color: colorEyebrow)
        let valueLbl = makeLabel("—", style: .callout, weight: .heavy, color: colorWhite)
        valueLbl.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [labelLbl, valueLbl])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        badge.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: badge.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: -10),
        ])

        return (badge, valueLbl)
    }

    // MARK: Metric Panel

    private func buildMetricPanel() -> UIView {
        let panel = UIView()
        panel.backgroundColor = colorWhite
        panel.layer.cornerRadius = 8
        panel.layer.borderWidth = 1
        panel.layer.borderColor = colorBorder.cgColor

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 14
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: panel.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -18),
        ])

        let fontScaleBlock = buildMetricBlock(labelText: "System font scale")
        metricFontScaleValueLabel = fontScaleBlock.valueLabel
        stack.addArrangedSubview(fontScaleBlock.view)

        let checklistBlock = buildMetricBlock(labelText: "Checklist")
        metricChecklistValueLabel = checklistBlock.valueLabel
        stack.addArrangedSubview(checklistBlock.view)

        // Accessibility
        panel.isAccessibilityElement = true
        panel.accessibilityLabel = "Metric panel"

        return panel
    }

    private func buildMetricBlock(labelText: String) -> (view: UIView, valueLabel: UILabel) {
        let container = UIView()

        let label = makeLabel(labelText, style: .body, weight: .bold, color: colorMetricLabel)
        label.numberOfLines = 0

        let valueLabel = makeLabel("—", style: .largeTitle, weight: .heavy, color: colorBlue)
        valueLabel.numberOfLines = 1
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.6

        let stack = UIStackView(arrangedSubviews: [label, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return (container, valueLabel)
    }

    // MARK: Reading Sample Card

    private func buildReadingSampleCard() -> UIView {
        let card = buildSectionCard()

        let title = makeLabel("Reading Sample", style: .title2, weight: .heavy, color: colorTitle)
        title.numberOfLines = 0
        title.accessibilityTraits = .header

        let body = makeLabel(
            "This card is meant to expose text wrapping, line height, and spacing issues. At larger accessibility sizes, content should grow without clipping or overlapping nearby controls.",
            style: .body, weight: .regular, color: colorLabel
        )
        body.numberOfLines = 0

        let caption = makeLabel(
            "Tip: test iOS Dynamic Type and Android Display size / Font size.",
            style: .footnote, weight: .regular, color: colorCaption
        )
        caption.numberOfLines = 0

        [title, body, caption].forEach { card.inner.addArrangedSubview($0) }
        return card.view
    }

    // MARK: Checklist Card

    private func buildChecklistCard() -> UIView {
        let card = buildSectionCard()

        let title = makeLabel("Basic Test Checklist", style: .title2, weight: .heavy, color: colorTitle)
        title.numberOfLines = 0
        title.accessibilityTraits = .header
        card.inner.addArrangedSubview(title)

        checklistRowViews = []
        for test in tests {
            let checked = completedTests[test.key] ?? false
            let row = ChecklistRowView(
                test: test,
                checked: checked,
                checkedBg: colorBlueBg,
                checkedBorder: colorBlue,
                uncheckedBg: colorInputBg,
                uncheckedBorder: colorBorder,
                checkBlue: colorBlue,
                checkGray: colorCaption,
                titleColor: colorTitle,
                captionColor: colorCaption
            )
            row.onToggle = { [weak self] in
                self?.toggleTest(key: test.key)
            }
            checklistRowViews.append(row)
            card.inner.addArrangedSubview(row)
        }

        return card.view
    }

    // MARK: Input Card

    private func buildInputCard() -> UIView {
        let card = buildSectionCard()

        let title = makeLabel("Input and Controls", style: .title2, weight: .heavy, color: colorTitle)
        title.numberOfLines = 0
        title.accessibilityTraits = .header
        card.inner.addArrangedSubview(title)

        let nameLabel = makeLabel("Tester name", style: .body, weight: .bold, color: colorDarkLabel)
        card.inner.addArrangedSubview(nameLabel)

        nameTextField = UITextField()
        nameTextField.placeholder = "Example: Shreya"
        nameTextField.backgroundColor = colorInputBg
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = colorMidBorder.cgColor
        nameTextField.textColor = colorTitle
        nameTextField.font = UIFont.preferredFont(forTextStyle: .body)
        nameTextField.adjustsFontForContentSizeCategory = true
        nameTextField.autocapitalizationType = .words
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        nameTextField.leftViewMode = .always
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        nameTextField.rightViewMode = .always
        nameTextField.accessibilityLabel = "Tester name"
        nameTextField.accessibilityHint = "Enter the name used for this accessibility test"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 52).isActive = true
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        card.inner.addArrangedSubview(nameTextField)

        // Switch row
        let switchRow = buildSwitchRow()
        card.inner.addArrangedSubview(switchRow)

        return card.view
    }

    private func buildSwitchRow() -> UIView {
        let container = UIView()

        let switchCopyStack = UIStackView()
        switchCopyStack.axis = .vertical
        switchCopyStack.spacing = 4

        let remindersLabel = makeLabel("Enable reminders", style: .body, weight: .bold, color: colorDarkLabel)
        remindersLabel.numberOfLines = 0
        switchCopyStack.addArrangedSubview(remindersLabel)

        let remindersCaption = makeLabel(
            "Useful for testing accessible labels and switch state changes.",
            style: .footnote, weight: .regular, color: colorCaption
        )
        remindersCaption.numberOfLines = 0
        switchCopyStack.addArrangedSubview(remindersCaption)

        notificationsSwitch = UISwitch()
        notificationsSwitch.isOn = notificationsEnabled
        notificationsSwitch.onTintColor = colorBlue
        notificationsSwitch.accessibilityLabel = "Enable reminders"
        notificationsSwitch.accessibilityHint = "Turns accessibility test reminders on or off"
        notificationsSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        notificationsSwitch.setContentHuggingPriority(.required, for: .horizontal)
        notificationsSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)

        let rowStack = UIStackView(arrangedSubviews: [switchCopyStack, notificationsSwitch])
        rowStack.axis = .horizontal
        rowStack.spacing = 16
        rowStack.alignment = .center
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(rowStack)

        NSLayoutConstraint.activate([
            rowStack.topAnchor.constraint(equalTo: container.topAnchor),
            rowStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rowStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    // MARK: Priority Card

    private func buildPriorityCard() -> UIView {
        let card = buildSectionCard()

        let title = makeLabel("Test Priority", style: .title2, weight: .heavy, color: colorTitle)
        title.numberOfLines = 0
        title.accessibilityTraits = .header
        card.inner.addArrangedSubview(title)

        let body = makeLabel(
            "Select the area you are validating first. The selected item has a stronger visual state and exposes checked state to assistive tech.",
            style: .body, weight: .regular, color: colorLabel
        )
        body.numberOfLines = 0
        card.inner.addArrangedSubview(body)

        let segmentContainer = buildSegmentGroup()
        card.inner.addArrangedSubview(segmentContainer)

        return card.view
    }

    private func buildSegmentGroup() -> UIView {
        let container = UIView()
        container.accessibilityTraits = [] // radiogroup not directly available; buttons will be radios

        let flowStack = UIStackView()
        flowStack.axis = .horizontal
        flowStack.spacing = 10
        flowStack.distribution = .fillEqually
        flowStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(flowStack)

        NSLayoutConstraint.activate([
            flowStack.topAnchor.constraint(equalTo: container.topAnchor),
            flowStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            flowStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            flowStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        priorityButtons = []
        for priority in priorities {
            let btn = makePriorityButton(title: priority)
            flowStack.addArrangedSubview(btn)
            priorityButtons.append(btn)
        }

        updatePriorityButtons()
        return container
    }

    private func makePriorityButton(title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        let btn = UIButton(configuration: config)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        btn.accessibilityTraits = [.button]
        btn.accessibilityLabel = "\(title) priority"
        btn.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
        return btn
    }

    // MARK: Action Row

    private func buildActionRow() -> UIView {
        let container = UIView()

        var startConfig = UIButton.Configuration.filled()
        startConfig.title = "Start Test"
        startConfig.baseForegroundColor = colorWhite
        startConfig.baseBackgroundColor = colorBlue
        startConfig.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
        startConfig.cornerStyle = .fixed
        let startBtn = UIButton(configuration: startConfig)
        startBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        startBtn.titleLabel?.adjustsFontForContentSizeCategory = true
        startBtn.layer.cornerRadius = 8
        startBtn.layer.masksToBounds = true
        startBtn.heightAnchor.constraint(greaterThanOrEqualToConstant: 52).isActive = true
        startBtn.accessibilityLabel = "Start accessibility test"
        startBtn.accessibilityHint = "Marks the configured test as started"
        startBtn.accessibilityTraits = .button
        startBtn.addTarget(self, action: #selector(startTestTapped), for: .touchUpInside)

        var resetConfig = UIButton.Configuration.plain()
        resetConfig.title = "Reset"
        resetConfig.baseForegroundColor = colorLabel
        resetConfig.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
        resetConfig.cornerStyle = .fixed
        let resetBtn = UIButton(configuration: resetConfig)
        resetBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        resetBtn.titleLabel?.adjustsFontForContentSizeCategory = true
        resetBtn.backgroundColor = colorWhite
        resetBtn.layer.cornerRadius = 8
        resetBtn.layer.borderWidth = 1
        resetBtn.layer.borderColor = colorMidBorder.cgColor
        resetBtn.heightAnchor.constraint(greaterThanOrEqualToConstant: 52).isActive = true
        resetBtn.accessibilityLabel = "Reset accessibility test form"
        resetBtn.accessibilityTraits = .button
        resetBtn.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        let rowStack = UIStackView(arrangedSubviews: [startBtn, resetBtn])
        rowStack.axis = .horizontal
        rowStack.spacing = 12
        rowStack.distribution = .fillEqually
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(rowStack)

        NSLayoutConstraint.activate([
            rowStack.topAnchor.constraint(equalTo: container.topAnchor),
            rowStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rowStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    // MARK: Visual AI Playground Link

    private func buildVisualAIPlaygroundLink() -> UIView {
        var config = UIButton.Configuration.plain()
        config.title = "Open Visual AI Playground →"
        config.baseForegroundColor = colorBlue
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 4, bottom: 12, trailing: 4)
        let button = UIButton(configuration: config)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.bold)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.contentHorizontalAlignment = .leading
        button.accessibilityIdentifier = "openVisualAIPlaygroundButton"
        button.accessibilityLabel = "Open Visual AI Playground"
        button.accessibilityHint = "Shows a screen built to demonstrate Applitools Eyes match levels"
        button.addTarget(self, action: #selector(openVisualAIPlaygroundTapped), for: .touchUpInside)
        return button
    }

    @objc private func openVisualAIPlaygroundTapped() {
        navigationController?.pushViewController(VisualAIPlaygroundViewController(), animated: true)
    }

    // MARK: Helpers

    private func buildSectionCard() -> (view: UIView, inner: UIStackView) {
        let card = UIView()
        card.backgroundColor = colorWhite
        card.layer.cornerRadius = 8
        card.layer.borderWidth = 1
        card.layer.borderColor = colorBorder.cgColor

        let inner = UIStackView()
        inner.axis = .vertical
        inner.spacing = 12
        inner.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(inner)

        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            inner.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -18),
        ])

        return (card, inner)
    }

    private func makeLabel(
        _ text: String,
        style: UIFont.TextStyle,
        weight: UIFont.Weight,
        color: UIColor
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: style).withWeight(weight)
        return label
    }

    // MARK: Dynamic Values

    private func refreshDynamicValues() {
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let scale = bodyFont.pointSize / 17.0
        let category = traitCollection.preferredContentSizeCategory
        let sizeLabel = fontSizeLabel(for: category)

        textSizeBadgeValueLabel.text = sizeLabel
        fontScaleBadgeValueLabel.text = String(format: "%.2fx", scale)
        metricFontScaleValueLabel.text = String(format: "%.2fx", scale)

        let completedCount = tests.filter { completedTests[$0.key] == true }.count
        metricChecklistValueLabel.text = "\(completedCount)/\(tests.count)"

        // Update metric panel accessibility label
        if let panel = metricFontScaleValueLabel.superview?.superview?.superview {
            panel.accessibilityLabel = "Current system font scale is \(String(format: "%.2f", scale)). \(completedCount) of \(tests.count) basic tests complete."
        }
    }

    private func fontSizeLabel(for category: UIContentSizeCategory) -> String {
        switch category {
        case .extraSmall:                       return "Extra Small"
        case .small:                            return "Small"
        case .medium:                           return "Medium"
        case .large:                            return "Default"
        case .extraLarge:                       return "Large"
        case .extraExtraLarge:                  return "Extra Large"
        case .extraExtraExtraLarge:             return "Extra Extra Large"
        case .accessibilityMedium:              return "Accessibility Medium"
        case .accessibilityLarge:               return "Accessibility Large"
        case .accessibilityExtraLarge:          return "Accessibility Extra Large"
        case .accessibilityExtraExtraLarge:     return "Accessibility XX Large"
        case .accessibilityExtraExtraExtraLarge: return "Accessibility XXX Large"
        default:                                return "Unknown"
        }
    }

    // MARK: Priority Button State

    private func updatePriorityButtons() {
        for btn in priorityButtons {
            let title = btn.configuration?.title ?? btn.title(for: .normal) ?? ""
            let isSelected = title == selectedPriority
            if isSelected {
                var config = btn.configuration ?? UIButton.Configuration.plain()
                config.baseForegroundColor = colorWhite
                config.baseBackgroundColor = colorBlue
                btn.configuration = config
                btn.layer.borderColor = colorBlue.cgColor
                btn.accessibilityValue = "selected"
            } else {
                var config = btn.configuration ?? UIButton.Configuration.plain()
                config.baseForegroundColor = colorLabel
                config.baseBackgroundColor = colorWhite
                btn.configuration = config
                btn.layer.borderColor = colorMidBorder.cgColor
                btn.accessibilityValue = nil
            }
        }
    }

    // MARK: Actions

    @objc private func contentSizeCategoryDidChange() {
        refreshDynamicValues()
        // Refresh fonts for text field
        nameTextField.font = UIFont.preferredFont(forTextStyle: .body)
        // Priority button fonts — configuration-based buttons pick up
        // Dynamic Type automatically via adjustsFontForContentSizeCategory on titleLabel
    }

    @objc private func switchToggled(_ sender: UISwitch) {
        notificationsEnabled = sender.isOn
    }

    @objc private func priorityButtonTapped(_ sender: UIButton) {
        selectedPriority = sender.configuration?.title ?? sender.title(for: .normal) ?? ""
        updatePriorityButtons()
    }

    @objc private func startTestTapped() {
        // Visual feedback — brief alpha pulse
        UIView.animate(withDuration: 0.1, animations: {
        }, completion: nil)
    }

    @objc private func resetTapped() {
        nameTextField.text = ""
        notificationsEnabled = true
        notificationsSwitch.setOn(true, animated: true)
        selectedPriority = "Large text"
        completedTests = ["font": true, "reader": false, "contrast": false, "touch": false]
        updatePriorityButtons()
        for row in checklistRowViews {
            let checked = completedTests[row.testKey] ?? false
            row.setChecked(checked, animated: true)
        }
        refreshDynamicValues()
    }

    private func toggleTest(key: String) {
        completedTests[key] = !(completedTests[key] ?? false)
        for row in checklistRowViews {
            if row.testKey == key {
                row.setChecked(completedTests[key] ?? false, animated: true)
            }
        }
        refreshDynamicValues()
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - ChecklistRowView

class ChecklistRowView: UIView {

    let testKey: String
    var onToggle: (() -> Void)?

    private var checked: Bool
    private let checkedBg: UIColor
    private let checkedBorder: UIColor
    private let uncheckedBg: UIColor
    private let uncheckedBorder: UIColor
    private let checkBlue: UIColor

    private let checkBox: UIView
    private let checkMark: UILabel
    private let titleLabel: UILabel
    private let descriptionLabel: UILabel

    init(
        test: AccessibilityTest,
        checked: Bool,
        checkedBg: UIColor,
        checkedBorder: UIColor,
        uncheckedBg: UIColor,
        uncheckedBorder: UIColor,
        checkBlue: UIColor,
        checkGray: UIColor,
        titleColor: UIColor,
        captionColor: UIColor
    ) {
        self.testKey = test.key
        self.checked = checked
        self.checkedBg = checkedBg
        self.checkedBorder = checkedBorder
        self.uncheckedBg = uncheckedBg
        self.uncheckedBorder = uncheckedBorder
        self.checkBlue = checkBlue

        // Build subviews
        checkBox = UIView()
        checkBox.layer.cornerRadius = 6
        checkBox.layer.borderWidth = 2
        checkBox.translatesAutoresizingMaskIntoConstraints = false

        checkMark = UILabel()
        checkMark.text = "✓"
        checkMark.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.black)
        checkMark.adjustsFontForContentSizeCategory = true
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        checkMark.isAccessibilityElement = false

        titleLabel = UILabel()
        titleLabel.text = test.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.heavy)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = titleColor
        titleLabel.numberOfLines = 0

        descriptionLabel = UILabel()
        descriptionLabel.text = test.description
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = captionColor
        descriptionLabel.numberOfLines = 0

        super.init(frame: .zero)

        layer.cornerRadius = 8
        layer.borderWidth = 1
        clipsToBounds = true

        // Checkbox setup
        checkBox.addSubview(checkMark)
        NSLayoutConstraint.activate([
            checkMark.centerXAnchor.constraint(equalTo: checkBox.centerXAnchor),
            checkMark.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor),
        ])

        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let rowStack = UIStackView(arrangedSubviews: [checkBox, textStack])
        rowStack.axis = .horizontal
        rowStack.spacing = 14
        rowStack.alignment = .center
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rowStack)

        NSLayoutConstraint.activate([
            checkBox.widthAnchor.constraint(equalToConstant: 28),
            checkBox.heightAnchor.constraint(equalToConstant: 28),

            rowStack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            rowStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            rowStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            rowStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
        ])

        // Accessibility
        isAccessibilityElement = true
        accessibilityTraits = [.button]
        accessibilityLabel = "\(test.title). \(test.description)"
        accessibilityHint = "Double tap to toggle this test result"

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        applyCheckedState(animated: false)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setChecked(_ newChecked: Bool, animated: Bool) {
        checked = newChecked
        applyCheckedState(animated: animated)
    }

    private func applyCheckedState(animated: Bool) {
        let duration = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration) {
            if self.checked {
                self.backgroundColor = self.checkedBg
                self.layer.borderColor = self.checkedBorder.cgColor
                self.checkBox.backgroundColor = self.checkBlue
                self.checkBox.layer.borderColor = self.checkBlue.cgColor
                self.checkMark.textColor = .white
            } else {
                self.backgroundColor = UIColor(hex: "#f9fafb")
                self.layer.borderColor = UIColor(hex: "#d0d5dd")!.cgColor
                self.checkBox.backgroundColor = .clear
                self.checkBox.layer.borderColor = UIColor(hex: "#667085")!.cgColor
                self.checkMark.textColor = .clear
            }
        }
        accessibilityValue = checked ? "checked" : "unchecked"
    }

    @objc private func handleTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.78
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) { self.alpha = 1.0 }
        })
        onToggle?()
    }
}

// MARK: - UIFont Extension

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        attributes[.traits] = traits
        attributes[.name] = nil
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

// MARK: - UIColor Hex Extension

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        guard hexSanitized.count == 6,
              let rgb = UInt64(hexSanitized, radix: 16) else { return nil }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8)  / 255.0
        let b = CGFloat(rgb & 0x0000FF)          / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
