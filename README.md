# zig-embedded-starter-kit
A pub-sub data storage abstraction aimed at applications primarily using static memory
with interdependent sub-systems, particularly in embedded applications. 

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
  /// It automatically handles initialization of the data components it owns. Users directly edit its implementation to add new components
  .init() -> SystemData
  /// Callback function pointer. SubscriptionOwner is the same type as whatever holds the sub.
  /// This can be SystemData, RamDataComponent, SimpleMovingAverage, etc. 
  const SubscriptionCallback = *const fn (context: ?*anyopaque, args: *const anyopaque, owner: *SubscriptionOwner) void;
  /// Subscribe to an ERD or event
  /// subscribe will panic if the backing array is full
  /// We assume that after application init that all subscriptions will be full. Unsubs may happen, 
  /// as well as re-subs but the arrays can never grow beyond its size at init    
  .subscribe(erd_enum: ErdEnum, context: ?*anyopaque, callback: SubscriptionCallback) -> void
  /// Remove a callback from the subscription list
  .unsubscribe(erd_enum: ErdEnum, callback: SubscriptionCallback) -> void
  /// Call each SubscriptionCallback for a particular ERD or subscription list
  .publish(erd: Erd) -> void

/// Methods that are common to SystemData and DataComponents
/// runtime read/writes can be done using the internal index
/// this should generally be reserved for read/writes in response to a variable on-change
/// comptime read/writes benefit from zero lookups and highly optimized code,
/// in some cases they compile directly to a load instruction (or memcpy depending on ERD size)
  .read(comptime erd_enum: ErdEnum) -> Erd(erd_enum).T
  .runtime_read(system_data_idx: u16, data: *anyopaque) -> void
  .write(comptime erd_enum: ErdEnum, data: Erd(erd_enum).T) -> bool
  .runtime_write(system_data_idx: u16, data: *const anyopaque) -> bool
```
