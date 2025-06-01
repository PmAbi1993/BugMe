# BugMe

**BugMe** is a powerful debugging assistant for Apple platforms. It records everything from network calls to view screenshots and presents it in a beautiful HTML report. Whether you're tracking down layout issues or inspecting API traffic, BugMe helps you capture it all with minimal setup.

## Features

- **Network Capture** – Automatically logs requests and responses by swizzling `URLSession` APIs.
- **View Inspection** – Collects screenshots and key properties from your views and view controllers.
- **Screenshot Utilities** – Extensions to grab any `UIView` or scroll view as an image or file.
- **OS Logging Helper** – Simple wrapper around `OSLog` for structured logging.
- **HTML Report Builder** – Generates a polished HTML document summarizing captured data.

## Installation

BugMe is distributed with Swift Package Manager.

```swift
// In Package.swift
dependencies: [
    .package(url: "https://github.com/PmAbi1993/BugMe.git", from: "1.0.0")
]

.target(
    name: "YourApp",
    dependencies: ["BugMe"]
)
```

## Quick Start

```swift
import BugMe

// Enable network capture
NetworkCapture.shared.enable()

// Capture a screenshot
let screenshot = someView.takeScreenshot()

// Generate an HTML report when you're ready
await BugMeViewManager.shared.advancedGenerateReport()
```

## Requirements

- Swift 6
- iOS 13+, macOS 10.15+, tvOS 13+, watchOS 6+

## Contributing

Pull requests and issues are welcome! If you find a bug or have an idea for a new feature, let us know.

## License

BugMe is released under the MIT license. See `LICENSE` for details.
