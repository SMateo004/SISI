//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_submission_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateSubmissionDto {
  /// Returns a new [CreateSubmissionDto] instance.
  CreateSubmissionDto({

    required  this.receiptKey,

     this.declaredAmountBs,

     this.note,
  });

      /// Clave devuelta por submissions/upload-url, después del PUT
  @JsonKey(
    
    name: r'receiptKey',
    required: true,
    includeIfNull: false,
  )


  final String receiptKey;



      /// Monto que dice haber pagado (texto)
  @JsonKey(
    
    name: r'declaredAmountBs',
    required: false,
    includeIfNull: false,
  )


  final String? declaredAmountBs;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateSubmissionDto &&
      other.receiptKey == receiptKey &&
      other.declaredAmountBs == declaredAmountBs &&
      other.note == note;

    @override
    int get hashCode =>
        receiptKey.hashCode +
        declaredAmountBs.hashCode +
        note.hashCode;

  factory CreateSubmissionDto.fromJson(Map<String, dynamic> json) => _$CreateSubmissionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSubmissionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

