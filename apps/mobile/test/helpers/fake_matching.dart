import 'package:clock/clock.dart';
import 'package:sisi_mobile/core/http/api_exception.dart';
import 'package:sisi_mobile/core/maps/geo_point.dart';
import 'package:sisi_mobile/features/matching/data/availability_repository.dart';
import 'package:sisi_mobile/features/matching/data/location_service.dart';
import 'package:sisi_mobile/features/matching/domain/availability.dart';
import 'package:sisi_mobile/features/offers/data/offers_repository.dart';
import 'package:sisi_mobile/features/offers/domain/offer_models.dart';

/// Solicitud entrante de prueba (plomería, a 850 m, Bs 150).
IncomingRequest testIncoming({
  String id = 'r1',
  IncomingOutcome outcome = IncomingOutcome.abierta,
  MyOffer? myOffer,
  String? jobId,
  Duration respondIn = const Duration(seconds: 45),
}) => IncomingRequest(
  requestId: id,
  outcome: outcome,
  categorySlug: 'plomeria',
  categoryName: 'Plomería',
  description: 'Tengo una fuga debajo del lavaplatos de la cocina.',
  distanceM: 850,
  proposedPriceBs: '150.00',
  referenceMinBs: '80.00',
  referenceMaxBs: '300.00',
  maxCounterBs: '900.00',
  photoUrls: const [],
  ring: 1,
  respondBy: clock.now().add(respondIn),
  myOffer: myOffer,
  jobId: jobId,
);

EmployerOffer testEmployerOffer({
  String id = 'o1',
  String name = 'Ana R.',
  String amountBs = '150.00',
  OfferType type = OfferType.accept,
  int etaMin = 12,
}) => EmployerOffer(
  id: id,
  type: type,
  amountBs: amountBs,
  etaMin: etaMin,
  distanceM: 900,
  workerShortName: name,
  ratingAvg: '4.80',
  ratingCount: 25,
);

class FakeOffersRepository implements OffersRepository {
  FakeOffersRepository({
    List<IncomingRequest>? incoming,
    List<EmployerOffer>? offers,
    this.offerError,
  }) : incoming = incoming ?? [],
       offers = offers ?? [];

  List<IncomingRequest> incoming;
  List<EmployerOffer> offers;
  ApiException? offerError;
  final sentOffers = <(String, OfferType, String?)>[];
  final accepted = <(String, String)>[];
  int listIncomingCalls = 0;
  int listOffersCalls = 0;

  @override
  Future<List<IncomingRequest>> listIncoming() async {
    listIncomingCalls++;
    return incoming;
  }

  @override
  Future<IncomingRequest> getIncoming(String requestId) async =>
      incoming.firstWhere((r) => r.requestId == requestId);

  @override
  Future<MyOffer> offer(
    String requestId, {
    required OfferType type,
    String? amountBs,
  }) async {
    if (offerError != null) throw offerError!;
    sentOffers.add((requestId, type, amountBs));
    final mine = MyOffer(
      id: 'mine',
      type: type,
      amountBs: amountBs ?? '150.00',
      etaMin: 12,
      status: 'activa',
      revision: sentOffers.length,
    );
    incoming = [
      for (final r in incoming)
        r.requestId == requestId
            ? IncomingRequest(
                requestId: r.requestId,
                outcome: r.outcome,
                categorySlug: r.categorySlug,
                categoryName: r.categoryName,
                description: r.description,
                distanceM: r.distanceM,
                proposedPriceBs: r.proposedPriceBs,
                referenceMinBs: r.referenceMinBs,
                referenceMaxBs: r.referenceMaxBs,
                maxCounterBs: r.maxCounterBs,
                photoUrls: r.photoUrls,
                ring: r.ring,
                respondBy: r.respondBy,
                myOffer: mine,
                jobId: r.jobId,
              )
            : r,
    ];
    return mine;
  }

  @override
  Future<List<EmployerOffer>> listOffers(String requestId) async {
    listOffersCalls++;
    return offers;
  }

  @override
  Future<String> accept(String requestId, String offerId) async {
    accepted.add((requestId, offerId));
    return 'job-1';
  }

  @override
  Future<JobContact> contact(String jobId) async => const JobContact(
    jobId: 'job-1',
    role: 'worker',
    name: 'Ana Rojas',
    phone: '+59171234567',
    finalPriceBs: '150.00',
  );
}

class FakeAvailabilityRepository implements AvailabilityRepository {
  FakeAvailabilityRepository({this.available = false, this.denyWith});

  bool available;
  ApiException? denyWith;
  final sentLocations = <GeoPoint>[];

  Availability get _state =>
      Availability(available: available, sendEverySec: 30, staleAfterSec: 600);

  @override
  Future<Availability> get() async => _state;

  @override
  Future<Availability> set({required bool available, GeoPoint? at}) async {
    if (available && denyWith != null) throw denyWith!;
    this.available = available;
    return _state;
  }

  @override
  Future<void> sendLocation(GeoPoint at) async => sentLocations.add(at);
}

class FakeLocationService implements LocationService {
  FakeLocationService({this.access = LocationAccess.granted});

  LocationAccess access;
  int requests = 0;

  @override
  Future<LocationAccess> requestAccess() async {
    requests++;
    return access;
  }

  @override
  Future<GeoPoint> current() async => const GeoPoint(-17.7834, -63.1821);
}
