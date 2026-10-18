# sisi_api.model.AdminSessionDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessToken** | **String** |  | 
**tokenType** | **String** |  | 
**expiresIn** | **num** | Vida del token de acceso, en segundos | 
**sessionExpiresAt** | [**DateTime**](DateTime.md) | Fin de la sesión (8 h desde el login); después hay que volver a ingresar | 
**user** | [**UserDto**](UserDto.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


