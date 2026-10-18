// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LedgerPageDtoCWProxy {
  LedgerPageDto balanceBs(String balanceBs);

  LedgerPageDto items(List<LedgerRowDto> items);

  LedgerPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LedgerPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LedgerPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LedgerPageDto call({
    String balanceBs,
    List<LedgerRowDto> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLedgerPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLedgerPageDto.copyWith.fieldName(...)`
class _$LedgerPageDtoCWProxyImpl implements _$LedgerPageDtoCWProxy {
  const _$LedgerPageDtoCWProxyImpl(this._value);

  final LedgerPageDto _value;

  @override
  LedgerPageDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  LedgerPageDto items(List<LedgerRowDto> items) => this(items: items);

  @override
  LedgerPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LedgerPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LedgerPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LedgerPageDto call({
    Object? balanceBs = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return LedgerPageDto(
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<LedgerRowDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $LedgerPageDtoCopyWith on LedgerPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfLedgerPageDto.copyWith(...)` or like so:`instanceOfLedgerPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LedgerPageDtoCWProxy get copyWith => _$LedgerPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedgerPageDto _$LedgerPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LedgerPageDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['balanceBs', 'items', 'nextCursor'],
      );
      final val = LedgerPageDto(
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => LedgerRowDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LedgerPageDtoToJson(LedgerPageDto instance) =>
    <String, dynamic>{
      'balanceBs': instance.balanceBs,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
