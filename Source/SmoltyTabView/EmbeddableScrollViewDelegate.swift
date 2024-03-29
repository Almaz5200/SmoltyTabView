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
    var minHeight: Binding<CGFloat>? {
        didSet { updateInset() }
    }

    weak var scrollView: UIScrollView? {
        didSet {
            if oldValue !== scrollView {
                updateScrollViewContentOffset()
                updateInset()
            }
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
        if topPadding?.wrappedValue != contentInset {
            topPadding?.wrappedValue = max(contentInset, topPadding?.wrappedValue ?? 0)
        }
        if let scrollView = self.scrollView {
            let minHeight = scrollView.frame.height - tabHeight
            if self.minHeight?.wrappedValue != minHeight {
                self.minHeight?.wrappedValue = minHeight
            }
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
