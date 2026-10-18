//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/deletion_blocker_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deletion_check_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeletionCheckDto {
  /// Returns a new [DeletionCheckDto] instance.
  DeletionCheckDto({

    required  this.canDelete,

    required  this.blockers,

    required  this.erased,

    required  this.kept,
  });

  @JsonKey(
    
    name: r'canDelete',
    required: true,
    includeIfNull: false,
  )


  final bool canDelete;



  @JsonKey(
    
    name: r'blockers',
    required: true,
    includeIfNull: false,
  )


  final List<DeletionBlockerDto> blockers;



      /// Qué se borra
  @JsonKey(
    
    name: r'erased',
    required: true,
    includeIfNull: false,
  )


  final List<String> erased;



      /// Qué se conserva sin datos personales (obligaciones legales)
  @JsonKey(
    
    name: r'kept',
    required: true,
    includeIfNull: false,
  )


  final List<String> kept;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeletionCheckDto &&
      other.canDelete == canDelete &&
      other.blockers == blockers &&
      other.erased == erased &&
      other.kept == kept;

    @override
    int get hashCode =>
        canDelete.hashCode +
        blockers.hashCode +
        erased.hashCode +
        kept.hashCode;

  factory DeletionCheckDto.fromJson(Map<String, dynamic> json) => _$DeletionCheckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeletionCheckDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

