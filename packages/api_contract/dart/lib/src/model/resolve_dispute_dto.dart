//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resolve_dispute_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResolveDisputeDto {
  /// Returns a new [ResolveDisputeDto] instance.
  ResolveDisputeDto({

    required  this.decision,

    required  this.note,
  });

      /// confirm = terminado con comisión; cancel = cancelado sin comisión
  @JsonKey(
    
    name: r'decision',
    required: true,
    includeIfNull: false,
  )


  final ResolveDisputeDtoDecisionEnum decision;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ResolveDisputeDto &&
      other.decision == decision &&
      other.note == note;

    @override
    int get hashCode =>
        decision.hashCode +
        note.hashCode;

  factory ResolveDisputeDto.fromJson(Map<String, dynamic> json) => _$ResolveDisputeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResolveDisputeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// confirm = terminado con comisión; cancel = cancelado sin comisión
enum ResolveDisputeDtoDecisionEnum {
@JsonValue(r'confirm')
confirm(r'confirm'),
@JsonValue(r'cancel')
cancel(r'cancel');

const ResolveDisputeDtoDecisionEnum(this.value);

final String value;

@override
String toString() => value;
}


