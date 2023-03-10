//
// Created by Artem Trubacheev on 23.02.2023.
//

import SwiftUI
import UIKit

final class EmbeddableScrollViewDelegate: NSObject, ObservableObject, UIScrollViewDelegate {

    @Published var contentOffset: CGFloat = 0
    var topPadding: Binding<CGFloat>? {
        didSet { updateInset() }
    }
    var bottomPadding: Binding<CGFloat>? {
        didSet { updateInset() }
    }

    var scrollView: UIScrollView? {
        didSet {
            updateScrollViewContentOffset()
            updateInset()
        }
    }
    var tabHeight: CGFloat = 0 {
        didSet { updateInset() }
    }
    var headerHeight: CGFloat = 0 {
        didSet { updateInset() }
    }
    var contentInset: CGFloat {
        tabHeight + headerHeight
    }

    private func updateInset() {
        guard topPadding?.wrappedValue != contentInset else { return }
        topPadding?.wrappedValue = contentInset
        if let scrollView {
            let screenHeight = scrollView.frame.height
            let contentHeight = scrollView.contentSize.height - (topPadding?.wrappedValue ?? 0) - (bottomPadding?.wrappedValue ?? 0)

            let bottomInset = max(0, screenHeight - contentHeight - tabHeight)
            bottomPadding?.wrappedValue = bottomInset
        }
    }

    func catchFrom(_ other: EmbeddableScrollViewDelegate) {
        let criticalOffset = headerHeight
        if other.contentOffset < criticalOffset {
            contentOffset = other.contentOffset
        } else {
            contentOffset = max(criticalOffset, contentOffset)
        }

        updateScrollViewContentOffset()

        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    func updateScrollViewContentOffset() {
        guard let scrollView else { return }

        var offset = scrollView.contentOffset
        offset.y = contentOffset
        scrollView.setContentOffset(offset, animated: false)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffset = scrollView.contentOffset.y
        updateInset()
    }

}

extension EnvironmentValues {
    var scrollViewDelegate: EmbeddableScrollViewDelegate? {
        get { self[ScrollViewDelegateKey.self] }
        set { self[ScrollViewDelegateKey.self] = newValue }
    }
}

struct ScrollViewDelegateKey: EnvironmentKey {
    static let defaultValue: EmbeddableScrollViewDelegate? = nil
}
