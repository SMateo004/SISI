# sisi_api.model.JobCancellationDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**by** | **String** | Quién canceló | 
**reason** | **String** |  | 
**note** | **String** | Nota de quien canceló. Si la moderación la retuvo, solo la ve quien la escribió. | 
**noteHeld** | **bool** | La nota quedó retenida por moderación (solo para quien la escribió) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


