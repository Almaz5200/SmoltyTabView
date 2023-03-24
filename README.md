
# SmoltyTabView

[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)

SmoltyTabView is a Swift package that provides a custom view for creating header views with tabs, similar to the profile views in Twitter or Instagram. It allows you to easily create a header view with multiple tabs beneath it that work seamlessly together.

## Installation

Add the package to your project using Swift Package Manager (SPM):

1.  In Xcode, go to File > Swift Packages > Add Package Dependency.
2.  Enter the package URL: `https://github.com/Almaz5200/SmoltyTabView.git`.
3.  Select the appropriate version or branch, and click Next.

## Usage

To use SmoltyTabView, follow these steps:

1.  Import the package:
    
    swiftCopy code
    
    `import  SmoltyTabView`
    
2.  Use `SmoltyHeaderView` and create your custom header, tab selection, and tab views:
    
    ```
    SmoltyHeaderView(headerBuilder: {
    // Your custom header view
    }, tabBuilder: {
        // Your custom tab selection view
    }, tabs: [
        // Your custom TopTabViewElement(s)
    ], currentSelection: $currentSelection)
    ```
    
3.  Instead of using the usual `ScrollView`, use `EmbeddableScrollView` to make it compatible with SmoltyTabView.
    

## Example

Here's a simple example of how to use SmoltyTabView:

```
import SwiftUI
import SmoltyTabView

struct ContentView: View {
    @State private var currentTab: Tab = .first

    enum Tab: String, Hashable {
        case first, second, third
    }

    var body: some View {
        SmoltyHeaderView(headerBuilder: headerView, tabBuilder: tabBar, tabs: tabViews, currentSelection: $currentTab)
    }

    private func headerView() -> some View {
        Text("SmoltyTabView Example")
            .font(.largeTitle)
    }

    private func tabBar() -> some View {
        HStack {
            ForEach([Tab.first, Tab.second, Tab.third], id: \.self) { tab in
                Button(tab.rawValue.capitalized) {
                    currentTab = tab
                }
                .padding()
                .foregroundColor(currentTab == tab ? .blue : .gray)
            }
        }
    }

    private var tabViews: [TopTabViewElement<Tab>] {
        [
            firstTabView(),
            secondTabView(),
            thirdTabView()
        ]
    }

    private func firstTabView() -> TopTabViewElement<Tab> {
        EmbeddableScrollView {
            Text("First Tab Content")
                .padding()
        }
        .topTabView(tab: .first)
    }

    private func secondTabView() -> TopTabViewElement<Tab> {
        EmbeddableScrollView {
            Text("Second Tab Content")
                .padding()
        }
        .topTabView(tab: .second)
    }

    private func thirdTabView() -> TopTabViewElement<Tab> {
        EmbeddableScrollView {
            Text("Third Tab Content")
                .padding()
        }
        .topTabView(tab: .third)
    }
}
```

## Customization

You can customize the appearance of the header and tab selection views by modifying their respective view builders (`headerBuilder` and `tabBuilder`). Additionally, you can customize the background color of the status bar using the `statusBarBackground` parameter.

## License

SmoltyTabView is available under the MIT License. See the [LICENSE](https://github.com/Almaz5200/SmoltyTabView/blob/main/LICENSE) file for more information.
