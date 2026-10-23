//
//  ExampleModel.swift
//  StateView
//
//  Created by Vladyslav Demchenko on 08.09.2026.
//

// MARK: - ExampleData
struct ExampleData: StateViewData {
	let id: String
	let title: String
}

// MARK: - ExampleFail
struct ExampleFail: StateViewFail {
	let title: String
	let description: String
}
