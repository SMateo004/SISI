// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_request_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminRequestPageDtoCWProxy {
  AdminRequestPageDto items(List<AdminHeldRequestDto> items);

  AdminRequestPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRequestPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRequestPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRequestPageDto call({
    List<AdminHeldRequestDto> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminRequestPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminRequestPageDto.copyWith.fieldName(...)`
class _$AdminRequestPageDtoCWProxyImpl implements _$AdminRequestPageDtoCWProxy {
  const _$AdminRequestPageDtoCWProxyImpl(this._value);

  final AdminRequestPageDto _value;

  @override
  AdminRequestPageDto items(List<AdminHeldRequestDto> items) =>
      this(items: items);

  @override
  AdminRequestPageDto nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRequestPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRequestPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRequestPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return AdminRequestPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminHeldRequestDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $AdminRequestPageDtoCopyWith on AdminRequestPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminRequestPageDto.copyWith(...)` or like so:`instanceOfAdminRequestPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminRequestPageDtoCWProxy get copyWith =>
      _$AdminRequestPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminRequestPageDto _$AdminRequestPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminRequestPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = AdminRequestPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map(
                (e) => AdminHeldRequestDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdminRequestPageDtoToJson(
  AdminRequestPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
