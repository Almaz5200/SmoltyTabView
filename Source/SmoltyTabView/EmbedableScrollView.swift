//
// Created by Artem Trubacheev on 22.02.2023.
//

import SwiftUIIntrospect
import SwiftUI

public struct EmbeddableScrollView<Content: View>: View {

    @Environment(\.scrollViewDelegate) var delegate
    @State var topPadding: CGFloat = 0
    @State var minHeight: CGFloat = 0

    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            content
                .frame(minHeight: minHeight, alignment: .top)
                .padding(.top, topPadding)
        }
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scroll in
            scroll.delegate = delegate
            delegate?.scrollView = scroll
            delegate?.topPadding = $topPadding
            delegate?.minHeight = $minHeight
        }
    }

}

