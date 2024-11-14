# zig-pub-sub
A pub-sub Data Storage Abstraction Intended for Embedded Applications

## Design Goals
Create a fast, lightweight, and highly customizable data storage model abstraction
to aid in the creation of multi-storage medium systems, without compromising on safety or speed.

## Features
- Premier event based programming.
- Almost everything happens at comptime, so in the best case lookups can be elided, and the worst case will be a read from the appropriate data component rather than requiring a search through all the data components. External reads will still require lookups however.

## Interfaces

```zig
/// System data is the intended endpoint for all general interactions
/// It's basically the composite data component
SystemData
  .init(ComponentEnumType: type, /* Probably more needed... */) -> !SystemData
  // Creates a SystemData object. This object should be passed around the system and is the main way to enable cross-module communication.
  // SystemData takes a user enum type and uses this to create a unique object
  
  .register_component(data_component: *DataComponent, data_component_id: ComponentEnumType) -> !void
  // Tells SystemData about a component
  // TODO: Do we need this? Or can system_data.zig be expected to just init everything it needs? 

  .fetch_component(data_component_id: ComponentEnumType) -> !*DataComponent
  // Similar to reads from RAM, this can be optimized to a single variable read.
  // TODO: Do we need this? comptime should be able to introduce any needed optimizations where we would want to interact with the ram data component directly
  // TODO: Is it possible to make this a comptime error?

/// I_DataSource_t equivalent
DataComponent
  .init(.{ /* Implementation specific arguments */}) -> !*DataComponent
  // TODO: Should this error? I assume not, comptime can probably catch any issues

/// Methods that are common to the two types
  .read(erd: Erd) -> !(comptime erd_type(erd)) 
  .write(erd: Erd, data: (comptime erd_type(erd))) -> !void
  // Notice how under this scheme, a seperate function for read/write pointer is not necessary.
  // erd_type would successfully provide the type as a nullable pointer: !?*ptr_type
  // TODO: Investigate whether reads/writes can error or if they can be comptime errors.
  .publish(erd: Erd) -> !void
  // Publishes to the on-change event for that specific erd and SystemData
  // What this means is to walk an array of callbacks ( SubscriptionCallback = fn(?*anyopaque, *SystemData) void ) and pass in the context (?*anyopaque)
  // TODO: Consider if this should even be exposed or not. Maybe it's just an internal construct. 
  // TODO: Should SubscriptionCallback also call the function with the changed value? If so, how? *anyopaque would work but ehhhhh
  .subscribe(erd: Erd, context: ?*anyopaque, callback: SubscriptionCallback) -> !void
  // Notice how subscribe does not take an *Event. This type doesn't even exist because we don't need linked lists to implement this.
  // Each subscription will have its own array of {context, callback} tuples. These are stored locally in the data component. 
  // Ideally the length of this array will be determined at comptime, based on how many times subscribe is called.
  .subscribeAll(context: ?*anyopaque, callback: SubscriptionCallback) -> void
  // Each data component (and system data itself) holds a special array of callbacks that is called upon data component/dependent data component change.
```

## Typedefs
```
ComponentId = enum {
  // My app's data components
  // The ones listed at the top will be the first to be searched
  // for ERDs. The search should be able to be performed at comptime for the ones at the top.
  // Runtime searches might be necessary for things like off-board reads/writes. 
  ram,
  flash,
  eeprom,
  appliance_api,
}
```