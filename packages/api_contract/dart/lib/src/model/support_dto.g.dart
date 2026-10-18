// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SupportDtoCWProxy {
  SupportDto whatsapp(String whatsapp);

  SupportDto url(String url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportDto call({String whatsapp, String url});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSupportDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSupportDto.copyWith.fieldName(...)`
class _$SupportDtoCWProxyImpl implements _$SupportDtoCWProxy {
  const _$SupportDtoCWProxyImpl(this._value);

  final SupportDto _value;

  @override
  SupportDto whatsapp(String whatsapp) => this(whatsapp: whatsapp);

  @override
  SupportDto url(String url) => this(url: url);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportDto call({
    Object? whatsapp = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return SupportDto(
      whatsapp: whatsapp == const $CopyWithPlaceholder()
          ? _value.whatsapp
          // ignore: cast_nullable_to_non_nullable
          : whatsapp as String,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
    );
  }
}

extension $SupportDtoCopyWith on SupportDto {
  /// Returns a callable class that can be used as follows: `instanceOfSupportDto.copyWith(...)` or like so:`instanceOfSupportDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SupportDtoCWProxy get copyWith => _$SupportDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportDto _$SupportDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SupportDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['whatsapp', 'url']);
      final val = SupportDto(
        whatsapp: $checkedConvert('whatsapp', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SupportDtoToJson(SupportDto instance) =>
    <String, dynamic>{'whatsapp': instance.whatsapp, 'url': instance.url};
