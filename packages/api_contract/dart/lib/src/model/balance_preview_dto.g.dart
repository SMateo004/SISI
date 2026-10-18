// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_preview_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BalancePreviewDtoCWProxy {
  BalancePreviewDto balanceBeforeBs(String balanceBeforeBs);

  BalancePreviewDto balanceAfterBs(String balanceAfterBs);

  BalancePreviewDto allocations(List<PreviewAllocationDto> allocations);

  BalancePreviewDto blockedNow(bool blockedNow);

  BalancePreviewDto unblocks(bool unblocks);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BalancePreviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BalancePreviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  BalancePreviewDto call({
    String balanceBeforeBs,
    String balanceAfterBs,
    List<PreviewAllocationDto> allocations,
    bool blockedNow,
    bool unblocks,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBalancePreviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBalancePreviewDto.copyWith.fieldName(...)`
class _$BalancePreviewDtoCWProxyImpl implements _$BalancePreviewDtoCWProxy {
  const _$BalancePreviewDtoCWProxyImpl(this._value);

  final BalancePreviewDto _value;

  @override
  BalancePreviewDto balanceBeforeBs(String balanceBeforeBs) =>
      this(balanceBeforeBs: balanceBeforeBs);

  @override
  BalancePreviewDto balanceAfterBs(String balanceAfterBs) =>
      this(balanceAfterBs: balanceAfterBs);

  @override
  BalancePreviewDto allocations(List<PreviewAllocationDto> allocations) =>
      this(allocations: allocations);

  @override
  BalancePreviewDto blockedNow(bool blockedNow) => this(blockedNow: blockedNow);

  @override
  BalancePreviewDto unblocks(bool unblocks) => this(unblocks: unblocks);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BalancePreviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BalancePreviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  BalancePreviewDto call({
    Object? balanceBeforeBs = const $CopyWithPlaceholder(),
    Object? balanceAfterBs = const $CopyWithPlaceholder(),
    Object? allocations = const $CopyWithPlaceholder(),
    Object? blockedNow = const $CopyWithPlaceholder(),
    Object? unblocks = const $CopyWithPlaceholder(),
  }) {
    return BalancePreviewDto(
      balanceBeforeBs: balanceBeforeBs == const $CopyWithPlaceholder()
          ? _value.balanceBeforeBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBeforeBs as String,
      balanceAfterBs: balanceAfterBs == const $CopyWithPlaceholder()
          ? _value.balanceAfterBs
          // ignore: cast_nullable_to_non_nullable
          : balanceAfterBs as String,
      allocations: allocations == const $CopyWithPlaceholder()
          ? _value.allocations
          // ignore: cast_nullable_to_non_nullable
          : allocations as List<PreviewAllocationDto>,
      blockedNow: blockedNow == const $CopyWithPlaceholder()
          ? _value.blockedNow
          // ignore: cast_nullable_to_non_nullable
          : blockedNow as bool,
      unblocks: unblocks == const $CopyWithPlaceholder()
          ? _value.unblocks
          // ignore: cast_nullable_to_non_nullable
          : unblocks as bool,
    );
  }
}

extension $BalancePreviewDtoCopyWith on BalancePreviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfBalancePreviewDto.copyWith(...)` or like so:`instanceOfBalancePreviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BalancePreviewDtoCWProxy get copyWith =>
      _$BalancePreviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalancePreviewDto _$BalancePreviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BalancePreviewDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'balanceBeforeBs',
          'balanceAfterBs',
          'allocations',
          'blockedNow',
          'unblocks',
        ],
      );
      final val = BalancePreviewDto(
        balanceBeforeBs: $checkedConvert('balanceBeforeBs', (v) => v as String),
        balanceAfterBs: $checkedConvert('balanceAfterBs', (v) => v as String),
        allocations: $checkedConvert(
          'allocations',
          (v) => (v as List<dynamic>)
              .map(
                (e) => PreviewAllocationDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        blockedNow: $checkedConvert('blockedNow', (v) => v as bool),
        unblocks: $checkedConvert('unblocks', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$BalancePreviewDtoToJson(BalancePreviewDto instance) =>
    <String, dynamic>{
      'balanceBeforeBs': instance.balanceBeforeBs,
      'balanceAfterBs': instance.balanceAfterBs,
      'allocations': instance.allocations.map((e) => e.toJson()).toList(),
      'blockedNow': instance.blockedNow,
      'unblocks': instance.unblocks,
    };
