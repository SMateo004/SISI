// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_document_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationDocumentDtoCWProxy {
  VerificationDocumentDto id(String id);

  VerificationDocumentDto type(VerificationDocumentDtoTypeEnum type);

  VerificationDocumentDto url(String url);

  VerificationDocumentDto expiresAt(DateTime expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDocumentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDocumentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDocumentDto call({
    String id,
    VerificationDocumentDtoTypeEnum type,
    String url,
    DateTime expiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationDocumentDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationDocumentDto.copyWith.fieldName(...)`
class _$VerificationDocumentDtoCWProxyImpl
    implements _$VerificationDocumentDtoCWProxy {
  const _$VerificationDocumentDtoCWProxyImpl(this._value);

  final VerificationDocumentDto _value;

  @override
  VerificationDocumentDto id(String id) => this(id: id);

  @override
  VerificationDocumentDto type(VerificationDocumentDtoTypeEnum type) =>
      this(type: type);

  @override
  VerificationDocumentDto url(String url) => this(url: url);

  @override
  VerificationDocumentDto expiresAt(DateTime expiresAt) =>
      this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDocumentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDocumentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDocumentDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return VerificationDocumentDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as VerificationDocumentDtoTypeEnum,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $VerificationDocumentDtoCopyWith on VerificationDocumentDto {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationDocumentDto.copyWith(...)` or like so:`instanceOfVerificationDocumentDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationDocumentDtoCWProxy get copyWith =>
      _$VerificationDocumentDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationDocumentDto _$VerificationDocumentDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationDocumentDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'type', 'url', 'expiresAt']);
  final val = VerificationDocumentDto(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$VerificationDocumentDtoTypeEnumEnumMap, v),
    ),
    url: $checkedConvert('url', (v) => v as String),
    expiresAt: $checkedConvert('expiresAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$VerificationDocumentDtoToJson(
  VerificationDocumentDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$VerificationDocumentDtoTypeEnumEnumMap[instance.type]!,
  'url': instance.url,
  'expiresAt': instance.expiresAt.toIso8601String(),
};

const _$VerificationDocumentDtoTypeEnumEnumMap = {
  VerificationDocumentDtoTypeEnum.ciFront: 'ci_front',
  VerificationDocumentDtoTypeEnum.ciBack: 'ci_back',
  VerificationDocumentDtoTypeEnum.selfie: 'selfie',
  VerificationDocumentDtoTypeEnum.cert: 'cert',
};
