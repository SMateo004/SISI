//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/moderation_match_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moderation_test_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ModerationTestResultDto {
  /// Returns a new [ModerationTestResultDto] instance.
  ModerationTestResultDto({

    required  this.held,

    required  this.matches,

    required  this.timedOut,
  });

      /// Con este texto, la solicitud o el mensaje quedaría retenido
  @JsonKey(
    
    name: r'held',
    required: true,
    includeIfNull: false,
  )


  final bool held;



  @JsonKey(
    
    name: r'matches',
    required: true,
    includeIfNull: false,
  )


  final List<ModerationMatchDto> matches;



      /// Un regex no terminó a tiempo (se retendría por seguridad)
  @JsonKey(
    
    name: r'timedOut',
    required: true,
    includeIfNull: false,
  )


  final bool timedOut;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ModerationTestResultDto &&
      other.held == held &&
      other.matches == matches &&
      other.timedOut == timedOut;

    @override
    int get hashCode =>
        held.hashCode +
        matches.hashCode +
        timedOut.hashCode;

  factory ModerationTestResultDto.fromJson(Map<String, dynamic> json) => _$ModerationTestResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModerationTestResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

