// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deletion_check_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeletionCheckDtoCWProxy {
  DeletionCheckDto canDelete(bool canDelete);

  DeletionCheckDto blockers(List<DeletionBlockerDto> blockers);

  DeletionCheckDto erased(List<String> erased);

  DeletionCheckDto kept(List<String> kept);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionCheckDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionCheckDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionCheckDto call({
    bool canDelete,
    List<DeletionBlockerDto> blockers,
    List<String> erased,
    List<String> kept,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeletionCheckDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeletionCheckDto.copyWith.fieldName(...)`
class _$DeletionCheckDtoCWProxyImpl implements _$DeletionCheckDtoCWProxy {
  const _$DeletionCheckDtoCWProxyImpl(this._value);

  final DeletionCheckDto _value;

  @override
  DeletionCheckDto canDelete(bool canDelete) => this(canDelete: canDelete);

  @override
  DeletionCheckDto blockers(List<DeletionBlockerDto> blockers) =>
      this(blockers: blockers);

  @override
  DeletionCheckDto erased(List<String> erased) => this(erased: erased);

  @override
  DeletionCheckDto kept(List<String> kept) => this(kept: kept);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionCheckDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionCheckDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionCheckDto call({
    Object? canDelete = const $CopyWithPlaceholder(),
    Object? blockers = const $CopyWithPlaceholder(),
    Object? erased = const $CopyWithPlaceholder(),
    Object? kept = const $CopyWithPlaceholder(),
  }) {
    return DeletionCheckDto(
      canDelete: canDelete == const $CopyWithPlaceholder()
          ? _value.canDelete
          // ignore: cast_nullable_to_non_nullable
          : canDelete as bool,
      blockers: blockers == const $CopyWithPlaceholder()
          ? _value.blockers
          // ignore: cast_nullable_to_non_nullable
          : blockers as List<DeletionBlockerDto>,
      erased: erased == const $CopyWithPlaceholder()
          ? _value.erased
          // ignore: cast_nullable_to_non_nullable
          : erased as List<String>,
      kept: kept == const $CopyWithPlaceholder()
          ? _value.kept
          // ignore: cast_nullable_to_non_nullable
          : kept as List<String>,
    );
  }
}

extension $DeletionCheckDtoCopyWith on DeletionCheckDto {
  /// Returns a callable class that can be used as follows: `instanceOfDeletionCheckDto.copyWith(...)` or like so:`instanceOfDeletionCheckDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeletionCheckDtoCWProxy get copyWith => _$DeletionCheckDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletionCheckDto _$DeletionCheckDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeletionCheckDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['canDelete', 'blockers', 'erased', 'kept'],
      );
      final val = DeletionCheckDto(
        canDelete: $checkedConvert('canDelete', (v) => v as bool),
        blockers: $checkedConvert(
          'blockers',
          (v) => (v as List<dynamic>)
              .map(
                (e) => DeletionBlockerDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        erased: $checkedConvert(
          'erased',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        kept: $checkedConvert(
          'kept',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeletionCheckDtoToJson(DeletionCheckDto instance) =>
    <String, dynamic>{
      'canDelete': instance.canDelete,
      'blockers': instance.blockers.map((e) => e.toJson()).toList(),
      'erased': instance.erased,
      'kept': instance.kept,
    };
