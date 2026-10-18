// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminReportPageDtoCWProxy {
  AdminReportPageDto items(List<AdminReportDto> items);

  AdminReportPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReportPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReportPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReportPageDto call({List<AdminReportDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminReportPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminReportPageDto.copyWith.fieldName(...)`
class _$AdminReportPageDtoCWProxyImpl implements _$AdminReportPageDtoCWProxy {
  const _$AdminReportPageDtoCWProxyImpl(this._value);

  final AdminReportPageDto _value;

  @override
  AdminReportPageDto items(List<AdminReportDto> items) => this(items: items);

  @override
  AdminReportPageDto nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReportPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReportPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReportPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return AdminReportPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminReportDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $AdminReportPageDtoCopyWith on AdminReportPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminReportPageDto.copyWith(...)` or like so:`instanceOfAdminReportPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminReportPageDtoCWProxy get copyWith =>
      _$AdminReportPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminReportPageDto _$AdminReportPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminReportPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = AdminReportPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AdminReportDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdminReportPageDtoToJson(AdminReportPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
