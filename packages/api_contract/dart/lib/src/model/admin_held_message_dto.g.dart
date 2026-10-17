// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_held_message_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminHeldMessageDtoCWProxy {
  AdminHeldMessageDto id(String id);

  AdminHeldMessageDto jobId(String jobId);

  AdminHeldMessageDto senderId(String senderId);

  AdminHeldMessageDto body(String body);

  AdminHeldMessageDto matches(Object matches);

  AdminHeldMessageDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHeldMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHeldMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHeldMessageDto call({
    String id,
    String jobId,
    String senderId,
    String body,
    Object matches,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminHeldMessageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminHeldMessageDto.copyWith.fieldName(...)`
class _$AdminHeldMessageDtoCWProxyImpl implements _$AdminHeldMessageDtoCWProxy {
  const _$AdminHeldMessageDtoCWProxyImpl(this._value);

  final AdminHeldMessageDto _value;

  @override
  AdminHeldMessageDto id(String id) => this(id: id);

  @override
  AdminHeldMessageDto jobId(String jobId) => this(jobId: jobId);

  @override
  AdminHeldMessageDto senderId(String senderId) => this(senderId: senderId);

  @override
  AdminHeldMessageDto body(String body) => this(body: body);

  @override
  AdminHeldMessageDto matches(Object matches) => this(matches: matches);

  @override
  AdminHeldMessageDto createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHeldMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHeldMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHeldMessageDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? jobId = const $CopyWithPlaceholder(),
    Object? senderId = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? matches = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return AdminHeldMessageDto(
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
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      matches: matches == const $CopyWithPlaceholder()
          ? _value.matches
          // ignore: cast_nullable_to_non_nullable
          : matches as Object,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $AdminHeldMessageDtoCopyWith on AdminHeldMessageDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminHeldMessageDto.copyWith(...)` or like so:`instanceOfAdminHeldMessageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminHeldMessageDtoCWProxy get copyWith =>
      _$AdminHeldMessageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminHeldMessageDto _$AdminHeldMessageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminHeldMessageDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'jobId',
          'senderId',
          'body',
          'matches',
          'createdAt',
        ],
      );
      final val = AdminHeldMessageDto(
        id: $checkedConvert('id', (v) => v as String),
        jobId: $checkedConvert('jobId', (v) => v as String),
        senderId: $checkedConvert('senderId', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        matches: $checkedConvert('matches', (v) => v as Object),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminHeldMessageDtoToJson(
  AdminHeldMessageDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'jobId': instance.jobId,
  'senderId': instance.senderId,
  'body': instance.body,
  'matches': instance.matches,
  'createdAt': instance.createdAt.toIso8601String(),
};
