# sisi_api.model.LoginResponseDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessToken** | **String** |  | 
**refreshToken** | **String** |  | 
**tokenType** | **String** |  | 
**expiresIn** | **num** | Vida del token de acceso, en segundos | 
**refreshExpiresIn** | **num** | Vida del refresh token, en segundos | 
**user** | [**UserDto**](UserDto.md) |  | 
**isNewUser** | **bool** | La cuenta se creó en este login | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


