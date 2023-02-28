//
//  TopTabHeaderView.swift
//  HeaderLi
//
//  Created by Artem Trubacheev on 22.02.2023.
//

import Combine
import Introspect
import SwiftUI

public struct SmoltyHeaderView<Header: View, Tab: Hashable, TabSelectionView: View>: View {

    @State var currentScrollDelegateCache: EmbeddableScrollViewDelegate?
    var currentScrollDelegate: EmbeddableScrollViewDelegate {
        currentScrollDelegateCache ?? delegate(for: currentSelection)
    }
    @StateObject var delegateProvider = DelegateProvider<Tab>()
    @Binding var currentSelection: Tab

    @State var headerHeight: CGFloat = 0
    @State var tabHeight: CGFloat = 0

    let headerBuilder: () -> Header
    let tabBuilder: () -> TabSelectionView
    let tabs: [TopTabViewElement<Tab>]
    let statusBarBackground: Color

    public init(
        @ViewBuilder headerBuilder: @escaping () -> Header,
        @ViewBuilder tabBuilder: @escaping () -> TabSelectionView,
        tabs: [TopTabViewElement<Tab>],
        currentSelection: Binding<Tab>,
        statusBarBackground: Color = Color(.systemBackground)
    ) {
        self.headerBuilder = headerBuilder
        self.tabBuilder = tabBuilder
        self.tabs = tabs
        self._currentSelection = currentSelection
        self.statusBarBackground = statusBarBackground
    }

    var tabInset: CGFloat {
        let baseInset = headerInset + headerHeight
        return max(0, baseInset)
    }
    var childContentInset: CGFloat { headerHeight + tabHeight }
    var headerInset: CGFloat {
        -currentScrollDelegate.contentOffset
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                TabView(selection: $currentSelection) {
                    ForEach(tabs, id: \.tab) { tab in
                        tab.environment(\.scrollViewDelegate, delegate(for: tab.tab))
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.default, value: currentSelection)

                finalHeader()

                finalTab()

            }
            VStack {
                Rectangle()
                    .fill(statusBarBackground)
                    .frame(height: geo.safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                Spacer()
            }
        }
        .onChange(of: currentSelection) {
            let newDelegate = delegate(for: $0)
            currentScrollDelegateCache = newDelegate
        }
        .onChange(of: headerHeight) {
            delegateProvider.changeHeaderHeight(to: $0)
        }
        .onChange(of: tabHeight) {
            delegateProvider.changeTabHeight(to: $0)
        }
        .onAppear {
            delegateProvider.currentSelection = $currentSelection
        }
    }

    func finalHeader() -> some View {
        VStack {
            headerBuilder()
                .background (
                    GeometryReader { geo in
                        Color.clear
                            .id(geo.size.height)
                            .onAppear {
                                headerHeight = geo.size.height
                            }
                    }
                )
                .offset(y: headerInset)
            Spacer()
        }
    }

    func finalTab() -> some View {
        VStack {
            tabBuilder()
                .background (
                    GeometryReader { geo in
                        Color.clear
                            .id(geo.size.height)
                            .onAppear {
                                tabHeight = geo.size.height
                            }
                    }
                )
            Spacer()
        }
        .offset(y: tabInset)
    }

    func delegate(for tab: Tab) -> EmbeddableScrollViewDelegate {
        delegateProvider.delegate(for: tab, headerHeight: headerHeight, tabHeight: tabHeight)
    }

}
