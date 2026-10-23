//
//  StateViewType.swift
//  StateView
//
//  Created by Vladyslav Demchenko on 03.09.2026.
//

// MARK: - StateViewType
public enum StateViewType<Content: StateViewData, Fail: StateViewFail> {
	// MARK: - Cases
	case idle
	case loading
	case loaded([Content])
	case emptyData
	case failed(Fail)
}
