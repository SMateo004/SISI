# sisi_api.model.ChatPageDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**items** | [**List&lt;ChatMessageDto&gt;**](ChatMessageDto.md) | Del más reciente al más antiguo | 
**nextCursor** | **String** |  | 
**open** | **bool** | Se pueden enviar mensajes | 
**closesAt** | [**DateTime**](DateTime.md) | Cuándo pasa a solo lectura (24 h después de terminado o cancelado) | 
**unread** | **num** | Mensajes de la contraparte sin leer | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


