# sisi_api.api.ChatApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chatControllerList**](ChatApi.md#chatcontrollerlist) | **GET** /jobs/{id}/messages | Mensajes del trabajo
[**chatControllerRead**](ChatApi.md#chatcontrollerread) | **POST** /jobs/{id}/messages/read | Marcar como leídos los mensajes recibidos hasta uno (incluido)
[**chatControllerSend**](ChatApi.md#chatcontrollersend) | **POST** /jobs/{id}/messages | Enviar un mensaje (solo texto)


# **chatControllerList**
> ChatPageDto chatControllerList(id, cursor, limit)

Mensajes del trabajo

Del más reciente al más antiguo. Los retenidos solo los ve quien los envió. En vivo llegan por chat:message.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getChatApi();
final String id = id_example; // String | 
final String cursor = cursor_example; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.chatControllerList(id, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ChatApi->chatControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 30]

### Return type

[**ChatPageDto**](ChatPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatControllerRead**
> MarkReadResultDto chatControllerRead(id, markReadDto)

Marcar como leídos los mensajes recibidos hasta uno (incluido)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getChatApi();
final String id = id_example; // String | 
final MarkReadDto markReadDto = ; // MarkReadDto | 

try {
    final response = api.chatControllerRead(id, markReadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ChatApi->chatControllerRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **markReadDto** | [**MarkReadDto**](MarkReadDto.md)|  | 

### Return type

[**MarkReadResultDto**](MarkReadResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatControllerSend**
> SentMessageDto chatControllerSend(id, sendMessageDto)

Enviar un mensaje (solo texto)

Se modera (R9.2): si coincide, queda retenido, no se entrega y vuelve con `notice`. Abierto hasta 24 h después de terminado o cancelado.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getChatApi();
final String id = id_example; // String | 
final SendMessageDto sendMessageDto = ; // SendMessageDto | 

try {
    final response = api.chatControllerSend(id, sendMessageDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ChatApi->chatControllerSend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendMessageDto** | [**SendMessageDto**](SendMessageDto.md)|  | 

### Return type

[**SentMessageDto**](SentMessageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

