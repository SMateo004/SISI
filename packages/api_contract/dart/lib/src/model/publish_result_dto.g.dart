// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PublishResultDtoCWProxy {
  PublishResultDto request(RequestDto request);

  PublishResultDto warnings(List<RequestWarningDto> warnings);

  PublishResultDto held(bool held);

  PublishResultDto message(String message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublishResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublishResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PublishResultDto call({
    RequestDto request,
    List<RequestWarningDto> warnings,
    bool held,
    String message,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPublishResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPublishResultDto.copyWith.fieldName(...)`
class _$PublishResultDtoCWProxyImpl implements _$PublishResultDtoCWProxy {
  const _$PublishResultDtoCWProxyImpl(this._value);

  final PublishResultDto _value;

  @override
  PublishResultDto request(RequestDto request) => this(request: request);

  @override
  PublishResultDto warnings(List<RequestWarningDto> warnings) =>
      this(warnings: warnings);

  @override
  PublishResultDto held(bool held) => this(held: held);

  @override
  PublishResultDto message(String message) => this(message: message);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublishResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublishResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PublishResultDto call({
    Object? request = const $CopyWithPlaceholder(),
    Object? warnings = const $CopyWithPlaceholder(),
    Object? held = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return PublishResultDto(
      request: request == const $CopyWithPlaceholder()
          ? _value.request
          // ignore: cast_nullable_to_non_nullable
          : request as RequestDto,
      warnings: warnings == const $CopyWithPlaceholder()
          ? _value.warnings
          // ignore: cast_nullable_to_non_nullable
          : warnings as List<RequestWarningDto>,
      held: held == const $CopyWithPlaceholder()
          ? _value.held
          // ignore: cast_nullable_to_non_nullable
          : held as bool,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
    );
  }
}

extension $PublishResultDtoCopyWith on PublishResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfPublishResultDto.copyWith(...)` or like so:`instanceOfPublishResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PublishResultDtoCWProxy get copyWith => _$PublishResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublishResultDto _$PublishResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PublishResultDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['request', 'warnings', 'held', 'message'],
      );
      final val = PublishResultDto(
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
        held: $checkedConvert('held', (v) => v as bool),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PublishResultDtoToJson(PublishResultDto instance) =>
    <String, dynamic>{
      'request': instance.request.toJson(),
      'warnings': instance.warnings.map((e) => e.toJson()).toList(),
      'held': instance.held,
      'message': instance.message,
    };
