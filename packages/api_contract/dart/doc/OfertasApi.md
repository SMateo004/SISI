# sisi_api.api.OfertasApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**offersControllerAccept**](OfertasApi.md#offerscontrolleraccept) | **POST** /requests/{id}/offers/{offerId}/accept | Elegir una oferta (R5.4)
[**offersControllerContact**](OfertasApi.md#offerscontrollercontact) | **GET** /jobs/{id}/contact | Contacto de la contraparte (R5.4, R9.4)
[**offersControllerIncoming**](OfertasApi.md#offerscontrollerincoming) | **GET** /worker/requests | Solicitudes que me llegaron (últimas 24 h)
[**offersControllerIncomingOne**](OfertasApi.md#offerscontrollerincomingone) | **GET** /worker/requests/{id} | Detalle de una solicitud que me llegó (R5.1)
[**offersControllerList**](OfertasApi.md#offerscontrollerlist) | **GET** /requests/{id}/offers | Ofertas de mi solicitud (R5.3)
[**offersControllerOffer**](OfertasApi.md#offerscontrolleroffer) | **POST** /requests/{id}/offers | Ofertar: aceptar el precio o contraofertar (R5.2)


# **offersControllerAccept**
> AcceptOfferResultDto offersControllerAccept(id, offerId)

Elegir una oferta (R5.4)

Crea el trabajo, asigna la solicitud y cierra las demás ofertas. Después, el contacto se pide con GET /jobs/{jobId}/contact.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getOfertasApi();
final String id = id_example; // String | 
final String offerId = offerId_example; // String | 

try {
    final response = api.offersControllerAccept(id, offerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OfertasApi->offersControllerAccept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **offerId** | **String**|  | 

### Return type

[**AcceptOfferResultDto**](AcceptOfferResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offersControllerContact**
> JobContactDto offersControllerContact(id)

Contacto de la contraparte (R5.4, R9.4)

Solo para el empleador y el trabajador del trabajo. Al trabajador también le da la dirección.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getOfertasApi();
final String id = id_example; // String | 

try {
    final response = api.offersControllerContact(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OfertasApi->offersControllerContact: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobContactDto**](JobContactDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offersControllerIncoming**
> List<IncomingRequestDto> offersControllerIncoming()

Solicitudes que me llegaron (últimas 24 h)

Bandeja del trabajador y resincronización al reconectar el socket. Incluye el estado de mi oferta y si me eligieron.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getOfertasApi();

try {
    final response = api.offersControllerIncoming();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OfertasApi->offersControllerIncoming: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;IncomingRequestDto&gt;**](IncomingRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offersControllerIncomingOne**
> IncomingRequestDto offersControllerIncomingOne(id)

Detalle de una solicitud que me llegó (R5.1)

Solo para trabajadores notificados: a los demás les responde 404.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getOfertasApi();
final String id = id_example; // String | 

try {
    final response = api.offersControllerIncomingOne(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OfertasApi->offersControllerIncomingOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**IncomingRequestDto**](IncomingRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offersControllerList**
> List<EmployerOfferDto> offersControllerList(id)

Ofertas de mi solicitud (R5.3)

Precio, calificación, tiempo estimado de llegada y nombre corto del trabajador.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getOfertasApi();
final String id = id_example; // String | 

try {
    final response = api.offersControllerList(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OfertasApi->offersControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List&lt;EmployerOfferDto&gt;**](EmployerOfferDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offersControllerOffer**
> MyOfferDto offersControllerOffer(id, createOfferDto)

Ofertar: aceptar el precio o contraofertar (R5.2)

Solo trabajadores notificados y que sigan elegibles. Una oferta por trabajador: enviar otra la reemplaza mientras no se haya elegido ninguna.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getOfertasApi();
final String id = id_example; // String | 
final CreateOfferDto createOfferDto = ; // CreateOfferDto | 

try {
    final response = api.offersControllerOffer(id, createOfferDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OfertasApi->offersControllerOffer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **createOfferDto** | [**CreateOfferDto**](CreateOfferDto.md)|  | 

### Return type

[**MyOfferDto**](MyOfferDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

