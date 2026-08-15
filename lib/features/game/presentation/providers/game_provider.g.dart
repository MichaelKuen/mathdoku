// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$puzzleRepositoryHash() => r'88330e43ace6201160cf44f8ddf8853bfefe7114';

/// See also [puzzleRepository].
@ProviderFor(puzzleRepository)
final puzzleRepositoryProvider = AutoDisposeProvider<PuzzleRepository>.internal(
  puzzleRepository,
  name: r'puzzleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$puzzleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PuzzleRepositoryRef = AutoDisposeProviderRef<PuzzleRepository>;
String _$gameNotifierHash() => r'1b8984e2cc8b421dbc056e9ff06a81b871952298';

/// See also [GameNotifier].
@ProviderFor(GameNotifier)
final gameNotifierProvider = NotifierProvider<GameNotifier, GameState>.internal(
  GameNotifier.new,
  name: r'gameNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameNotifier = Notifier<GameState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
