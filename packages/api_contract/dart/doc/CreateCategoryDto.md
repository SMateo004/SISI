# sisi_api.model.CreateCategoryDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**slug** | **String** | Identificador estable: no cambia después | 
**name** | **String** |  | 
**description** | **String** |  | [optional] 
**priceMinBs** | **String** |  | 
**priceMaxBs** | **String** |  | 
**commissionPct** | **String** | Por defecto 13 % (R2.2) | [optional] 
**extraRequirements** | **List&lt;String&gt;** | Requisitos extra de verificación (claves en minúsculas, R2.2) | [optional] 
**cityIds** | **List&lt;String&gt;** | Ciudades donde queda activa | [optional] 
**reason** | **String** | Motivo (queda en la auditoría) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


