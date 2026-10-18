# sisi_api.api.LegalApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**legalControllerAccept**](LegalApi.md#legalcontrolleraccept) | **POST** /me/legal/accept | Aceptar las versiones vigentes y declarar la mayoría de edad
[**legalControllerCurrent**](LegalApi.md#legalcontrollercurrent) | **GET** /legal/current | Términos de uso y política de privacidad vigentes (ADR-0051)


# **legalControllerAccept**
> LegalPendingDto legalControllerAccept(acceptLegalDto)

Aceptar las versiones vigentes y declarar la mayoría de edad

Queda registrado con versión y fecha. Una versión nueva vuelve a pedirlo.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getLegalApi();
final AcceptLegalDto acceptLegalDto = ; // AcceptLegalDto | 

try {
    final response = api.legalControllerAccept(acceptLegalDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LegalApi->legalControllerAccept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **acceptLegalDto** | [**AcceptLegalDto**](AcceptLegalDto.md)|  | 

### Return type

[**LegalPendingDto**](LegalPendingDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **legalControllerCurrent**
> List<LegalDocumentDto> legalControllerCurrent()

Términos de uso y política de privacidad vigentes (ADR-0051)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getLegalApi();

try {
    final response = api.legalControllerCurrent();
    print(response);
} on DioException catch (e) {
    print('Exception when calling LegalApi->legalControllerCurrent: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;LegalDocumentDto&gt;**](LegalDocumentDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

