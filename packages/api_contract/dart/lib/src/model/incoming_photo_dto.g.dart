// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_photo_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IncomingPhotoDtoCWProxy {
  IncomingPhotoDto id(String id);

  IncomingPhotoDto position(num position);

  IncomingPhotoDto url(String url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncomingPhotoDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncomingPhotoDto(...).copyWith(id: 12, name: "My name")
  /// ````
  IncomingPhotoDto call({String id, num position, String url});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIncomingPhotoDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIncomingPhotoDto.copyWith.fieldName(...)`
class _$IncomingPhotoDtoCWProxyImpl implements _$IncomingPhotoDtoCWProxy {
  const _$IncomingPhotoDtoCWProxyImpl(this._value);

  final IncomingPhotoDto _value;

  @override
  IncomingPhotoDto id(String id) => this(id: id);

  @override
  IncomingPhotoDto position(num position) => this(position: position);

  @override
  IncomingPhotoDto url(String url) => this(url: url);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncomingPhotoDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncomingPhotoDto(...).copyWith(id: 12, name: "My name")
  /// ````
  IncomingPhotoDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return IncomingPhotoDto(
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

extension $IncomingPhotoDtoCopyWith on IncomingPhotoDto {
  /// Returns a callable class that can be used as follows: `instanceOfIncomingPhotoDto.copyWith(...)` or like so:`instanceOfIncomingPhotoDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IncomingPhotoDtoCWProxy get copyWith => _$IncomingPhotoDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingPhotoDto _$IncomingPhotoDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('IncomingPhotoDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'position', 'url']);
      final val = IncomingPhotoDto(
        id: $checkedConvert('id', (v) => v as String),
        position: $checkedConvert('position', (v) => v as num),
        url: $checkedConvert('url', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$IncomingPhotoDtoToJson(IncomingPhotoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'url': instance.url,
    };
