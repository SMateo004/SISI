// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_period_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PanelPeriodPageDtoCWProxy {
  PanelPeriodPageDto items(List<PanelPeriodDto> items);

  PanelPeriodPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PanelPeriodPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PanelPeriodPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PanelPeriodPageDto call({List<PanelPeriodDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPanelPeriodPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPanelPeriodPageDto.copyWith.fieldName(...)`
class _$PanelPeriodPageDtoCWProxyImpl implements _$PanelPeriodPageDtoCWProxy {
  const _$PanelPeriodPageDtoCWProxyImpl(this._value);

  final PanelPeriodPageDto _value;

  @override
  PanelPeriodPageDto items(List<PanelPeriodDto> items) => this(items: items);

  @override
  PanelPeriodPageDto nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PanelPeriodPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PanelPeriodPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PanelPeriodPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return PanelPeriodPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PanelPeriodDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $PanelPeriodPageDtoCopyWith on PanelPeriodPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfPanelPeriodPageDto.copyWith(...)` or like so:`instanceOfPanelPeriodPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PanelPeriodPageDtoCWProxy get copyWith =>
      _$PanelPeriodPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelPeriodPageDto _$PanelPeriodPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PanelPeriodPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = PanelPeriodPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => PanelPeriodDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PanelPeriodPageDtoToJson(PanelPeriodPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
