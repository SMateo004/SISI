// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_status_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WorkerStatusResultDtoCWProxy {
  WorkerStatusResultDto userId(String userId);

  WorkerStatusResultDto status(String status);

  WorkerStatusResultDto modeForcedToEmployer(bool modeForcedToEmployer);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerStatusResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerStatusResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerStatusResultDto call({
    String userId,
    String status,
    bool modeForcedToEmployer,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWorkerStatusResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWorkerStatusResultDto.copyWith.fieldName(...)`
class _$WorkerStatusResultDtoCWProxyImpl
    implements _$WorkerStatusResultDtoCWProxy {
  const _$WorkerStatusResultDtoCWProxyImpl(this._value);

  final WorkerStatusResultDto _value;

  @override
  WorkerStatusResultDto userId(String userId) => this(userId: userId);

  @override
  WorkerStatusResultDto status(String status) => this(status: status);

  @override
  WorkerStatusResultDto modeForcedToEmployer(bool modeForcedToEmployer) =>
      this(modeForcedToEmployer: modeForcedToEmployer);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerStatusResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerStatusResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerStatusResultDto call({
    Object? userId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? modeForcedToEmployer = const $CopyWithPlaceholder(),
  }) {
    return WorkerStatusResultDto(
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      modeForcedToEmployer: modeForcedToEmployer == const $CopyWithPlaceholder()
          ? _value.modeForcedToEmployer
          // ignore: cast_nullable_to_non_nullable
          : modeForcedToEmployer as bool,
    );
  }
}

extension $WorkerStatusResultDtoCopyWith on WorkerStatusResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfWorkerStatusResultDto.copyWith(...)` or like so:`instanceOfWorkerStatusResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WorkerStatusResultDtoCWProxy get copyWith =>
      _$WorkerStatusResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerStatusResultDto _$WorkerStatusResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WorkerStatusResultDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['userId', 'status', 'modeForcedToEmployer'],
  );
  final val = WorkerStatusResultDto(
    userId: $checkedConvert('userId', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    modeForcedToEmployer: $checkedConvert(
      'modeForcedToEmployer',
      (v) => v as bool,
    ),
  );
  return val;
});

Map<String, dynamic> _$WorkerStatusResultDtoToJson(
  WorkerStatusResultDto instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'status': instance.status,
  'modeForcedToEmployer': instance.modeForcedToEmployer,
};
