# sisi_api.api.WorkerApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**workerLocationsControllerGet**](WorkerApi.md#workerlocationscontrollerget) | **GET** /worker/availability | Mi disponibilidad y última ubicación recibida
[**workerLocationsControllerSet**](WorkerApi.md#workerlocationscontrollerset) | **PUT** /worker/availability | Toggle \&quot;Disponible\&quot;
[**workerLocationsControllerUpdate**](WorkerApi.md#workerlocationscontrollerupdate) | **POST** /worker/location | Ubicación en vivo (solo con \&quot;Disponible\&quot; y la app en primer plano)
[**workerMeControllerConfirmDocument**](WorkerApi.md#workermecontrollerconfirmdocument) | **PUT** /me/worker/documents/{type} | Confirma un documento subido
[**workerMeControllerDocumentUploadUrl**](WorkerApi.md#workermecontrollerdocumentuploadurl) | **POST** /me/worker/documents/upload-url | URL prefirmada para subir un documento (CI anverso, reverso o selfie)
[**workerMeControllerGetProfile**](WorkerApi.md#workermecontrollergetprofile) | **GET** /me/worker | Mi perfil de trabajador y el estado de cada documento
[**workerMeControllerSubmitUpgrade**](WorkerApi.md#workermecontrollersubmitupgrade) | **POST** /me/worker/upgrade | Envía la solicitud para trabajar (R1.3)
[**workerMeControllerSwitchMode**](WorkerApi.md#workermecontrollerswitchmode) | **PATCH** /me/mode | Interruptor empleador / trabajador


# **workerLocationsControllerGet**
> AvailabilityDto workerLocationsControllerGet()

Mi disponibilidad y última ubicación recibida

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();

try {
    final response = api.workerLocationsControllerGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerLocationsControllerGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AvailabilityDto**](AvailabilityDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **workerLocationsControllerSet**
> AvailabilityDto workerLocationsControllerSet(setAvailabilityDto)

Toggle \"Disponible\"

Activar exige modo trabajador, perfil aprobado y la ubicación actual. Sin ubicación en `staleAfterSec`, deja de estar disponible solo (ADR-0024).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();
final SetAvailabilityDto setAvailabilityDto = ; // SetAvailabilityDto | 

try {
    final response = api.workerLocationsControllerSet(setAvailabilityDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerLocationsControllerSet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setAvailabilityDto** | [**SetAvailabilityDto**](SetAvailabilityDto.md)|  | 

### Return type

[**AvailabilityDto**](AvailabilityDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **workerLocationsControllerUpdate**
> LocationUpdateResultDto workerLocationsControllerUpdate(locationUpdateDto)

Ubicación en vivo (solo con \"Disponible\" y la app en primer plano)

Enviar cada `sendEverySec` o al moverse. Postgres se actualiza con throttling.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();
final LocationUpdateDto locationUpdateDto = ; // LocationUpdateDto | 

try {
    final response = api.workerLocationsControllerUpdate(locationUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerLocationsControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **locationUpdateDto** | [**LocationUpdateDto**](LocationUpdateDto.md)|  | 

### Return type

[**LocationUpdateResultDto**](LocationUpdateResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **workerMeControllerConfirmDocument**
> WorkerProfileDto workerMeControllerConfirmDocument(type, confirmUploadDto)

Confirma un documento subido

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();
final String type = type_example; // String | 
final ConfirmUploadDto confirmUploadDto = ; // ConfirmUploadDto | 

try {
    final response = api.workerMeControllerConfirmDocument(type, confirmUploadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerMeControllerConfirmDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | 
 **confirmUploadDto** | [**ConfirmUploadDto**](ConfirmUploadDto.md)|  | 

### Return type

[**WorkerProfileDto**](WorkerProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **workerMeControllerDocumentUploadUrl**
> PresignedUploadDto workerMeControllerDocumentUploadUrl(documentUploadRequestDto)

URL prefirmada para subir un documento (CI anverso, reverso o selfie)

Válida 5 minutos. Luego confirmar con PUT /me/worker/documents/{type}.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();
final DocumentUploadRequestDto documentUploadRequestDto = ; // DocumentUploadRequestDto | 

try {
    final response = api.workerMeControllerDocumentUploadUrl(documentUploadRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerMeControllerDocumentUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentUploadRequestDto** | [**DocumentUploadRequestDto**](DocumentUploadRequestDto.md)|  | 

### Return type

[**PresignedUploadDto**](PresignedUploadDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **workerMeControllerGetProfile**
> WorkerProfileDto workerMeControllerGetProfile()

Mi perfil de trabajador y el estado de cada documento

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();

try {
    final response = api.workerMeControllerGetProfile();
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerMeControllerGetProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**WorkerProfileDto**](WorkerProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **workerMeControllerSubmitUpgrade**
> WorkerProfileDto workerMeControllerSubmitUpgrade(submitUpgradeDto)

Envía la solicitud para trabajar (R1.3)

Requiere teléfono verificado, 18 años cumplidos (hora de Bolivia), CI ambos lados, selfie, categorías activas, transporte y radio de 1 a 10 km. El estado pasa a pendiente_revision.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();
final SubmitUpgradeDto submitUpgradeDto = ; // SubmitUpgradeDto | 

try {
    final response = api.workerMeControllerSubmitUpgrade(submitUpgradeDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerMeControllerSubmitUpgrade: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submitUpgradeDto** | [**SubmitUpgradeDto**](SubmitUpgradeDto.md)|  | 

### Return type

[**WorkerProfileDto**](WorkerProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **workerMeControllerSwitchMode**
> UserDto workerMeControllerSwitchMode(switchModeDto)

Interruptor empleador / trabajador

A employer siempre se puede cambiar. A worker solo con el perfil aprobado; si no, 409 con el motivo y la acción siguiente (R1.5, R1.6).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getWorkerApi();
final SwitchModeDto switchModeDto = ; // SwitchModeDto | 

try {
    final response = api.workerMeControllerSwitchMode(switchModeDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkerApi->workerMeControllerSwitchMode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **switchModeDto** | [**SwitchModeDto**](SwitchModeDto.md)|  | 

### Return type

[**UserDto**](UserDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

