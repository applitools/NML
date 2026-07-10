import UIKit

class VisualAIPlaygroundViewController:
    UIViewController {

    //----------------------------------
    // SCROLL VIEW
    //----------------------------------

    let scrollView =
        UIScrollView()

    let contentView =
        UIView()

    //----------------------------------
    // DYNAMIC VALUES
    //----------------------------------

    let revenue =
        Int.random(in: 1000...100000)

    let activeUsers =
        Int.random(in: 100...5000)

    let cpuUsage =
        Int.random(in: 1...100)

    let currentTime =
        Date().description

    //----------------------------------
    // STRICT INPUT
    //----------------------------------

    let strictInput =
        UITextField()

    let strictPreview =
        UILabel()

    //----------------------------------
    // LIFECYCLE
    //----------------------------------

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor =
            UIColor(
                red: 243/255,
                green: 244/255,
                blue: 246/255,
                alpha: 1
            )

        setupScrollView()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This app hides the nav bar app-wide (see SceneDelegate); show it just
        // here so pushing/popping this screen gets a free back button.
        title = "Visual AI Playground"
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    //----------------------------------
    // SCROLLVIEW
    //----------------------------------

    func setupScrollView() {

        scrollView.frame =
            view.bounds

        scrollView.accessibilityIdentifier =
            "visualAIPlaygroundScrollView"

        view.addSubview(scrollView)

        contentView.frame =
            CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 4200
            )

        scrollView.addSubview(contentView)

        scrollView.contentSize =
            contentView.frame.size
    }

    //----------------------------------
    // UI SETUP
    //----------------------------------

    func setupUI() {

        //----------------------------------
        // TITLE
        //----------------------------------

        let titleLabel =
            UILabel()

        titleLabel.text =
            "Visual AI Playground"

        titleLabel.font =
            UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.adjustsFontForContentSizeCategory = true

        titleLabel.frame =
            CGRect(
                x: 20,
                y: 40,
                width: view.frame.width - 40,
                height: 50
            )

        titleLabel.accessibilityIdentifier =
            "playgroundTitle"

        contentView.addSubview(titleLabel)

        //----------------------------------
        // SUBTITLE
        //----------------------------------

        let subtitleLabel =
            UILabel()

        subtitleLabel.text =
            """
            Purpose-built screen for validating Applitools Visual AI algorithms.
            """

        subtitleLabel.numberOfLines = 0

        subtitleLabel.font =
            UIFont.preferredFont(forTextStyle: .body)
        subtitleLabel.adjustsFontForContentSizeCategory = true

        subtitleLabel.textColor =
            .darkGray

        subtitleLabel.frame =
            CGRect(
                x: 20,
                y: 100,
                width: view.frame.width - 40,
                height: 80
            )

        subtitleLabel.accessibilityIdentifier =
            "playgroundSubtitle"

        contentView.addSubview(subtitleLabel)

        //----------------------------------
        // STRICT MATCH
        //----------------------------------

        let strictCard =
            createCard(
                yPosition: 200,
                title:
                    "Strict Match Validation",
                accessibilityId:
                    "strictMatchCard"
            )

        strictInput.frame =
            CGRect(
                x: 20,
                y: 100,
                width: strictCard.frame.width - 40,
                height: 55
            )

        strictInput.borderStyle =
            .roundedRect

        strictInput.text =
            "Initial Strict Validation Text"

        strictInput.accessibilityIdentifier =
            "strictMatchInput"

        strictInput.returnKeyType =
            .done

        strictInput.delegate =
            self

        strictInput.addTarget(
            self,
            action: #selector(strictInputChanged),
            for: .editingChanged
        )

        strictCard.addSubview(strictInput)

        strictPreview.text =
            "Initial Strict Validation Text"

        strictPreview.font =
            UIFont.preferredFont(forTextStyle: .headline)
        strictPreview.adjustsFontForContentSizeCategory = true

        strictPreview.frame =
            CGRect(
                x: 20,
                y: 180,
                width: strictCard.frame.width - 40,
                height: 40
            )

        strictPreview.accessibilityIdentifier =
            "strictPreviewLabel"

        strictCard.addSubview(strictPreview)

        contentView.addSubview(strictCard)

        //----------------------------------
        // LAYOUT MATCH
        //----------------------------------

        let layoutCard =
            createCard(
                yPosition: 520,
                title:
                    "Layout Match Validation",
                accessibilityId:
                    "layoutMatchCard"
            )

        addMetric(
            text: "Revenue: $\(revenue)",
            y: 100,
            parent: layoutCard,
            accessibilityId: "layoutRevenueMetric"
        )

        addMetric(
            text: "Active Users: \(activeUsers)",
            y: 140,
            parent: layoutCard,
            accessibilityId: "layoutActiveUsersMetric"
        )

        addMetric(
            text: "CPU Usage: \(cpuUsage)%",
            y: 180,
            parent: layoutCard,
            accessibilityId: "layoutCPUMetric"
        )

        contentView.addSubview(layoutCard)

        //----------------------------------
        // IGNORE COLORS
        //----------------------------------

        let ignoreColorCard =
            createCard(
                yPosition: 820,
                title:
                    "Ignore Colors Validation",
                accessibilityId:
                    "ignoreColorsCard"
            )

        ignoreColorCard.backgroundColor =
            UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1
            )

        contentView.addSubview(ignoreColorCard)

        //----------------------------------
        // DYNAMIC MATCH
        //----------------------------------

        let dynamicCard =
            createCard(
                yPosition: 1120,
                title:
                    "Dynamic Match Validation",
                accessibilityId:
                    "dynamicMatchCard"
            )

        addMetric(
            text:
                "Last Updated: \(currentTime)",
            y: 100,
            parent: dynamicCard,
            accessibilityId: "dynamicLastUpdatedMetric"
        )

        addMetric(
            text:
                "Email: user@example.com",
            y: 150,
            parent: dynamicCard,
            accessibilityId: "dynamicEmailMetric"
        )

        addMetric(
            text:
                "Amount: $1294.22",
            y: 200,
            parent: dynamicCard,
            accessibilityId: "dynamicAmountMetric"
        )

        contentView.addSubview(dynamicCard)

        //----------------------------------
        // FLOATING REGION
        //----------------------------------

        let floatingCard =
            createCard(
                yPosition: 1440,
                title:
                    "Floating Region Validation",
                accessibilityId:
                    "floatingRegionCard"
            )

        let floatingChip =
            UIView()

        /*
        Small horizontal shift
        Better floating-region demo
        */

        let randomX =
            CGFloat.random(
                in: 20...120
            )

        floatingChip.frame =
            CGRect(
                x: randomX,
                y: 120,
                width: 60,
                height: 60
            )

        floatingChip.backgroundColor =
            .systemBlue

        floatingChip.layer.cornerRadius =
            30

        floatingChip.accessibilityIdentifier =
            "movingFloatingChip"

        floatingCard.addSubview(
            floatingChip
        )

        contentView.addSubview(
            floatingCard
        )

        //----------------------------------
        // IGNORE REGION
        //----------------------------------

        let ignoreCard =
            createCard(
                yPosition: 1760,
                title:
                    "Ignore Region Validation",
                accessibilityId:
                    "ignoreRegionCard"
            )

        let timestampLabel =
            UILabel()

        timestampLabel.text =
            Date().description

        timestampLabel.textColor =
            .systemRed

        timestampLabel.frame =
            CGRect(
                x: 20,
                y: 120,
                width: ignoreCard.frame.width - 40,
                height: 80
            )

        timestampLabel.numberOfLines = 0

        timestampLabel.accessibilityIdentifier =
            "timestampText"

        ignoreCard.addSubview(
            timestampLabel
        )

        contentView.addSubview(
            ignoreCard
        )

        //----------------------------------
        // EXACT MATCH
        //----------------------------------

        let exactCard =
            createCard(
                yPosition: 2080,
                title:
                    "Exact Match Validation",
                accessibilityId:
                    "exactMatchCard"
            )

        let exactDesc =
            UILabel()

        exactDesc.text =
            "All pixels must match precisely — no tolerance."

        exactDesc.font =
            UIFont.preferredFont(forTextStyle: .body)
        exactDesc.adjustsFontForContentSizeCategory = true

        exactDesc.textColor =
            .darkGray

        exactDesc.numberOfLines = 0

        exactDesc.frame =
            CGRect(
                x: 20,
                y: 74,
                width: exactCard.frame.width - 40,
                height: 40
            )

        exactDesc.accessibilityIdentifier =
            "exactMatchDescription"

        exactCard.addSubview(exactDesc)

        let exactSwatch =
            UIView()

        exactSwatch.frame =
            CGRect(x: 20, y: 128, width: 60, height: 60)

        exactSwatch.backgroundColor =
            UIColor(
                red: 99/255,
                green: 102/255,
                blue: 241/255,
                alpha: 1
            )

        exactSwatch.layer.cornerRadius =
            12

        exactSwatch.accessibilityIdentifier =
            "exactMatchColorSwatch"

        exactCard.addSubview(exactSwatch)

        let exactValueLabel =
            UILabel()

        exactValueLabel.text =
            "Build: 3.14.159"

        exactValueLabel.font =
            UIFont.preferredFont(forTextStyle: .headline)
        exactValueLabel.adjustsFontForContentSizeCategory = true

        exactValueLabel.frame =
            CGRect(x: 96, y: 142, width: exactCard.frame.width - 116, height: 30)

        exactValueLabel.accessibilityIdentifier =
            "exactMatchBuildLabel"

        exactCard.addSubview(exactValueLabel)

        contentView.addSubview(
            exactCard
        )

        //----------------------------------
        // LONG SCROLL
        //----------------------------------

        var currentY: CGFloat = 2400

        for index in 0..<15 {

            let scrollCard =
                createCard(
                    yPosition: currentY,
                    title:
                        "Scroll Test Card \(index + 1)",
                    accessibilityId:
                        "scrollCard-\(index)"
                )

            contentView.addSubview(
                scrollCard
            )

            currentY += 220
        }
    }

    //----------------------------------
    // CARD CREATOR
    //----------------------------------

    func createCard(
        yPosition: CGFloat,
        title: String,
        accessibilityId: String
    ) -> UIView {

        let card =
            UIView()

        card.frame =
            CGRect(
                x: 20,
                y: yPosition,
                width: view.frame.width - 40,
                height: 260
            )

        card.backgroundColor =
            .white

        card.layer.cornerRadius =
            18

        card.accessibilityIdentifier =
            accessibilityId

        let titleLabel =
            UILabel()

        titleLabel.text =
            title

        titleLabel.font =
            UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.adjustsFontForContentSizeCategory = true

        titleLabel.frame =
            CGRect(
                x: 20,
                y: 20,
                width: card.frame.width - 40,
                height: 40
            )

        card.addSubview(titleLabel)

        return card
    }

    //----------------------------------
    // STRICT INPUT HANDLER
    //----------------------------------

    @objc func strictInputChanged() {

        strictPreview.text =
            strictInput.text
    }

    //----------------------------------
    // METRIC LABEL
    //----------------------------------

    func addMetric(
        text: String,
        y: CGFloat,
        parent: UIView,
        accessibilityId: String? = nil
    ) {

        let label =
            UILabel()

        label.text =
            text

        label.font =
            UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true

        label.frame =
            CGRect(
                x: 20,
                y: y,
                width: parent.frame.width - 40,
                height: 30
            )

        if let id = accessibilityId {
            label.accessibilityIdentifier = id
        }

        parent.addSubview(label)
    }
}

// MARK: - UITextFieldDelegate

extension VisualAIPlaygroundViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
