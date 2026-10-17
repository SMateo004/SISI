import 'package:sisi_api/src/model/accept_offer_result_dto.dart';
import 'package:sisi_api/src/model/admin_category_city_dto.dart';
import 'package:sisi_api/src/model/admin_category_dto.dart';
import 'package:sisi_api/src/model/admin_disputed_job_dto.dart';
import 'package:sisi_api/src/model/admin_held_message_dto.dart';
import 'package:sisi_api/src/model/admin_held_request_dto.dart';
import 'package:sisi_api/src/model/admin_jobs_controller_resolve200_response.dart';
import 'package:sisi_api/src/model/admin_report_dto.dart';
import 'package:sisi_api/src/model/api_error_body.dart';
import 'package:sisi_api/src/model/availability_dto.dart';
import 'package:sisi_api/src/model/cancel_job_dto.dart';
import 'package:sisi_api/src/model/category_dto.dart';
import 'package:sisi_api/src/model/chat_message_dto.dart';
import 'package:sisi_api/src/model/chat_page_dto.dart';
import 'package:sisi_api/src/model/confirm_upload_dto.dart';
import 'package:sisi_api/src/model/create_moderation_term_dto.dart';
import 'package:sisi_api/src/model/create_offer_dto.dart';
import 'package:sisi_api/src/model/create_report_dto.dart';
import 'package:sisi_api/src/model/create_request_dto.dart';
import 'package:sisi_api/src/model/create_review_dto.dart';
import 'package:sisi_api/src/model/created_request_dto.dart';
import 'package:sisi_api/src/model/dispute_job_dto.dart';
import 'package:sisi_api/src/model/document_upload_request_dto.dart';
import 'package:sisi_api/src/model/document_url_dto.dart';
import 'package:sisi_api/src/model/employer_offer_dto.dart';
import 'package:sisi_api/src/model/employer_rating_dto.dart';
import 'package:sisi_api/src/model/feature_flag_dto.dart';
import 'package:sisi_api/src/model/health_check_dto.dart';
import 'package:sisi_api/src/model/health_checks_dto.dart';
import 'package:sisi_api/src/model/health_response_dto.dart';
import 'package:sisi_api/src/model/incoming_photo_dto.dart';
import 'package:sisi_api/src/model/incoming_request_dto.dart';
import 'package:sisi_api/src/model/job_cancellation_dto.dart';
import 'package:sisi_api/src/model/job_category_dto.dart';
import 'package:sisi_api/src/model/job_contact_dto.dart';
import 'package:sisi_api/src/model/job_counterpart_dto.dart';
import 'package:sisi_api/src/model/job_dto.dart';
import 'package:sisi_api/src/model/job_location_dto.dart';
import 'package:sisi_api/src/model/job_page_dto.dart';
import 'package:sisi_api/src/model/job_reviews_dto.dart';
import 'package:sisi_api/src/model/job_timeline_dto.dart';
import 'package:sisi_api/src/model/location_update_dto.dart';
import 'package:sisi_api/src/model/location_update_result_dto.dart';
import 'package:sisi_api/src/model/login_response_dto.dart';
import 'package:sisi_api/src/model/mark_read_dto.dart';
import 'package:sisi_api/src/model/mark_read_result_dto.dart';
import 'package:sisi_api/src/model/mode_denied_dto.dart';
import 'package:sisi_api/src/model/moderation_term_dto.dart';
import 'package:sisi_api/src/model/my_offer_dto.dart';
import 'package:sisi_api/src/model/my_review_dto.dart';
import 'package:sisi_api/src/model/notification_dto.dart';
import 'package:sisi_api/src/model/notification_page_dto.dart';
import 'package:sisi_api/src/model/offer_worker_dto.dart';
import 'package:sisi_api/src/model/otp_requested_dto.dart';
import 'package:sisi_api/src/model/presigned_upload_dto.dart';
import 'package:sisi_api/src/model/price_range_dto.dart';
import 'package:sisi_api/src/model/public_review_dto.dart';
import 'package:sisi_api/src/model/publish_result_dto.dart';
import 'package:sisi_api/src/model/read_all_result_dto.dart';
import 'package:sisi_api/src/model/received_review_dto.dart';
import 'package:sisi_api/src/model/refresh_token_dto.dart';
import 'package:sisi_api/src/model/register_device_dto.dart';
import 'package:sisi_api/src/model/reject_request_dto.dart';
import 'package:sisi_api/src/model/report_dto.dart';
import 'package:sisi_api/src/model/reported_user_dto.dart';
import 'package:sisi_api/src/model/request_category_dto.dart';
import 'package:sisi_api/src/model/request_dto.dart';
import 'package:sisi_api/src/model/request_otp_dto.dart';
import 'package:sisi_api/src/model/request_page_dto.dart';
import 'package:sisi_api/src/model/request_photo_dto.dart';
import 'package:sisi_api/src/model/request_warning_dto.dart';
import 'package:sisi_api/src/model/resolve_dispute_dto.dart';
import 'package:sisi_api/src/model/resolve_report_dto.dart';
import 'package:sisi_api/src/model/resolve_report_result_dto.dart';
import 'package:sisi_api/src/model/reverse_geocode_dto.dart';
import 'package:sisi_api/src/model/send_message_dto.dart';
import 'package:sisi_api/src/model/sent_message_dto.dart';
import 'package:sisi_api/src/model/set_availability_dto.dart';
import 'package:sisi_api/src/model/set_feature_flag_dto.dart';
import 'package:sisi_api/src/model/submit_upgrade_dto.dart';
import 'package:sisi_api/src/model/switch_mode_dto.dart';
import 'package:sisi_api/src/model/tokens_dto.dart';
import 'package:sisi_api/src/model/tracked_point_dto.dart';
import 'package:sisi_api/src/model/unread_count_dto.dart';
import 'package:sisi_api/src/model/update_category_dto.dart';
import 'package:sisi_api/src/model/update_me_dto.dart';
import 'package:sisi_api/src/model/update_moderation_term_dto.dart';
import 'package:sisi_api/src/model/upload_request_dto.dart';
import 'package:sisi_api/src/model/upsert_category_city_dto.dart';
import 'package:sisi_api/src/model/user_dto.dart';
import 'package:sisi_api/src/model/user_reviews_dto.dart';
import 'package:sisi_api/src/model/verify_otp_dto.dart';
import 'package:sisi_api/src/model/worker_document_status_dto.dart';
import 'package:sisi_api/src/model/worker_profile_dto.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AcceptOfferResultDto':
          return AcceptOfferResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminCategoryCityDto':
          return AdminCategoryCityDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminCategoryDto':
          return AdminCategoryDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminDisputedJobDto':
          return AdminDisputedJobDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminHeldMessageDto':
          return AdminHeldMessageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminHeldRequestDto':
          return AdminHeldRequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminJobsControllerResolve200Response':
          return AdminJobsControllerResolve200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminReportDto':
          return AdminReportDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiErrorBody':
          return ApiErrorBody.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AvailabilityDto':
          return AvailabilityDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CancelJobDto':
          return CancelJobDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CategoryDto':
          return CategoryDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChatMessageDto':
          return ChatMessageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChatPageDto':
          return ChatPageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConfirmUploadDto':
          return ConfirmUploadDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateModerationTermDto':
          return CreateModerationTermDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateOfferDto':
          return CreateOfferDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateReportDto':
          return CreateReportDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateRequestDto':
          return CreateRequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateReviewDto':
          return CreateReviewDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreatedRequestDto':
          return CreatedRequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DisputeJobDto':
          return DisputeJobDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentUploadRequestDto':
          return DocumentUploadRequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentUrlDto':
          return DocumentUrlDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'EmployerOfferDto':
          return EmployerOfferDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'EmployerRatingDto':
          return EmployerRatingDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FeatureFlagDto':
          return FeatureFlagDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthCheckDto':
          return HealthCheckDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthChecksDto':
          return HealthChecksDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthResponseDto':
          return HealthResponseDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IncomingPhotoDto':
          return IncomingPhotoDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IncomingRequestDto':
          return IncomingRequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobCancellationDto':
          return JobCancellationDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobCategoryDto':
          return JobCategoryDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobContactDto':
          return JobContactDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobCounterpartDto':
          return JobCounterpartDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobDto':
          return JobDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobLocationDto':
          return JobLocationDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobPageDto':
          return JobPageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobReviewsDto':
          return JobReviewsDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobTimelineDto':
          return JobTimelineDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LocationUpdateDto':
          return LocationUpdateDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LocationUpdateResultDto':
          return LocationUpdateResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginResponseDto':
          return LoginResponseDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MarkReadDto':
          return MarkReadDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MarkReadResultDto':
          return MarkReadResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ModeDeniedDto':
          return ModeDeniedDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ModerationTermDto':
          return ModerationTermDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MyOfferDto':
          return MyOfferDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MyReviewDto':
          return MyReviewDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'NotificationDto':
          return NotificationDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'NotificationPageDto':
          return NotificationPageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OfferWorkerDto':
          return OfferWorkerDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OtpRequestedDto':
          return OtpRequestedDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PresignedUploadDto':
          return PresignedUploadDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PriceRangeDto':
          return PriceRangeDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PublicReviewDto':
          return PublicReviewDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PublishResultDto':
          return PublishResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReadAllResultDto':
          return ReadAllResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReceivedReviewDto':
          return ReceivedReviewDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshTokenDto':
          return RefreshTokenDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RegisterDeviceDto':
          return RegisterDeviceDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RejectRequestDto':
          return RejectRequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReportDto':
          return ReportDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReportedUserDto':
          return ReportedUserDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequestCategoryDto':
          return RequestCategoryDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequestDto':
          return RequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequestOtpDto':
          return RequestOtpDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequestPageDto':
          return RequestPageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequestPhotoDto':
          return RequestPhotoDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequestWarningDto':
          return RequestWarningDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResolveDisputeDto':
          return ResolveDisputeDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResolveReportDto':
          return ResolveReportDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResolveReportResultDto':
          return ResolveReportResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReverseGeocodeDto':
          return ReverseGeocodeDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SendMessageDto':
          return SendMessageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SentMessageDto':
          return SentMessageDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SetAvailabilityDto':
          return SetAvailabilityDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SetFeatureFlagDto':
          return SetFeatureFlagDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubmitUpgradeDto':
          return SubmitUpgradeDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SwitchModeDto':
          return SwitchModeDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TokensDto':
          return TokensDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrackedPointDto':
          return TrackedPointDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UnreadCountDto':
          return UnreadCountDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateCategoryDto':
          return UpdateCategoryDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateMeDto':
          return UpdateMeDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateModerationTermDto':
          return UpdateModerationTermDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UploadRequestDto':
          return UploadRequestDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpsertCategoryCityDto':
          return UpsertCategoryCityDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserDto':
          return UserDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserReviewsDto':
          return UserReviewsDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerifyOtpDto':
          return VerifyOtpDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WorkerDocumentStatusDto':
          return WorkerDocumentStatusDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WorkerProfileDto':
          return WorkerProfileDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }