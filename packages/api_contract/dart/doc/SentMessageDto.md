# sisi_api.model.SentMessageDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**jobId** | **String** |  | 
**senderId** | **String** |  | 
**mine** | **bool** | Lo envié yo | 
**body** | **String** |  | 
**status** | **String** | retenido = no se entregó (moderación); solo lo ve quien lo envió | 
**readAt** | [**DateTime**](DateTime.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**notice** | **String** | Aviso neutral para quien envió un mensaje retenido | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


