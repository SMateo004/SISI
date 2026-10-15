# sisi_api.api.NotificacionesApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**notificationsControllerList**](NotificacionesApi.md#notificationscontrollerlist) | **GET** /me/notifications | Mis avisos, del más reciente al más antiguo
[**notificationsControllerMarkRead**](NotificacionesApi.md#notificationscontrollermarkread) | **POST** /me/notifications/{id}/read | Marcar un aviso como leído
[**notificationsControllerRegisterDevice**](NotificacionesApi.md#notificationscontrollerregisterdevice) | **POST** /me/devices | Registrar el token de push (FCM) de este dispositivo
[**notificationsControllerUnregisterDevice**](NotificacionesApi.md#notificationscontrollerunregisterdevice) | **DELETE** /me/devices/{token} | Dar de baja el token de push (al cerrar sesión)


# **notificationsControllerList**
> NotificationPageDto notificationsControllerList(cursor)

Mis avisos, del más reciente al más antiguo

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getNotificacionesApi();
final String cursor = cursor_example; // String | 

try {
    final response = api.notificationsControllerList(cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificacionesApi->notificationsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 

### Return type

[**NotificationPageDto**](NotificationPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerMarkRead**
> notificationsControllerMarkRead(id)

Marcar un aviso como leído

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getNotificacionesApi();
final String id = id_example; // String | 

try {
    api.notificationsControllerMarkRead(id);
} on DioException catch (e) {
    print('Exception when calling NotificacionesApi->notificationsControllerMarkRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerRegisterDevice**
> notificationsControllerRegisterDevice(registerDeviceDto)

Registrar el token de push (FCM) de este dispositivo

Idempotente. Si el token era de otra cuenta (cambio de sesión), pasa a esta.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getNotificacionesApi();
final RegisterDeviceDto registerDeviceDto = ; // RegisterDeviceDto | 

try {
    api.notificationsControllerRegisterDevice(registerDeviceDto);
} on DioException catch (e) {
    print('Exception when calling NotificacionesApi->notificationsControllerRegisterDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDeviceDto** | [**RegisterDeviceDto**](RegisterDeviceDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerUnregisterDevice**
> notificationsControllerUnregisterDevice(token)

Dar de baja el token de push (al cerrar sesión)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getNotificacionesApi();
final String token = token_example; // String | 

try {
    api.notificationsControllerUnregisterDevice(token);
} on DioException catch (e) {
    print('Exception when calling NotificacionesApi->notificationsControllerUnregisterDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

