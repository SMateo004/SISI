// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreatedRequestDtoCWProxy {
  CreatedRequestDto request(RequestDto request);

  CreatedRequestDto warnings(List<RequestWarningDto> warnings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreatedRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreatedRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreatedRequestDto call({
    RequestDto request,
    List<RequestWarningDto> warnings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreatedRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreatedRequestDto.copyWith.fieldName(...)`
class _$CreatedRequestDtoCWProxyImpl implements _$CreatedRequestDtoCWProxy {
  const _$CreatedRequestDtoCWProxyImpl(this._value);

  final CreatedRequestDto _value;

  @override
  CreatedRequestDto request(RequestDto request) => this(request: request);

  @override
  CreatedRequestDto warnings(List<RequestWarningDto> warnings) =>
      this(warnings: warnings);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreatedRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreatedRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreatedRequestDto call({
    Object? request = const $CopyWithPlaceholder(),
    Object? warnings = const $CopyWithPlaceholder(),
  }) {
    return CreatedRequestDto(
      request: request == const $CopyWithPlaceholder()
          ? _value.request
          // ignore: cast_nullable_to_non_nullable
          : request as RequestDto,
      warnings: warnings == const $CopyWithPlaceholder()
          ? _value.warnings
          // ignore: cast_nullable_to_non_nullable
          : warnings as List<RequestWarningDto>,
    );
  }
}

extension $CreatedRequestDtoCopyWith on CreatedRequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreatedRequestDto.copyWith(...)` or like so:`instanceOfCreatedRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreatedRequestDtoCWProxy get copyWith =>
      _$CreatedRequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatedRequestDto _$CreatedRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreatedRequestDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['request', 'warnings']);
      final val = CreatedRequestDto(
        request: $checkedConvert(
          'request',
          (v) => RequestDto.fromJson(v as Map<String, dynamic>),
        ),
        warnings: $checkedConvert(
          'warnings',
          (v) => (v as List<dynamic>)
              .map((e) => RequestWarningDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CreatedRequestDtoToJson(CreatedRequestDto instance) =>
    <String, dynamic>{
      'request': instance.request.toJson(),
      'warnings': instance.warnings.map((e) => e.toJson()).toList(),
    };
