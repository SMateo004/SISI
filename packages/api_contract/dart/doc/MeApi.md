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
[**meDeletionControllerCheck**](MeApi.md#medeletioncontrollercheck) | **GET** /me/deletion | ¿Puedo eliminar mi cuenta? Qué se borra, qué se conserva y qué lo impide
[**meDeletionControllerCode**](MeApi.md#medeletioncontrollercode) | **POST** /me/deletion/code | Envía el código de confirmación a mi celular
[**meDeletionControllerDelete**](MeApi.md#medeletioncontrollerdelete) | **POST** /me/deletion | Eliminar mi cuenta con el código recibido (no se puede deshacer)
[**webDeletionControllerCode**](MeApi.md#webdeletioncontrollercode) | **POST** /account-deletion/code | Pide el código para eliminar una cuenta
[**webDeletionControllerDelete**](MeApi.md#webdeletioncontrollerdelete) | **POST** /account-deletion | Eliminar la cuenta de ese número con el código (no se puede deshacer)


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
> MeDto meControllerMe()

Mi cuenta

legalPending: textos vigentes que falta aceptar (la app muestra la pantalla de aceptación).

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

[**MeDto**](MeDto.md)

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

# **meDeletionControllerCheck**
> DeletionCheckDto meDeletionControllerCheck()

¿Puedo eliminar mi cuenta? Qué se borra, qué se conserva y qué lo impide

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();

try {
    final response = api.meDeletionControllerCheck();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->meDeletionControllerCheck: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DeletionCheckDto**](DeletionCheckDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **meDeletionControllerCode**
> meDeletionControllerCode()

Envía el código de confirmación a mi celular

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();

try {
    api.meDeletionControllerCode();
} on DioException catch (e) {
    print('Exception when calling MeApi->meDeletionControllerCode: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **meDeletionControllerDelete**
> meDeletionControllerDelete(confirmDeletionDto)

Eliminar mi cuenta con el código recibido (no se puede deshacer)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();
final ConfirmDeletionDto confirmDeletionDto = ; // ConfirmDeletionDto | 

try {
    api.meDeletionControllerDelete(confirmDeletionDto);
} on DioException catch (e) {
    print('Exception when calling MeApi->meDeletionControllerDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **confirmDeletionDto** | [**ConfirmDeletionDto**](ConfirmDeletionDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **webDeletionControllerCode**
> webDeletionControllerCode(webDeletionCodeDto)

Pide el código para eliminar una cuenta

La respuesta es la misma tenga o no cuenta el número (solo se envía SMS si la tiene).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();
final WebDeletionCodeDto webDeletionCodeDto = ; // WebDeletionCodeDto | 

try {
    api.webDeletionControllerCode(webDeletionCodeDto);
} on DioException catch (e) {
    print('Exception when calling MeApi->webDeletionControllerCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **webDeletionCodeDto** | [**WebDeletionCodeDto**](WebDeletionCodeDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **webDeletionControllerDelete**
> webDeletionControllerDelete(webDeletionDto)

Eliminar la cuenta de ese número con el código (no se puede deshacer)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMeApi();
final WebDeletionDto webDeletionDto = ; // WebDeletionDto | 

try {
    api.webDeletionControllerDelete(webDeletionDto);
} on DioException catch (e) {
    print('Exception when calling MeApi->webDeletionControllerDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **webDeletionDto** | [**WebDeletionDto**](WebDeletionDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

