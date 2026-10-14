// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_photo_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RequestPhotoDtoCWProxy {
  RequestPhotoDto id(String id);

  RequestPhotoDto position(num position);

  RequestPhotoDto url(String url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestPhotoDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestPhotoDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestPhotoDto call({String id, num position, String url});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRequestPhotoDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRequestPhotoDto.copyWith.fieldName(...)`
class _$RequestPhotoDtoCWProxyImpl implements _$RequestPhotoDtoCWProxy {
  const _$RequestPhotoDtoCWProxyImpl(this._value);

  final RequestPhotoDto _value;

  @override
  RequestPhotoDto id(String id) => this(id: id);

  @override
  RequestPhotoDto position(num position) => this(position: position);

  @override
  RequestPhotoDto url(String url) => this(url: url);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestPhotoDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestPhotoDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestPhotoDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return RequestPhotoDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      position: position == const $CopyWithPlaceholder()
          ? _value.position
          // ignore: cast_nullable_to_non_nullable
          : position as num,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
    );
  }
}

extension $RequestPhotoDtoCopyWith on RequestPhotoDto {
  /// Returns a callable class that can be used as follows: `instanceOfRequestPhotoDto.copyWith(...)` or like so:`instanceOfRequestPhotoDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RequestPhotoDtoCWProxy get copyWith => _$RequestPhotoDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPhotoDto _$RequestPhotoDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RequestPhotoDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'position', 'url']);
      final val = RequestPhotoDto(
        id: $checkedConvert('id', (v) => v as String),
        position: $checkedConvert('position', (v) => v as num),
        url: $checkedConvert('url', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RequestPhotoDtoToJson(RequestPhotoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'url': instance.url,
    };
