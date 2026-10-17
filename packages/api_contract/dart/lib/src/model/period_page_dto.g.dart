// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PeriodPageDtoCWProxy {
  PeriodPageDto items(List<PeriodSummaryDto> items);

  PeriodPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PeriodPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PeriodPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PeriodPageDto call({List<PeriodSummaryDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPeriodPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPeriodPageDto.copyWith.fieldName(...)`
class _$PeriodPageDtoCWProxyImpl implements _$PeriodPageDtoCWProxy {
  const _$PeriodPageDtoCWProxyImpl(this._value);

  final PeriodPageDto _value;

  @override
  PeriodPageDto items(List<PeriodSummaryDto> items) => this(items: items);

  @override
  PeriodPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PeriodPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PeriodPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PeriodPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return PeriodPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PeriodSummaryDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $PeriodPageDtoCopyWith on PeriodPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfPeriodPageDto.copyWith(...)` or like so:`instanceOfPeriodPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PeriodPageDtoCWProxy get copyWith => _$PeriodPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeriodPageDto _$PeriodPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PeriodPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = PeriodPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => PeriodSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PeriodPageDtoToJson(PeriodPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
