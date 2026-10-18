// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_held_message_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminHeldMessagePageDtoCWProxy {
  AdminHeldMessagePageDto items(List<AdminHeldMessageDto> items);

  AdminHeldMessagePageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHeldMessagePageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHeldMessagePageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHeldMessagePageDto call({
    List<AdminHeldMessageDto> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminHeldMessagePageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminHeldMessagePageDto.copyWith.fieldName(...)`
class _$AdminHeldMessagePageDtoCWProxyImpl
    implements _$AdminHeldMessagePageDtoCWProxy {
  const _$AdminHeldMessagePageDtoCWProxyImpl(this._value);

  final AdminHeldMessagePageDto _value;

  @override
  AdminHeldMessagePageDto items(List<AdminHeldMessageDto> items) =>
      this(items: items);

  @override
  AdminHeldMessagePageDto nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHeldMessagePageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHeldMessagePageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHeldMessagePageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return AdminHeldMessagePageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminHeldMessageDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $AdminHeldMessagePageDtoCopyWith on AdminHeldMessagePageDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminHeldMessagePageDto.copyWith(...)` or like so:`instanceOfAdminHeldMessagePageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminHeldMessagePageDtoCWProxy get copyWith =>
      _$AdminHeldMessagePageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminHeldMessagePageDto _$AdminHeldMessagePageDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminHeldMessagePageDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
  final val = AdminHeldMessagePageDto(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => AdminHeldMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$AdminHeldMessagePageDtoToJson(
  AdminHeldMessagePageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
