//
//  Debouncer.swift
//  MusicApp
//
//  Created by anil pdv on 05/10/23.
//

import Foundation

class Debouncer: ObservableObject {
    private var timer: Timer?

    @Published var searchText: String = "" {
        didSet {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.debouncedSearchText = self.searchText
            }
        }
    }

    @Published private var debouncedSearchText: String = ""

    var publisher: Published<String>.Publisher { $debouncedSearchText }
}
