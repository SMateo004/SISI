# sisi_api.api.TrabajosApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**jobsControllerCancel**](TrabajosApi.md#jobscontrollercancel) | **POST** /jobs/{id}/cancel | Cancelar el trabajo (cualquiera de las dos partes)
[**jobsControllerConfirm**](TrabajosApi.md#jobscontrollerconfirm) | **POST** /jobs/{id}/confirm | Confirmar el término (empleador, R6.2)
[**jobsControllerDispute**](TrabajosApi.md#jobscontrollerdispute) | **POST** /jobs/{id}/dispute | Hubo un problema (empleador)
[**jobsControllerFinish**](TrabajosApi.md#jobscontrollerfinish) | **POST** /jobs/{id}/finish | Terminé el trabajo (trabajador)
[**jobsControllerGet**](TrabajosApi.md#jobscontrollerget) | **GET** /jobs/{id} | Detalle del trabajo
[**jobsControllerList**](TrabajosApi.md#jobscontrollerlist) | **GET** /jobs | Historial de trabajos (R8.3)
[**jobsControllerLocation**](TrabajosApi.md#jobscontrollerlocation) | **GET** /jobs/{id}/location | Ubicación del trabajador en camino (empleador)
[**jobsControllerOnTheWay**](TrabajosApi.md#jobscontrollerontheway) | **POST** /jobs/{id}/on-the-way | Voy en camino (trabajador)
[**jobsControllerStart**](TrabajosApi.md#jobscontrollerstart) | **POST** /jobs/{id}/start | Empecé el trabajo (trabajador)


# **jobsControllerCancel**
> JobDto jobsControllerCancel(id, cancelJobDto)

Cancelar el trabajo (cualquiera de las dos partes)

Solo asignado o en camino; en curso ya no. Motivo de la lista y nota opcional (moderada). Sin penalidad; la solicitud queda cancelada y el empleador puede volver a publicarla.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 
final CancelJobDto cancelJobDto = ; // CancelJobDto | 

try {
    final response = api.jobsControllerCancel(id, cancelJobDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cancelJobDto** | [**CancelJobDto**](CancelJobDto.md)|  | 

### Return type

[**JobDto**](JobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerConfirm**
> JobDto jobsControllerConfirm(id)

Confirmar el término (empleador, R6.2)

en_curso → terminado. Calcula la comisión (R6.3).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 

try {
    final response = api.jobsControllerConfirm(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerConfirm: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobDto**](JobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerDispute**
> JobDto jobsControllerDispute(id, disputeJobDto)

Hubo un problema (empleador)

Después de que el trabajador marcó terminado. Frena la autoconfirmación; lo resuelve un administrador.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 
final DisputeJobDto disputeJobDto = ; // DisputeJobDto | 

try {
    final response = api.jobsControllerDispute(id, disputeJobDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **disputeJobDto** | [**DisputeJobDto**](DisputeJobDto.md)|  | 

### Return type

[**JobDto**](JobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerFinish**
> JobDto jobsControllerFinish(id)

Terminé el trabajo (trabajador)

Solo en curso. Queda esperando la confirmación del empleador; si no responde en el plazo (24 h), se confirma solo.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 

try {
    final response = api.jobsControllerFinish(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerFinish: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobDto**](JobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerGet**
> JobDto jobsControllerGet(id)

Detalle del trabajo

Estado, línea de tiempo y acciones permitidas. Solo para las dos partes.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 

try {
    final response = api.jobsControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobDto**](JobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerList**
> JobPageDto jobsControllerList(role, cursor, limit)

Historial de trabajos (R8.3)

Como trabajador incluye la comisión y el neto de cada trabajo terminado.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String role = role_example; // String | Historial como trabajador o como empleador
final String cursor = cursor_example; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.jobsControllerList(role, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **role** | **String**| Historial como trabajador o como empleador | 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**JobPageDto**](JobPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerLocation**
> JobLocationDto jobsControllerLocation(id)

Ubicación del trabajador en camino (empleador)

Para resincronizar el mapa; en vivo llega por job:location. Solo mientras va en camino (409 JOB_LOCATION_UNAVAILABLE).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 

try {
    final response = api.jobsControllerLocation(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobLocationDto**](JobLocationDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerOnTheWay**
> JobDto jobsControllerOnTheWay(id)

Voy en camino (trabajador)

asignado → en_camino

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 

try {
    final response = api.jobsControllerOnTheWay(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerOnTheWay: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobDto**](JobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **jobsControllerStart**
> JobDto jobsControllerStart(id)

Empecé el trabajo (trabajador)

en_camino → en_curso

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getTrabajosApi();
final String id = id_example; // String | 

try {
    final response = api.jobsControllerStart(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TrabajosApi->jobsControllerStart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobDto**](JobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

