import 'package:sisi_api/sisi_api.dart';

import 'fakes.dart';

final _t = DateTime.utc(2026, 10, 19, 14);

VerificationRowDto verificationRow({
  String id = 'w1',
  String name = 'Rosa Quispe',
}) => VerificationRowDto(
  userId: id,
  name: name,
  phone: '+59170000010',
  cityName: 'Santa Cruz de la Sierra',
  submittedAt: _t,
  categories: ['Plomería'],
);

VerificationDetailDto verificationDetail({
  String id = 'w1',
  String status = 'pendiente_revision',
}) => VerificationDetailDto(
  userId: id,
  name: 'Rosa Quispe',
  phone: '+59170000010',
  cityName: 'Santa Cruz de la Sierra',
  submittedAt: _t,
  categories: ['Electricidad'],
  status: status,
  birthDate: DateTime.utc(2000, 1, 15),
  age: 26,
  transport: 'moto',
  maxRadiusKm: 5,
  categoryDetails: [
    VerificationCategoryDto(
      id: 'c1',
      name: 'Electricidad',
      extraRequirements: ['certificado_electricista'],
    ),
  ],
  documents: [
    VerificationDocumentDto(
      id: 'd1',
      type: VerificationDocumentDtoTypeEnum.values.first,
      url: 'https://bucket.test/identity/w1/ci_front.jpg?X-Amz-Expires=300',
      expiresAt: _t.add(const Duration(minutes: 5)),
    ),
  ],
);

VerificationResultDto verificationResult(String status) =>
    VerificationResultDto(
      userId: 'w1',
      status: VerificationResultDtoStatusEnum.values.firstWhere(
        (e) => e.value == status,
      ),
      rejectionReason: null,
    );

AdminHeldRequestDto heldRequest({String id = 'r1'}) => AdminHeldRequestDto(
  id: id,
  status: AdminHeldRequestDtoStatusEnum.retenida,
  statusMessage: null,
  category: RequestCategoryDto(id: 'c1', slug: 'limpieza', name: 'Limpieza'),
  cityId: 'sc',
  description: 'Limpieza de la casa y de paso que me traigan marihuana.',
  latitude: -17.78,
  longitude: -63.18,
  address: 'Calle Junín 150',
  proposedPriceBs: '150.00',
  photos: [],
  createdAt: '2026-10-19T14:00:00.000Z',
  publishedAt: null,
  cancelledAt: null,
  ring: null,
  totalRings: 3,
  jobId: null,
  expiresAt: null,
  matches: {
    'matches': [
      {
        'term': 'marihuan*',
        'category': 'drogas',
        'kind': 'word',
        'termId': 't1',
      },
    ],
    'timedOut': false,
  },
  employerId: 'e1',
);

RequestDto requestDto(String id, RequestDtoStatusEnum status) => RequestDto(
  id: id,
  status: status,
  statusMessage: null,
  category: RequestCategoryDto(id: 'c1', slug: 'limpieza', name: 'Limpieza'),
  cityId: 'sc',
  description: 'x',
  latitude: 0,
  longitude: 0,
  address: 'x',
  proposedPriceBs: '150.00',
  photos: [],
  createdAt: '2026-10-19T14:00:00.000Z',
  publishedAt: null,
  cancelledAt: null,
  ring: null,
  totalRings: 3,
  jobId: null,
  expiresAt: null,
);

AdminReportDto report({
  String id = 'rep1',
  String status = 'pendiente',
  num validReporters = 2,
}) => AdminReportDto(
  id: id,
  targetType: AdminReportDtoTargetTypeEnum.values.firstWhere(
    (e) => e.value == 'user',
  ),
  targetId: 'w9',
  reason: AdminReportDtoReasonEnum.values.firstWhere((e) => e.value == 'acoso'),
  status: AdminReportDtoStatusEnum.values.firstWhere((e) => e.value == status),
  createdAt: _t,
  reporterId: 'e2',
  reporterName: 'Carlos',
  reporterPhone: '+59170000020',
  targetSummary: 'Perfil de Juan',
  note: 'Me escribió cosas fuera de lugar.',
  noteHeld: false,
  resolution: null,
  reportedUser: ReportedUserDto(
    id: 'w9',
    name: 'Juan',
    phone: '+59170000030',
    validReporters: validReporters,
    workerStatus: 'aprobado',
    flaggedAt: null,
  ),
);

AdminJobDetailDto jobDetail({String status = 'en_curso'}) => AdminJobDetailDto(
  id: 'j1',
  requestId: 'r1',
  status: status,
  category: JobCategoryDto(slug: 'plomeria', name: 'Plomería'),
  description: 'Gotea la cañería del baño.',
  address: 'Calle Junín 150',
  proposedPriceBs: '150.00',
  finalPriceBs: '170.00',
  commissionPct: '13.00',
  commissionBs: null,
  worker: AdminJobPartyDto(id: 'w1', name: 'Juan', phone: '+59171111111'),
  employer: AdminJobPartyDto(id: 'e1', name: 'Rosa', phone: '+59170012345'),
  disputedAt: _t,
  disputeNote: 'Dejó la cañería goteando.',
  timeline: [
    for (final (action, from, to) in [
      ('START_TRIP', 'asignado', 'en_camino'),
      ('START_WORK', 'en_camino', 'en_curso'),
      ('DISPUTE', 'en_curso', 'en_curso'),
    ])
      AdminJobEventDto(
        action: action,
        fromStatus: from,
        toStatus: to,
        actorRole: AdminJobEventDtoActorRoleEnum.values.first,
        actorId: null,
        note: null,
        at: _t,
      ),
  ],
  chat: [
    AdminJobMessageDto(
      id: 'm1',
      from: AdminJobMessageDtoFromEnum.values.firstWhere(
        (e) => e.value == 'worker',
      ),
      body: 'Te consigo c.o.c.a.i.n.a',
      status: AdminJobMessageDtoStatusEnum.values.firstWhere(
        (e) => e.value == 'retenido',
      ),
      at: _t,
    ),
  ],
  offers: [
    AdminJobOfferDto(
      id: 'o1',
      worker: AdminJobPartyDto(id: 'w1', name: 'Juan', phone: '+59171111111'),
      status: 'aceptada',
      chosen: true,
      history: [
        for (final (kind, amount) in [
          ('creada', '200.00'),
          ('reemplazada', '170.00'),
          ('aceptada', '170.00'),
        ])
          AdminOfferEventDto(
            kind: AdminOfferEventDtoKindEnum.values.firstWhere(
              (e) => e.value == kind,
            ),
            revision: 1,
            type: AdminOfferEventDtoTypeEnum.values.firstWhere(
              (e) => e.value == 'counter',
            ),
            amountBs: amount,
            etaMin: 8,
            at: _t,
          ),
      ],
    ),
  ],
);

BalancePreviewDto preview({bool unblocks = true}) => BalancePreviewDto(
  balanceBeforeBs: '29.90',
  balanceAfterBs: '0.00',
  allocations: [
    PreviewAllocationDto(
      periodId: 'p1',
      paymentReference: 'SISI-2642-R6DXF2',
      amountBs: '29.90',
      periodBalanceAfterBs: '0.00',
      statusAfter: PreviewAllocationDtoStatusAfterEnum.pagado,
    ),
  ],
  blockedNow: true,
  unblocks: unblocks,
);

PaymentResultDto paymentResult() => PaymentResultDto(
  paymentId: 'pay1',
  workerId: 'w1',
  amountBs: '29.90',
  allocations: [],
  balanceBs: '0.00',
);

LedgerPageDto ledger() => LedgerPageDto(
  balanceBs: '29.90',
  items: [
    LedgerRowDto(
      id: '2',
      type: LedgerRowDtoTypeEnum.comision,
      amountBs: '10.40',
      runningBs: '29.90',
      paymentReference: 'SISI-2642-R6DXF2',
      jobId: 'j2',
      paymentId: null,
      correctsEntryId: null,
      reason: null,
      createdAt: _t,
    ),
    LedgerRowDto(
      id: '1',
      type: LedgerRowDtoTypeEnum.comision,
      amountBs: '19.50',
      runningBs: '19.50',
      paymentReference: 'SISI-2642-R6DXF2',
      jobId: 'j1',
      paymentId: null,
      correctsEntryId: null,
      reason: null,
      createdAt: _t,
    ),
  ],
  nextCursor: null,
);

UserProfileDto userProfile({String workerStatus = 'aprobado'}) =>
    UserProfileDto(
      id: 'w1',
      phone: '+59171111111',
      name: 'Juan Pérez',
      role: UserProfileDtoRoleEnum.user,
      activeMode: UserProfileDtoActiveModeEnum.worker,
      cityName: 'Santa Cruz de la Sierra',
      workerStatus: workerStatus,
      flagged: false,
      createdAt: _t,
      employerRating: RatingDto(avg: '0.00', count: 0),
      cancellationsCount: 1,
      flaggedAt: null,
      worker: WorkerSummaryDto(
        status: workerStatus,
        statusChangedAt: _t,
        rating: RatingDto(avg: '4.50', count: 12),
        rejectionReason: null,
        moderationResolution: null,
        categories: ['Plomería'],
        transport: 'moto',
        maxRadiusKm: 10,
        balanceBs: '29.90',
        periods: [],
      ),
      reportCounts: ReportCountsDto(pendiente: 1, valido: 2, descartado: 0),
      reports: [],
      jobsCount: 2,
      jobs: [],
    );

AdminCategoryDto category({String pct = '13.00', String? notice}) =>
    AdminCategoryDto(
      id: 'cat1',
      slug: 'plomeria',
      name: 'Plomería',
      description: null,
      priceMinBs: '80.00',
      priceMaxBs: '300.00',
      commissionPct: pct,
      active: true,
      extraRequirements: [],
      cities: [],
      notice: notice,
    );

SettingDto setting({String value = '45000', bool overridden = false}) =>
    SettingDto(
      key: 'MATCHING_RING_WAIT_MS',
      group: SettingDtoGroupEnum.matching,
      label: 'Espera por anillo',
      help: 'Cuánto se espera en cada anillo antes de ampliar.',
      kind: SettingDtoKindEnum.values.firstWhere((e) => e.value == 'int'),
      unit: SettingDtoUnitEnum.values.firstWhere((e) => e.value == 'ms'),
      min: 15000,
      max: 600000,
      value: value,
      defaultValue: '45000',
      overridden: overridden,
      updatedAt: null,
    );

AuditEntryDto auditEntry({String action = 'billing.payment'}) => AuditEntryDto(
  id: '7',
  adminId: 'a1',
  adminName: 'Ana Admin',
  adminPhone: '+59170000001',
  action: action,
  targetType: 'worker',
  targetId: 'w1',
  before: {'balanceBs': '29.90'},
  after: {'balanceBs': '0.00'},
  reason: 'SISI-2642-R6DXF2',
  ip: '10.0.0.1',
  forwardedFor: null,
  userAgent: null,
  cityId: null,
  createdAt: _t,
);

DashboardDto dashboard() => DashboardDto(
  range: DashboardDtoRangeEnum.day,
  cityId: 'c1',
  cityName: 'Santa Cruz de la Sierra',
  from: DateTime.utc(2026, 10, 19, 4),
  to: DateTime.utc(2026, 10, 20, 4),
  requestsCreated: 12,
  assignmentRatePct: 75,
  expirationRatePct: 8.3,
  avgFirstOfferSec: 95,
  jobsCompleted: 7,
  cancellationsByReason: [
    CancellationCountDto(reason: 'cambio_de_planes', count: 2),
  ],
  commissionGeneratedBs: '136.50',
  commissionCollectedBs: '90.00',
  overdueDebtBs: '58.50',
  overdueWorkers: 3,
  workersAvailableNow: 4,
  queues: counters(verifications: 2),
);
