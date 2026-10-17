// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatPageDtoCWProxy {
  ChatPageDto items(List<ChatMessageDto> items);

  ChatPageDto nextCursor(String? nextCursor);

  ChatPageDto open(bool open);

  ChatPageDto closesAt(DateTime? closesAt);

  ChatPageDto unread(num unread);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatPageDto call({
    List<ChatMessageDto> items,
    String? nextCursor,
    bool open,
    DateTime? closesAt,
    num unread,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatPageDto.copyWith.fieldName(...)`
class _$ChatPageDtoCWProxyImpl implements _$ChatPageDtoCWProxy {
  const _$ChatPageDtoCWProxyImpl(this._value);

  final ChatPageDto _value;

  @override
  ChatPageDto items(List<ChatMessageDto> items) => this(items: items);

  @override
  ChatPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  ChatPageDto open(bool open) => this(open: open);

  @override
  ChatPageDto closesAt(DateTime? closesAt) => this(closesAt: closesAt);

  @override
  ChatPageDto unread(num unread) => this(unread: unread);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
    Object? open = const $CopyWithPlaceholder(),
    Object? closesAt = const $CopyWithPlaceholder(),
    Object? unread = const $CopyWithPlaceholder(),
  }) {
    return ChatPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ChatMessageDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
      open: open == const $CopyWithPlaceholder()
          ? _value.open
          // ignore: cast_nullable_to_non_nullable
          : open as bool,
      closesAt: closesAt == const $CopyWithPlaceholder()
          ? _value.closesAt
          // ignore: cast_nullable_to_non_nullable
          : closesAt as DateTime?,
      unread: unread == const $CopyWithPlaceholder()
          ? _value.unread
          // ignore: cast_nullable_to_non_nullable
          : unread as num,
    );
  }
}

extension $ChatPageDtoCopyWith on ChatPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfChatPageDto.copyWith(...)` or like so:`instanceOfChatPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatPageDtoCWProxy get copyWith => _$ChatPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPageDto _$ChatPageDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ChatPageDto',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['items', 'nextCursor', 'open', 'closesAt', 'unread'],
    );
    final val = ChatPageDto(
      items: $checkedConvert(
        'items',
        (v) => (v as List<dynamic>)
            .map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      open: $checkedConvert('open', (v) => v as bool),
      closesAt: $checkedConvert(
        'closesAt',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      unread: $checkedConvert('unread', (v) => v as num),
    );
    return val;
  },
);

Map<String, dynamic> _$ChatPageDtoToJson(ChatPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
      'open': instance.open,
      'closesAt': instance.closesAt?.toIso8601String(),
      'unread': instance.unread,
    };
