//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incoming_photo_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class IncomingPhotoDto {
  /// Returns a new [IncomingPhotoDto] instance.
  IncomingPhotoDto({

    required  this.id,

    required  this.position,

    required  this.url,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'position',
    required: true,
    includeIfNull: false,
  )


  final num position;



      /// URL temporal firmada (solo para notificados)
  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;





    @override
    bool operator ==(Object other) => identical(this, other) || other is IncomingPhotoDto &&
      other.id == id &&
      other.position == position &&
      other.url == url;

    @override
    int get hashCode =>
        id.hashCode +
        position.hashCode +
        url.hashCode;

  factory IncomingPhotoDto.fromJson(Map<String, dynamic> json) => _$IncomingPhotoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IncomingPhotoDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

