// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListHash() => r'c773e462d001c9aadc7c726687c8c105a5878703';

/// See also [TodoList].
@ProviderFor(TodoList)
final todoListProvider =
    AutoDisposeNotifierProvider<TodoList, List<Todo>>.internal(
  TodoList.new,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoList = AutoDisposeNotifier<List<Todo>>;
String _$selectedFilterHash() => r'70b3bb81db7251ac569108c5bfc52056f0b5d4dd';

/// See also [SelectedFilter].
@ProviderFor(SelectedFilter)
final selectedFilterProvider =
    AutoDisposeNotifierProvider<SelectedFilter, TodoStatus?>.internal(
  SelectedFilter.new,
  name: r'selectedFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedFilter = AutoDisposeNotifier<TodoStatus?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
