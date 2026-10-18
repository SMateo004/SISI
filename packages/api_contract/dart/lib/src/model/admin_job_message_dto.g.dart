// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_job_message_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminJobMessageDtoCWProxy {
  AdminJobMessageDto id(String id);

  AdminJobMessageDto from(AdminJobMessageDtoFromEnum from);

  AdminJobMessageDto body(String body);

  AdminJobMessageDto status(AdminJobMessageDtoStatusEnum status);

  AdminJobMessageDto at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobMessageDto call({
    String id,
    AdminJobMessageDtoFromEnum from,
    String body,
    AdminJobMessageDtoStatusEnum status,
    DateTime at,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminJobMessageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminJobMessageDto.copyWith.fieldName(...)`
class _$AdminJobMessageDtoCWProxyImpl implements _$AdminJobMessageDtoCWProxy {
  const _$AdminJobMessageDtoCWProxyImpl(this._value);

  final AdminJobMessageDto _value;

  @override
  AdminJobMessageDto id(String id) => this(id: id);

  @override
  AdminJobMessageDto from(AdminJobMessageDtoFromEnum from) => this(from: from);

  @override
  AdminJobMessageDto body(String body) => this(body: body);

  @override
  AdminJobMessageDto status(AdminJobMessageDtoStatusEnum status) =>
      this(status: status);

  @override
  AdminJobMessageDto at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobMessageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobMessageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobMessageDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return AdminJobMessageDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as AdminJobMessageDtoFromEnum,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AdminJobMessageDtoStatusEnum,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $AdminJobMessageDtoCopyWith on AdminJobMessageDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminJobMessageDto.copyWith(...)` or like so:`instanceOfAdminJobMessageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminJobMessageDtoCWProxy get copyWith =>
      _$AdminJobMessageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminJobMessageDto _$AdminJobMessageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminJobMessageDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'from', 'body', 'status', 'at'],
      );
      final val = AdminJobMessageDto(
        id: $checkedConvert('id', (v) => v as String),
        from: $checkedConvert(
          'from',
          (v) => $enumDecode(_$AdminJobMessageDtoFromEnumEnumMap, v),
        ),
        body: $checkedConvert('body', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$AdminJobMessageDtoStatusEnumEnumMap, v),
        ),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$AdminJobMessageDtoToJson(AdminJobMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': _$AdminJobMessageDtoFromEnumEnumMap[instance.from]!,
      'body': instance.body,
      'status': _$AdminJobMessageDtoStatusEnumEnumMap[instance.status]!,
      'at': instance.at.toIso8601String(),
    };

const _$AdminJobMessageDtoFromEnumEnumMap = {
  AdminJobMessageDtoFromEnum.worker: 'worker',
  AdminJobMessageDtoFromEnum.employer: 'employer',
};

const _$AdminJobMessageDtoStatusEnumEnumMap = {
  AdminJobMessageDtoStatusEnum.entregado: 'entregado',
  AdminJobMessageDtoStatusEnum.retenido: 'retenido',
  AdminJobMessageDtoStatusEnum.descartado: 'descartado',
};
