# sisi_api.api.RequestsApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**requestsControllerCancel**](RequestsApi.md#requestscontrollercancel) | **POST** /requests/{id}/cancel | Cancela la solicitud (mientras no esté asignada)
[**requestsControllerConfirmPhoto**](RequestsApi.md#requestscontrollerconfirmphoto) | **PUT** /requests/{id}/photos | Confirma una foto subida (verifica el objeto con HEAD)
[**requestsControllerCreate**](RequestsApi.md#requestscontrollercreate) | **POST** /requests | Crea una solicitud en borrador
[**requestsControllerDeletePhoto**](RequestsApi.md#requestscontrollerdeletephoto) | **DELETE** /requests/{id}/photos/{photoId} | Quita una foto del borrador
[**requestsControllerGet**](RequestsApi.md#requestscontrollerget) | **GET** /requests/{id} | Detalle de una solicitud propia
[**requestsControllerListMine**](RequestsApi.md#requestscontrollerlistmine) | **GET** /requests/mine | Mis solicitudes (más recientes primero)
[**requestsControllerPhotoUploadUrl**](RequestsApi.md#requestscontrollerphotouploadurl) | **POST** /requests/{id}/photos/upload-url | URL prefirmada para subir una foto (máx. 4, solo en borrador)
[**requestsControllerPublish**](RequestsApi.md#requestscontrollerpublish) | **POST** /requests/{id}/publish | Publica la solicitud


# **requestsControllerCancel**
> RequestDto requestsControllerCancel(id)

Cancela la solicitud (mientras no esté asignada)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final String id = id_example; // String | 

try {
    final response = api.requestsControllerCancel(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RequestDto**](RequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestsControllerConfirmPhoto**
> RequestDto requestsControllerConfirmPhoto(id, confirmUploadDto)

Confirma una foto subida (verifica el objeto con HEAD)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final String id = id_example; // String | 
final ConfirmUploadDto confirmUploadDto = ; // ConfirmUploadDto | 

try {
    final response = api.requestsControllerConfirmPhoto(id, confirmUploadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerConfirmPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **confirmUploadDto** | [**ConfirmUploadDto**](ConfirmUploadDto.md)|  | 

### Return type

[**RequestDto**](RequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestsControllerCreate**
> CreatedRequestDto requestsControllerCreate(createRequestDto)

Crea una solicitud en borrador

Solo en modo empleador. Categoría activa en la ciudad, descripción de 20 a 1000 caracteres, ubicación dentro de la zona de servicio, dirección y precio > 0. Si el precio está bajo el mínimo de referencia, se crea igual y la respuesta trae una advertencia (R3.2).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final CreateRequestDto createRequestDto = ; // CreateRequestDto | 

try {
    final response = api.requestsControllerCreate(createRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createRequestDto** | [**CreateRequestDto**](CreateRequestDto.md)|  | 

### Return type

[**CreatedRequestDto**](CreatedRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestsControllerDeletePhoto**
> requestsControllerDeletePhoto(id, photoId)

Quita una foto del borrador

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final String id = id_example; // String | 
final String photoId = photoId_example; // String | 

try {
    api.requestsControllerDeletePhoto(id, photoId);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerDeletePhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **photoId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestsControllerGet**
> RequestDto requestsControllerGet(id)

Detalle de una solicitud propia

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final String id = id_example; // String | 

try {
    final response = api.requestsControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RequestDto**](RequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestsControllerListMine**
> RequestPageDto requestsControllerListMine(cursor, limit)

Mis solicitudes (más recientes primero)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final String cursor = cursor_example; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.requestsControllerListMine(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerListMine: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**RequestPageDto**](RequestPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestsControllerPhotoUploadUrl**
> PresignedUploadDto requestsControllerPhotoUploadUrl(id, uploadRequestDto)

URL prefirmada para subir una foto (máx. 4, solo en borrador)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final String id = id_example; // String | 
final UploadRequestDto uploadRequestDto = ; // UploadRequestDto | 

try {
    final response = api.requestsControllerPhotoUploadUrl(id, uploadRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerPhotoUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **uploadRequestDto** | [**UploadRequestDto**](UploadRequestDto.md)|  | 

### Return type

[**PresignedUploadDto**](PresignedUploadDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestsControllerPublish**
> PublishResultDto requestsControllerPublish(id)

Publica la solicitud

Pasa por moderación (R3.3). Si hay coincidencias queda \"retenida\" con un mensaje neutral; si no, pasa a \"buscando\" y empieza la búsqueda de trabajadores. Límite: 10 por hora y 30 por día por usuario.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getRequestsApi();
final String id = id_example; // String | 

try {
    final response = api.requestsControllerPublish(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RequestsApi->requestsControllerPublish: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PublishResultDto**](PublishResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

