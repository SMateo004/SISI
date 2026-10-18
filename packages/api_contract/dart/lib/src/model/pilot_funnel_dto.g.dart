// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_funnel_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PilotFunnelDtoCWProxy {
  PilotFunnelDto created(num created);

  PilotFunnelDto withOffer(num withOffer);

  PilotFunnelDto assigned(num assigned);

  PilotFunnelDto completed(num completed);

  PilotFunnelDto commissionCollected(num commissionCollected);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotFunnelDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotFunnelDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotFunnelDto call({
    num created,
    num withOffer,
    num assigned,
    num completed,
    num commissionCollected,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPilotFunnelDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPilotFunnelDto.copyWith.fieldName(...)`
class _$PilotFunnelDtoCWProxyImpl implements _$PilotFunnelDtoCWProxy {
  const _$PilotFunnelDtoCWProxyImpl(this._value);

  final PilotFunnelDto _value;

  @override
  PilotFunnelDto created(num created) => this(created: created);

  @override
  PilotFunnelDto withOffer(num withOffer) => this(withOffer: withOffer);

  @override
  PilotFunnelDto assigned(num assigned) => this(assigned: assigned);

  @override
  PilotFunnelDto completed(num completed) => this(completed: completed);

  @override
  PilotFunnelDto commissionCollected(num commissionCollected) =>
      this(commissionCollected: commissionCollected);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotFunnelDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotFunnelDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotFunnelDto call({
    Object? created = const $CopyWithPlaceholder(),
    Object? withOffer = const $CopyWithPlaceholder(),
    Object? assigned = const $CopyWithPlaceholder(),
    Object? completed = const $CopyWithPlaceholder(),
    Object? commissionCollected = const $CopyWithPlaceholder(),
  }) {
    return PilotFunnelDto(
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as num,
      withOffer: withOffer == const $CopyWithPlaceholder()
          ? _value.withOffer
          // ignore: cast_nullable_to_non_nullable
          : withOffer as num,
      assigned: assigned == const $CopyWithPlaceholder()
          ? _value.assigned
          // ignore: cast_nullable_to_non_nullable
          : assigned as num,
      completed: completed == const $CopyWithPlaceholder()
          ? _value.completed
          // ignore: cast_nullable_to_non_nullable
          : completed as num,
      commissionCollected: commissionCollected == const $CopyWithPlaceholder()
          ? _value.commissionCollected
          // ignore: cast_nullable_to_non_nullable
          : commissionCollected as num,
    );
  }
}

extension $PilotFunnelDtoCopyWith on PilotFunnelDto {
  /// Returns a callable class that can be used as follows: `instanceOfPilotFunnelDto.copyWith(...)` or like so:`instanceOfPilotFunnelDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PilotFunnelDtoCWProxy get copyWith => _$PilotFunnelDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PilotFunnelDto _$PilotFunnelDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PilotFunnelDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'created',
          'withOffer',
          'assigned',
          'completed',
          'commissionCollected',
        ],
      );
      final val = PilotFunnelDto(
        created: $checkedConvert('created', (v) => v as num),
        withOffer: $checkedConvert('withOffer', (v) => v as num),
        assigned: $checkedConvert('assigned', (v) => v as num),
        completed: $checkedConvert('completed', (v) => v as num),
        commissionCollected: $checkedConvert(
          'commissionCollected',
          (v) => v as num,
        ),
      );
      return val;
    });

Map<String, dynamic> _$PilotFunnelDtoToJson(PilotFunnelDto instance) =>
    <String, dynamic>{
      'created': instance.created,
      'withOffer': instance.withOffer,
      'assigned': instance.assigned,
      'completed': instance.completed,
      'commissionCollected': instance.commissionCollected,
    };
