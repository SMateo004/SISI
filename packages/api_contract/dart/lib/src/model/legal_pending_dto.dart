//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_pending_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalPendingDto {
  /// Returns a new [LegalPendingDto] instance.
  LegalPendingDto({

    required  this.legalPending,
  });

      /// Textos que falta aceptar
  @JsonKey(
    
    name: r'legalPending',
    required: true,
    includeIfNull: false,
  )


  final List<LegalPendingDtoLegalPendingEnum> legalPending;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalPendingDto &&
      other.legalPending == legalPending;

    @override
    int get hashCode =>
        legalPending.hashCode;

  factory LegalPendingDto.fromJson(Map<String, dynamic> json) => _$LegalPendingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LegalPendingDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LegalPendingDtoLegalPendingEnum {
@JsonValue(r'terms')
terms(r'terms'),
@JsonValue(r'privacy')
privacy(r'privacy');

const LegalPendingDtoLegalPendingEnum(this.value);

final String value;

@override
String toString() => value;
}


