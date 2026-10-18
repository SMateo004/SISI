// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserPageDtoCWProxy {
  UserPageDto items(List<UserRowDto> items);

  UserPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserPageDto call({List<UserRowDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserPageDto.copyWith.fieldName(...)`
class _$UserPageDtoCWProxyImpl implements _$UserPageDtoCWProxy {
  const _$UserPageDtoCWProxyImpl(this._value);

  final UserPageDto _value;

  @override
  UserPageDto items(List<UserRowDto> items) => this(items: items);

  @override
  UserPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return UserPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<UserRowDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $UserPageDtoCopyWith on UserPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfUserPageDto.copyWith(...)` or like so:`instanceOfUserPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserPageDtoCWProxy get copyWith => _$UserPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPageDto _$UserPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = UserPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => UserRowDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserPageDtoToJson(UserPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
