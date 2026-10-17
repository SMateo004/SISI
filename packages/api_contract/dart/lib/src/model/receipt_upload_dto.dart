//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipt_upload_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReceiptUploadDto {
  /// Returns a new [ReceiptUploadDto] instance.
  ReceiptUploadDto({

    required  this.workerId,

    required  this.contentType,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



  @JsonKey(
    
    name: r'contentType',
    required: true,
    includeIfNull: false,
  )


  final String contentType;



  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final num sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReceiptUploadDto &&
      other.workerId == workerId &&
      other.contentType == contentType &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        workerId.hashCode +
        contentType.hashCode +
        sizeBytes.hashCode;

  factory ReceiptUploadDto.fromJson(Map<String, dynamic> json) => _$ReceiptUploadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptUploadDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

