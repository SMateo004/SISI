//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'qr_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QrResultDto {
  /// Returns a new [QrResultDto] instance.
  QrResultDto({

    required  this.qrUrl,
  });

      /// URL temporal del QR
  @JsonKey(
    
    name: r'qrUrl',
    required: true,
    includeIfNull: false,
  )


  final String qrUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QrResultDto &&
      other.qrUrl == qrUrl;

    @override
    int get hashCode =>
        qrUrl.hashCode;

  factory QrResultDto.fromJson(Map<String, dynamic> json) => _$QrResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QrResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

