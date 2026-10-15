// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationPageDtoCWProxy {
  NotificationPageDto items(List<NotificationDto> items);

  NotificationPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationPageDto call({List<NotificationDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationPageDto.copyWith.fieldName(...)`
class _$NotificationPageDtoCWProxyImpl implements _$NotificationPageDtoCWProxy {
  const _$NotificationPageDtoCWProxyImpl(this._value);

  final NotificationPageDto _value;

  @override
  NotificationPageDto items(List<NotificationDto> items) => this(items: items);

  @override
  NotificationPageDto nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return NotificationPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<NotificationDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $NotificationPageDtoCopyWith on NotificationPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationPageDto.copyWith(...)` or like so:`instanceOfNotificationPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationPageDtoCWProxy get copyWith =>
      _$NotificationPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPageDto _$NotificationPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NotificationPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = NotificationPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$NotificationPageDtoToJson(
  NotificationPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
