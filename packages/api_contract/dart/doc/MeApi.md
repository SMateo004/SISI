# sisi_api.api.MeApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**meControllerConfirmPhoto**](MeApi.md#mecontrollerconfirmphoto) | **PUT** /me/photo | Confirma la foto subida y la deja como foto de perfil
[**meControllerMe**](MeApi.md#mecontrollerme) | **GET** /me | Mi cuenta
[**meControllerPhotoUploadUrl**](MeApi.md#mecontrollerphotouploadurl) | **POST** /me/photo/upload-url | URL prefirmada para subir mi foto de perfil
[**meControllerUpdate**](MeApi.md#mecontrollerupdate) | **PATCH** /me | Actualiza mi nombre (la foto se cambia con /me/photo)


# **meControllerConfirmPhoto**
> UserDto meControllerConfirmPhoto(confirmUploadDto)

Confirma la foto subida y la deja como foto de perfil

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();
final ConfirmUploadDto confirmUploadDto = ; // ConfirmUploadDto | 

try {
    final response = api.meControllerConfirmPhoto(confirmUploadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->meControllerConfirmPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **confirmUploadDto** | [**ConfirmUploadDto**](ConfirmUploadDto.md)|  | 

### Return type

[**UserDto**](UserDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **meControllerMe**
> UserDto meControllerMe()

Mi cuenta

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();

try {
    final response = api.meControllerMe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->meControllerMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserDto**](UserDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **meControllerPhotoUploadUrl**
> PresignedUploadDto meControllerPhotoUploadUrl(uploadRequestDto)

URL prefirmada para subir mi foto de perfil

Válida 5 minutos. Hacer PUT con el archivo y los headers indicados; luego confirmar con PUT /me/photo.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();
final UploadRequestDto uploadRequestDto = ; // UploadRequestDto | 

try {
    final response = api.meControllerPhotoUploadUrl(uploadRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->meControllerPhotoUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadRequestDto** | [**UploadRequestDto**](UploadRequestDto.md)|  | 

### Return type

[**PresignedUploadDto**](PresignedUploadDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **meControllerUpdate**
> UserDto meControllerUpdate(updateMeDto)

Actualiza mi nombre (la foto se cambia con /me/photo)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();
final UpdateMeDto updateMeDto = ; // UpdateMeDto | 

try {
    final response = api.meControllerUpdate(updateMeDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->meControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateMeDto** | [**UpdateMeDto**](UpdateMeDto.md)|  | 

### Return type

[**UserDto**](UserDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

