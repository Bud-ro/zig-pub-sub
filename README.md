# zig-embedded-starter-kit
A pub-sub Data Storage Abstraction Intended for Embedded Applications

## Design Goals
Create a fast, lightweight, and highly customizable data storage model abstraction
to aid in the creation of multi-storage medium systems, without compromising on safety or speed.

## Features
- Premier event based programming.
- Lower memory usage compared to alternatives
- Extensive use of `comptime` allows for lookups to be elided when possible, or in the worst case a direct function call to the correct data component as opposed to searching for which data component it belongs to. External reads will still require some form of lookup however.

## Interfaces

```zig
/// System data is the intended endpoint for all system level interactions
SystemData
  /// Creates a SystemData object. This object should be passed around the system and is the main way to enable cross-module communication.
  /// It automatically handles initialization of the data components it owns. Users can minimally edit it to add new components
  .init() -> SystemData
  /// Returns a reference to SystemData's child Data .
  /// Note that there is no DataComponent interface, instead each data component uses duck typing
  .fetch_component(erd_owner: ErdOwner) -> *OwningDataComponent(erd_owner)
  /// SubscriptionOwner is the same type as whatever holds the sub.
  // This can be SystemData, RamDataComponent, SimpleMovingAverage, etc. 
  // At compile time the provided callback is checked to ensure it matches
  const SubscriptionCallback = *const fn (*SubscriptionOwner) void;
  /// subscribe can panic if the backing array is full
  /// in -OReleaseSmall builds the subscription simply won't be put on the array
  /// We assume that after app init all subscriptions will be full. Unsubs may happen, 
  /// as well as re-subs but the arrays can never grow beyond their size at init
  /// This may preclude certain stack-based defer subscription patterns.    
  .subscribe(erd: Erd, context: ?*anyopaque, callback: SubscriptionCallback) -> void
  /// Uses the callback to find and remove the subscription
  .unsubscribe(erd: Erd, callback: SubscriptionCallback) -> void
  /// Walks the ERD's subscription array and 
  .publish(erd: Erd) -> void

/// Methods that are common to the two types
  .read(erd: Erd) -> erd.T
  .write(erd: Erd, data: erd.T) -> bool // May be stubbed out into a compile error for some data components
  /// Each piece holds a special array of callbacks that is called upon data component/dependent data component change.
  .subscribeAll(context: ?*anyopaque, callback: SubscriptionCallback) -> void
  /// Walks the subscribe all array and performs the callbacks with context and a self reference
  .publishAll() -> void
```
