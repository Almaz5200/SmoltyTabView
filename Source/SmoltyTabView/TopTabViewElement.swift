//
// Created by Artem Trubacheev on 23.02.2023.
//

import SwiftUI

public struct TopTabViewElement<TabType: Hashable>: View {

    let tab: TabType
    let content: AnyView

    public init(
        tab: TabType,
        @ViewBuilder content: () -> some View
    ) {
        self.tab = tab
        self.content = AnyView(content())
    }

    public var body: AnyView {
        content
    }

}

extension View {

    public func topTabView<TabType: Hashable>(tab: TabType) -> TopTabViewElement<TabType> {
        TopTabViewElement(tab: tab) { self }
    }

}
