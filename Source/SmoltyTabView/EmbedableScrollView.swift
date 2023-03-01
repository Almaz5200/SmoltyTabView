//
// Created by Artem Trubacheev on 22.02.2023.
//

import Introspect
import SwiftUI

public struct EmbeddableScrollView<Content: View>: View {

    @Environment(\.scrollViewDelegate) var delegate
    @State var topPadding: CGFloat = 0

    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            content
                .padding(.top, topPadding)
        }
        .introspectScrollView {
            $0.delegate = delegate
            delegate?.scrollView = $0
            delegate?.topPadding = $topPadding
        }
    }

}

