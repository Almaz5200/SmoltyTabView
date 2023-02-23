//
// Created by Artem Trubacheev on 23.02.2023.
//

import Combine
import SwiftUI
import UIKit

class DelegateProvider<Tab: Hashable>: ObservableObject {

    var currentSelection: Binding<Tab>?
    var delegateStore: [Tab: EmbeddableScrollViewDelegate] = [:]
    var cancellables: Set<AnyCancellable> = []

    func delegate(
        for tab: Tab,
        headerHeight: CGFloat,
        tabHeight: CGFloat
    ) -> EmbeddableScrollViewDelegate {
        let delegateResult: EmbeddableScrollViewDelegate
        if let delegate = delegateStore[tab] {
            delegateResult = delegate
        } else {
            let delegate = EmbeddableScrollViewDelegate()
            delegateStore[tab] = delegate
            delegateResult = delegate
            delegateResult.headerHeight = headerHeight
            delegateResult.tabHeight = tabHeight
            delegateResult.$contentOffset.sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.syncSignal(from: tab)
            }.store(in: &cancellables)
        }

        return delegateResult
    }

    func changeHeaderHeight(to height: CGFloat) {
        for delegate in delegateStore.values {
            delegate.headerHeight = height
        }
    }

    func changeTabHeight(to height: CGFloat) {
        for delegate in delegateStore.values {
            delegate.tabHeight = height
        }
    }

    func syncSignal(from tab: Tab) {
        guard currentSelection?.wrappedValue == tab else { return }
        for (key, value) in delegateStore {
            if key != tab {
                value.catchFrom(delegateStore[tab]!)
            }
        }
    }

}
