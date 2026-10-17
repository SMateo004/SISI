// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sent_message_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SentMessageDtoCWProxy {
  SentMessageDto id(String id);

  SentMessageDto jobId(String jobId);

  SentMessageDto senderId(String senderId);

  SentMessageDto mine(bool mine);

  SentMessageDto body(String body);

  SentMessageDto status(SentMessageDtoStatusEnum status);

  SentMessageDto readAt(DateTime? readAt);

  SentMessageDto createdAt(DateTime createdAt);

  SentMessageDto notice(String? notice);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SentMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SentMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SentMessageDto call({
    String id,
    String jobId,
    String senderId,
    bool mine,
    String body,
    SentMessageDtoStatusEnum status,
    DateTime? readAt,
    DateTime createdAt,
    String? notice,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSentMessageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSentMessageDto.copyWith.fieldName(...)`
class _$SentMessageDtoCWProxyImpl implements _$SentMessageDtoCWProxy {
  const _$SentMessageDtoCWProxyImpl(this._value);

  final SentMessageDto _value;

  @override
  SentMessageDto id(String id) => this(id: id);

  @override
  SentMessageDto jobId(String jobId) => this(jobId: jobId);

  @override
  SentMessageDto senderId(String senderId) => this(senderId: senderId);

  @override
  SentMessageDto mine(bool mine) => this(mine: mine);

  @override
  SentMessageDto body(String body) => this(body: body);

  @override
  SentMessageDto status(SentMessageDtoStatusEnum status) =>
      this(status: status);

  @override
  SentMessageDto readAt(DateTime? readAt) => this(readAt: readAt);

  @override
  SentMessageDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  SentMessageDto notice(String? notice) => this(notice: notice);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SentMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SentMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SentMessageDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? jobId = const $CopyWithPlaceholder(),
    Object? senderId = const $CopyWithPlaceholder(),
    Object? mine = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? readAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? notice = const $CopyWithPlaceholder(),
  }) {
    return SentMessageDto(
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
          : status as SentMessageDtoStatusEnum,
      readAt: readAt == const $CopyWithPlaceholder()
          ? _value.readAt
          // ignore: cast_nullable_to_non_nullable
          : readAt as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      notice: notice == const $CopyWithPlaceholder()
          ? _value.notice
          // ignore: cast_nullable_to_non_nullable
          : notice as String?,
    );
  }
}

extension $SentMessageDtoCopyWith on SentMessageDto {
  /// Returns a callable class that can be used as follows: `instanceOfSentMessageDto.copyWith(...)` or like so:`instanceOfSentMessageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SentMessageDtoCWProxy get copyWith => _$SentMessageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentMessageDto _$SentMessageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SentMessageDto', json, ($checkedConvert) {
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
          'notice',
        ],
      );
      final val = SentMessageDto(
        id: $checkedConvert('id', (v) => v as String),
        jobId: $checkedConvert('jobId', (v) => v as String),
        senderId: $checkedConvert('senderId', (v) => v as String),
        mine: $checkedConvert('mine', (v) => v as bool),
        body: $checkedConvert('body', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$SentMessageDtoStatusEnumEnumMap, v),
        ),
        readAt: $checkedConvert(
          'readAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        notice: $checkedConvert('notice', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SentMessageDtoToJson(SentMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'senderId': instance.senderId,
      'mine': instance.mine,
      'body': instance.body,
      'status': _$SentMessageDtoStatusEnumEnumMap[instance.status]!,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'notice': instance.notice,
    };

const _$SentMessageDtoStatusEnumEnumMap = {
  SentMessageDtoStatusEnum.entregado: 'entregado',
  SentMessageDtoStatusEnum.retenido: 'retenido',
};
