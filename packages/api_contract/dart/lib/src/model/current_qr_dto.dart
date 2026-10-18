//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_qr_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CurrentQrDto {
  /// Returns a new [CurrentQrDto] instance.
  CurrentQrDto({

    required  this.qrUrl,
  });

      /// URL temporal; null si no hay QR
  @JsonKey(
    
    name: r'qrUrl',
    required: true,
    includeIfNull: true,
  )


  final String? qrUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CurrentQrDto &&
      other.qrUrl == qrUrl;

    @override
    int get hashCode =>
        (qrUrl == null ? 0 : qrUrl.hashCode);

  factory CurrentQrDto.fromJson(Map<String, dynamic> json) => _$CurrentQrDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentQrDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

