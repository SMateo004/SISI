// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatMessageDtoCWProxy {
  ChatMessageDto id(String id);

  ChatMessageDto jobId(String jobId);

  ChatMessageDto senderId(String senderId);

  ChatMessageDto mine(bool mine);

  ChatMessageDto body(String body);

  ChatMessageDto status(ChatMessageDtoStatusEnum status);

  ChatMessageDto readAt(DateTime? readAt);

  ChatMessageDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatMessageDto call({
    String id,
    String jobId,
    String senderId,
    bool mine,
    String body,
    ChatMessageDtoStatusEnum status,
    DateTime? readAt,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatMessageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatMessageDto.copyWith.fieldName(...)`
class _$ChatMessageDtoCWProxyImpl implements _$ChatMessageDtoCWProxy {
  const _$ChatMessageDtoCWProxyImpl(this._value);

  final ChatMessageDto _value;

  @override
  ChatMessageDto id(String id) => this(id: id);

  @override
  ChatMessageDto jobId(String jobId) => this(jobId: jobId);

  @override
  ChatMessageDto senderId(String senderId) => this(senderId: senderId);

  @override
  ChatMessageDto mine(bool mine) => this(mine: mine);

  @override
  ChatMessageDto body(String body) => this(body: body);

  @override
  ChatMessageDto status(ChatMessageDtoStatusEnum status) =>
      this(status: status);

  @override
  ChatMessageDto readAt(DateTime? readAt) => this(readAt: readAt);

  @override
  ChatMessageDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatMessageDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? jobId = const $CopyWithPlaceholder(),
    Object? senderId = const $CopyWithPlaceholder(),
    Object? mine = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? readAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return ChatMessageDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      jobId: jobId == const $CopyWithPlaceholder()
          ? _value.jobId
          // ignore: cast_nullable_to_non_nullable
          : jobId as String,
      senderId: senderId == const $CopyWithPlaceholder()
          ? _value.senderId
          // ignore: cast_nullable_to_non_nullable
          : senderId as String,
      mine: mine == const $CopyWithPlaceholder()
          ? _value.mine
          // ignore: cast_nullable_to_non_nullable
          : mine as bool,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ChatMessageDtoStatusEnum,
      readAt: readAt == const $CopyWithPlaceholder()
          ? _value.readAt
          // ignore: cast_nullable_to_non_nullable
          : readAt as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $ChatMessageDtoCopyWith on ChatMessageDto {
  /// Returns a callable class that can be used as follows: `instanceOfChatMessageDto.copyWith(...)` or like so:`instanceOfChatMessageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatMessageDtoCWProxy get copyWith => _$ChatMessageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ChatMessageDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'jobId',
          'senderId',
          'mine',
          'body',
          'status',
          'readAt',
          'createdAt',
        ],
      );
      final val = ChatMessageDto(
        id: $checkedConvert('id', (v) => v as String),
        jobId: $checkedConvert('jobId', (v) => v as String),
        senderId: $checkedConvert('senderId', (v) => v as String),
        mine: $checkedConvert('mine', (v) => v as bool),
        body: $checkedConvert('body', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$ChatMessageDtoStatusEnumEnumMap, v),
        ),
        readAt: $checkedConvert(
          'readAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ChatMessageDtoToJson(ChatMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'senderId': instance.senderId,
      'mine': instance.mine,
      'body': instance.body,
      'status': _$ChatMessageDtoStatusEnumEnumMap[instance.status]!,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ChatMessageDtoStatusEnumEnumMap = {
  ChatMessageDtoStatusEnum.entregado: 'entregado',
  ChatMessageDtoStatusEnum.retenido: 'retenido',
};
