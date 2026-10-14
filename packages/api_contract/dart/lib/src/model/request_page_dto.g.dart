// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RequestPageDtoCWProxy {
  RequestPageDto items(List<RequestDto> items);

  RequestPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestPageDto call({List<RequestDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRequestPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRequestPageDto.copyWith.fieldName(...)`
class _$RequestPageDtoCWProxyImpl implements _$RequestPageDtoCWProxy {
  const _$RequestPageDtoCWProxyImpl(this._value);

  final RequestPageDto _value;

  @override
  RequestPageDto items(List<RequestDto> items) => this(items: items);

  @override
  RequestPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return RequestPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<RequestDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $RequestPageDtoCopyWith on RequestPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfRequestPageDto.copyWith(...)` or like so:`instanceOfRequestPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RequestPageDtoCWProxy get copyWith => _$RequestPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPageDto _$RequestPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RequestPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = RequestPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => RequestDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RequestPageDtoToJson(RequestPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': ?instance.nextCursor,
    };
