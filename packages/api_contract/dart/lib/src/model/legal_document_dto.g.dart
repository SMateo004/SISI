// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_document_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalDocumentDtoCWProxy {
  LegalDocumentDto type(LegalDocumentDtoTypeEnum type);

  LegalDocumentDto version(num version);

  LegalDocumentDto title(String title);

  LegalDocumentDto contentMd(String contentMd);

  LegalDocumentDto publishedAt(DateTime publishedAt);

  LegalDocumentDto draft(bool draft);

  LegalDocumentDto pilotOnly(bool pilotOnly);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalDocumentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalDocumentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalDocumentDto call({
    LegalDocumentDtoTypeEnum type,
    num version,
    String title,
    String contentMd,
    DateTime publishedAt,
    bool draft,
    bool pilotOnly,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalDocumentDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalDocumentDto.copyWith.fieldName(...)`
class _$LegalDocumentDtoCWProxyImpl implements _$LegalDocumentDtoCWProxy {
  const _$LegalDocumentDtoCWProxyImpl(this._value);

  final LegalDocumentDto _value;

  @override
  LegalDocumentDto type(LegalDocumentDtoTypeEnum type) => this(type: type);

  @override
  LegalDocumentDto version(num version) => this(version: version);

  @override
  LegalDocumentDto title(String title) => this(title: title);

  @override
  LegalDocumentDto contentMd(String contentMd) => this(contentMd: contentMd);

  @override
  LegalDocumentDto publishedAt(DateTime publishedAt) =>
      this(publishedAt: publishedAt);

  @override
  LegalDocumentDto draft(bool draft) => this(draft: draft);

  @override
  LegalDocumentDto pilotOnly(bool pilotOnly) => this(pilotOnly: pilotOnly);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalDocumentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalDocumentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalDocumentDto call({
    Object? type = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? contentMd = const $CopyWithPlaceholder(),
    Object? publishedAt = const $CopyWithPlaceholder(),
    Object? draft = const $CopyWithPlaceholder(),
    Object? pilotOnly = const $CopyWithPlaceholder(),
  }) {
    return LegalDocumentDto(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as LegalDocumentDtoTypeEnum,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as num,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      contentMd: contentMd == const $CopyWithPlaceholder()
          ? _value.contentMd
          // ignore: cast_nullable_to_non_nullable
          : contentMd as String,
      publishedAt: publishedAt == const $CopyWithPlaceholder()
          ? _value.publishedAt
          // ignore: cast_nullable_to_non_nullable
          : publishedAt as DateTime,
      draft: draft == const $CopyWithPlaceholder()
          ? _value.draft
          // ignore: cast_nullable_to_non_nullable
          : draft as bool,
      pilotOnly: pilotOnly == const $CopyWithPlaceholder()
          ? _value.pilotOnly
          // ignore: cast_nullable_to_non_nullable
          : pilotOnly as bool,
    );
  }
}

extension $LegalDocumentDtoCopyWith on LegalDocumentDto {
  /// Returns a callable class that can be used as follows: `instanceOfLegalDocumentDto.copyWith(...)` or like so:`instanceOfLegalDocumentDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalDocumentDtoCWProxy get copyWith => _$LegalDocumentDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalDocumentDto _$LegalDocumentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalDocumentDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'type',
          'version',
          'title',
          'contentMd',
          'publishedAt',
          'draft',
          'pilotOnly',
        ],
      );
      final val = LegalDocumentDto(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$LegalDocumentDtoTypeEnumEnumMap, v),
        ),
        version: $checkedConvert('version', (v) => v as num),
        title: $checkedConvert('title', (v) => v as String),
        contentMd: $checkedConvert('contentMd', (v) => v as String),
        publishedAt: $checkedConvert(
          'publishedAt',
          (v) => DateTime.parse(v as String),
        ),
        draft: $checkedConvert('draft', (v) => v as bool),
        pilotOnly: $checkedConvert('pilotOnly', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$LegalDocumentDtoToJson(LegalDocumentDto instance) =>
    <String, dynamic>{
      'type': _$LegalDocumentDtoTypeEnumEnumMap[instance.type]!,
      'version': instance.version,
      'title': instance.title,
      'contentMd': instance.contentMd,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'draft': instance.draft,
      'pilotOnly': instance.pilotOnly,
    };

const _$LegalDocumentDtoTypeEnumEnumMap = {
  LegalDocumentDtoTypeEnum.terms: 'terms',
  LegalDocumentDtoTypeEnum.privacy: 'privacy',
};
