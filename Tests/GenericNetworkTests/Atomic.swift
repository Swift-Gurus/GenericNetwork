//
//  File.swift
//  
//
//  Created by Alex Crowe on 2023-12-15.
//

import Foundation

@propertyWrapper
actor Atomic<Value: Sendable>: Sendable {
   private let syncQueue = DispatchQueue(label: "Atomic.sync.queue")
   private var value: Value

   init(wrappedValue value: Value) {
       self.value = value
   }

    nonisolated var projectedValue: Atomic<Value> {
          self
   }

   nonisolated var wrappedValue: Value {
       get { fatalError("use load") }
       set { fatalError("use mutate to set \(newValue)") }
   }

   func load() -> Value {
       value
   }

   @discardableResult
   func mutate(_ mutation: (Value) -> Value) -> Value {
           let newValue = mutation(value)
           value = newValue
           return newValue
   }

    func setNewValue(_ newValue: Value) {
        mutate({ _ in newValue })
    }
}
