// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_url_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentUrlDtoCWProxy {
  DocumentUrlDto url(String url);

  DocumentUrlDto expiresAt(String expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentUrlDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentUrlDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentUrlDto call({String url, String expiresAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentUrlDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentUrlDto.copyWith.fieldName(...)`
class _$DocumentUrlDtoCWProxyImpl implements _$DocumentUrlDtoCWProxy {
  const _$DocumentUrlDtoCWProxyImpl(this._value);

  final DocumentUrlDto _value;

  @override
  DocumentUrlDto url(String url) => this(url: url);

  @override
  DocumentUrlDto expiresAt(String expiresAt) => this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentUrlDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentUrlDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentUrlDto call({
    Object? url = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return DocumentUrlDto(
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as String,
    );
  }
}

extension $DocumentUrlDtoCopyWith on DocumentUrlDto {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentUrlDto.copyWith(...)` or like so:`instanceOfDocumentUrlDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentUrlDtoCWProxy get copyWith => _$DocumentUrlDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentUrlDto _$DocumentUrlDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DocumentUrlDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['url', 'expiresAt']);
      final val = DocumentUrlDto(
        url: $checkedConvert('url', (v) => v as String),
        expiresAt: $checkedConvert('expiresAt', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DocumentUrlDtoToJson(DocumentUrlDto instance) =>
    <String, dynamic>{'url': instance.url, 'expiresAt': instance.expiresAt};
