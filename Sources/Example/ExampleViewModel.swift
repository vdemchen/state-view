//
//  ExampleViewModel.swift
//  StateView
//
//  Created by Vladyslav Demchenko on 07.09.2026.
//

import Foundation
import Observation

// MARK: - ExampleViewModel
@Observable @MainActor final class ExampleViewModel: StateViewModel {
	// MARK: - Associated Types
	typealias Content = ExampleData
	typealias Fail = ExampleFail

	// MARK: - Properties
	private(set) var viewState: State = .idle
	private var items: [ExampleData] = [
		.init(id: UUID().uuidString, title: "Item 1"),
		.init(id: UUID().uuidString, title: "Item 2"),
		.init(id: UUID().uuidString, title: "Item 3")
	]

	// MARK: - Methods
	func fetchData() async {
		// any logic that should return data or empty/fail
		viewState = .loaded(items)
	}

	func chageState(to state: State) {
		viewState = state
	}
}
