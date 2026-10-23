//
//  StateView.swift
//  StateView
//
//  Created by Vladyslav Demchenko on 03.09.2026.
//

import SwiftUI

// MARK: - StateView
@MainActor public protocol StateView: View {
	// MARK: - Types
	associatedtype ViewModel: StateViewModel

	associatedtype IdleView: View
	associatedtype LoadingView: View
	associatedtype LoadedView: View
	associatedtype EmptyDataView: View
	associatedtype FailedView: View
	associatedtype ContentView: View

	// MARK: - Properties
	var viewModel: ViewModel { get }

	// MARK: - Views
	var contentView: ContentView { get }
	var idleView: IdleView { get }
	var loadingView: LoadingView { get }
	var emptyDataView: EmptyDataView { get }

	func loadedView(_ data: [ViewModel.Content]) -> LoadedView
	func failedView(_ fail: ViewModel.Fail) -> FailedView
}

// MARK: - StateView
public extension StateView {
	@ViewBuilder var body: some View {
		contentView
	}

	@ViewBuilder var contentView: some View {
		switch viewModel.viewState {
		case .idle:
			idleView
		case .loading:
			loadingView
		case .loaded(let data):
			loadedView(data)
		case .emptyData:
			emptyDataView
		case .failed(let fail):
			failedView(fail)
		}
	}
}

// MARK: - StateViewModel
@MainActor public protocol StateViewModel {
	typealias State = StateViewType<Content, Fail>

	associatedtype Content: StateViewData
	associatedtype Fail: StateViewFail

	var viewState: StateViewType<Content, Fail> { get }
}

// MARK: - StateViewData
public protocol StateViewData: Codable, Hashable, Identifiable { }

// MARK: - StateViewFail
@MainActor public protocol StateViewFail: Codable {
	var title: String { get }
	var description: String { get }
}
