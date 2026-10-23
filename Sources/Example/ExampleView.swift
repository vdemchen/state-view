//
//  ExampleView.swift
//  StateView
//
//  Created by Vladyslav Demchenko on 08.09.2026.
//

import SwiftUI

// MARK: - ExampleView
struct ExampleView: StateView {
	// MARK: - Property
	@State private(set) var viewModel = ExampleViewModel()

	// MARK: - Body
	var body: some View {
		NavigationStack {
			contentView
				.task {
					await viewModel.fetchData()
				}
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Menu {
							Button { viewModel.chageState(to: .idle) } label: { Text("Idle") }
							Button { viewModel.chageState(to: .loading) } label: { Text("Loading") }

							Button { Task { await viewModel.fetchData() } } label: { Text("Loaded") }
							Button { viewModel.chageState(to: .emptyData) } label: { Text("Empty") }
							Button { viewModel.chageState(to: .failed(.init(title: "fail title",
																	   description: "fail description"))) }
							label: { Text("Fail") }
						} label: {
							Text("Change State")
						}
					}
				}
		}
	}

	// MARK: - Views
	var idleView: some View {
		Text("Idle")
	}

	var loadingView: some View {
		ProgressView()
	}

	var emptyDataView: some View {
		Text("No data")
	}

	func loadedView(_ data: [ExampleData]) -> some View {
		List(data) { item in
			Text(item.title)
		}
	}

	func failedView(_ fail: ExampleFail) -> some View {
		VStack {
			Text(fail.title).font(.headline)
			Text(fail.description)
		}
	}
}

// MARK: - Preview
#Preview {
	ExampleView()
}
