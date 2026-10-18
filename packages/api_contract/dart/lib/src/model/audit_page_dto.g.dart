// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditPageDtoCWProxy {
  AuditPageDto items(List<AuditEntryDto> items);

  AuditPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditPageDto call({List<AuditEntryDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditPageDto.copyWith.fieldName(...)`
class _$AuditPageDtoCWProxyImpl implements _$AuditPageDtoCWProxy {
  const _$AuditPageDtoCWProxyImpl(this._value);

  final AuditPageDto _value;

  @override
  AuditPageDto items(List<AuditEntryDto> items) => this(items: items);

  @override
  AuditPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return AuditPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AuditEntryDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $AuditPageDtoCopyWith on AuditPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfAuditPageDto.copyWith(...)` or like so:`instanceOfAuditPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditPageDtoCWProxy get copyWith => _$AuditPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPageDto _$AuditPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = AuditPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AuditEntryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AuditPageDtoToJson(AuditPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
