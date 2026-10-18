# sisi_api.api.AppApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**clientAppControllerConfig**](AppApi.md#clientappcontrollerconfig) | **GET** /app/config | Configuración de la app al abrirla


# **clientAppControllerConfig**
> AppConfigDto clientAppControllerConfig(platform, version)

Configuración de la app al abrirla

Versión mínima por plataforma (si la instalada es menor, upgradeRequired y la tienda), WhatsApp de soporte y versiones legales vigentes.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAppApi();
final String platform = platform_example; // String | 
final String version = 0.9.0; // String | Versión instalada

try {
    final response = api.clientAppControllerConfig(platform, version);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AppApi->clientAppControllerConfig: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **platform** | **String**|  | 
 **version** | **String**| Versión instalada | [optional] 

### Return type

[**AppConfigDto**](AppConfigDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

