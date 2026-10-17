// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SendMessageDtoCWProxy {
  SendMessageDto body(String body);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SendMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SendMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SendMessageDto call({String body});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSendMessageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSendMessageDto.copyWith.fieldName(...)`
class _$SendMessageDtoCWProxyImpl implements _$SendMessageDtoCWProxy {
  const _$SendMessageDtoCWProxyImpl(this._value);

  final SendMessageDto _value;

  @override
  SendMessageDto body(String body) => this(body: body);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SendMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SendMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SendMessageDto call({Object? body = const $CopyWithPlaceholder()}) {
    return SendMessageDto(
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
    );
  }
}

extension $SendMessageDtoCopyWith on SendMessageDto {
  /// Returns a callable class that can be used as follows: `instanceOfSendMessageDto.copyWith(...)` or like so:`instanceOfSendMessageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SendMessageDtoCWProxy get copyWith => _$SendMessageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageDto _$SendMessageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SendMessageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['body']);
      final val = SendMessageDto(
        body: $checkedConvert('body', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{'body': instance.body};
