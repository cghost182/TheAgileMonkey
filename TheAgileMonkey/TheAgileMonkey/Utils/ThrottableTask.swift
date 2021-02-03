//
//  ThrottableTask.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 3/02/21.
//

import Foundation

protocol Throttable {
    func perform(with delay: TimeInterval,
                 in queue: DispatchQueue,
                 block completion: @escaping () -> Void) -> () -> Void
}

extension Throttable {
    func perform(with delay: TimeInterval,
                 in queue: DispatchQueue = DispatchQueue.main,
                 block completion: @escaping () -> Void) -> () -> Void {
        
        var workItem: DispatchWorkItem?
        
        return {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: completion)
            queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
        }
    }
}
