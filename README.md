# StateView

A small SwiftUI library for building screens driven by a single view state. Your view declares one subview per state (idle, loading, loaded, empty, failed), and `StateView` picks the right one from the view model's current state.

## Requirements

- iOS 17+
- Swift 6.3 tools, Swift 6 language mode

## Installation

Add the package with Swift Package Manager.

In Xcode: **File → Add Package Dependencies…** and enter the repository URL.

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "<repository-url>", branch: "main")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["StateView"]
    )
]
```

## Core concepts

| Type | Kind | Role |
| --- | --- | --- |
| `StateViewType<Content, Fail>` | enum | The view state: `.idle`, `.loading`, `.loaded([Content])`, `.emptyData`, `.failed(Fail)` |
| `StateViewModel` | protocol | Exposes `viewState`. Declares the `Content` and `Fail` types and a `State` typealias |
| `StateView` | protocol | A SwiftUI `View` that renders one subview per state. Provides `body` and `contentView` by default |
| `StateViewData` | protocol | Item type for loaded content (`Codable`, `Hashable`, `Identifiable`) |
| `StateViewFail` | protocol | Error type with a `title` and `description` (`Codable`) |

`StateView` asks you for:

```swift
var viewModel: ViewModel { get }

var idleView: IdleView { get }
var loadingView: LoadingView { get }
var emptyDataView: EmptyDataView { get }
func loadedView(_ data: [ViewModel.Content]) -> LoadedView
func failedView(_ fail: ViewModel.Fail) -> FailedView
```

The default `contentView` switches over `viewModel.viewState` and returns the matching view. The default `body` is just `contentView`; override `body` when you need to wrap it, for example in a `NavigationStack` or with `.task`.

## Usage

### 1. Define the models

```swift
import StateView

struct Item: StateViewData {
    let id: String
    let title: String
}

struct LoadError: StateViewFail {
    let title: String
    let description: String
}
```

### 2. Create the view model

```swift
import Observation
import StateView

@Observable @MainActor
final class ItemsViewModel: StateViewModel {
    typealias Content = Item
    typealias Fail = LoadError

    private(set) var viewState: State = .idle

    func fetch() async {
        viewState = .loading
        do {
            let items = try await api.loadItems()
            viewState = items.isEmpty ? .emptyData : .loaded(items)
        } catch {
            viewState = .failed(.init(title: "Something went wrong",
                                      description: error.localizedDescription))
        }
    }
}
```

### 3. Build the view

```swift
import SwiftUI
import StateView

struct ItemsView: StateView {
    @State private(set) var viewModel = ItemsViewModel()

    var body: some View {
        NavigationStack {
            contentView
                .task { await viewModel.fetch() }
        }
    }

    var idleView: some View { Text("Idle") }
    var loadingView: some View { ProgressView() }
    var emptyDataView: some View { Text("No data") }

    func loadedView(_ data: [Item]) -> some View {
        List(data) { Text($0.title) }
    }

    func failedView(_ fail: LoadError) -> some View {
        VStack {
            Text(fail.title).font(.headline)
            Text(fail.description)
        }
    }
}
```

## Example

[Sources/Example](Sources/Example) has a full sample (`ExampleView`, `ExampleViewModel`, `ExampleModel`) with a toolbar menu for switching between states. It includes a SwiftUI `#Preview`.

It is reference code only: `Package.swift` doesn't declare it as a target. To run it, copy the files into an app target that depends on `StateView` and add `import StateView` to each.

## Project structure

```
StateView/
├── Package.swift
└── Sources/
    ├── StateView/
    │   ├── StateView.swift        # StateView, StateViewModel, StateViewData, StateViewFail
    │   └── StateViewType.swift    # StateViewType enum
    └── Example/
        ├── ExampleModel.swift
        ├── ExampleViewModel.swift
        └── ExampleView.swift
```

## Notes

- `StateView`, `StateViewModel` and `StateViewFail` are `@MainActor`.
- Loaded content is always an array (`[Content]`), so the library is aimed at list-style screens. Use `.emptyData` for an empty result rather than `.loaded([])`.

## License

StateView is available under the MIT License. See [LICENSE](LICENSE) for details.
