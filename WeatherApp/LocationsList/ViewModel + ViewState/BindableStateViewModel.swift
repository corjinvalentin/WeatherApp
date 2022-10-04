//
//  BindableStateViewModel.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/28/22.
//

import Foundation

class BindableStateViewModel<DisplayEvent, ViewAction> {
    let displayEvent: Dynamic<DisplayEvent>
    
    init(initialEvent: DisplayEvent) {
        displayEvent = Dynamic(initialEvent)
    }
    
    func trigger(_ action: ViewAction) {
        assert(false, "This method must be implemented in subclasses")
    }
}
