import 'package:flutter/material.dart';
import '../../domain/entities/join_request.dart';
import 'package:app/features/class_management/domain/use_cases/get_pending_request.dart';
import '../../domain/use_cases/get_processed_requests.dart';
import '../../domain/use_cases/approve_join_request.dart';
import '../../domain/use_cases/reject_join_request.dart';
import '../../data/class_repository_impl.dart';

// Widgets
import '../widgets/join_request_header.dart';
import '../widgets/pending_request_card.dart';
import 'package:app/features/class_management/presentation/widgets/processed_request.dart';

class JoinRequestsScreen extends StatefulWidget {
  final String classId;
  final String className;

  const JoinRequestsScreen({
    super.key,
    required this.classId,
    required this.className,
  });

  @override
  State<JoinRequestsScreen> createState() => _JoinRequestsScreenState();
}

class _JoinRequestsScreenState extends State<JoinRequestsScreen> {
  late final ClassRepositoryImpl repository;
  late final GetPendingRequests getPendingRequests;
  late final GetProcessedRequests getProcessedRequests;
  late final ApproveJoinRequest approveJoinRequest;
  late final RejectJoinRequest rejectJoinRequest;

  List<JoinRequest> pending = [];
  List<JoinRequest> processed = [];

  @override
  void initState() {
    super.initState();
    repository = ClassRepositoryImpl();
    getPendingRequests = GetPendingRequests(repository);
    getProcessedRequests = GetProcessedRequests(repository);
    approveJoinRequest = ApproveJoinRequest(repository);
    rejectJoinRequest = RejectJoinRequest(repository);
    _load();
  }

  Future<void> _load() async {
    pending = await getPendingRequests(widget.classId);
    processed = await getProcessedRequests(widget.classId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          JoinRequestHeader(className: widget.className),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pending (${pending.length})",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (pending.isEmpty)
                    const Text("No pending requests", style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: pending.map((req) {
                        return PendingRequestCard(
                          request: req,
                          onApprove: () async {
                            await approveJoinRequest(widget.classId, req);
                            _load();
                          },
                          onReject: () async {
                            await rejectJoinRequest(widget.classId, req);
                            _load();
                          },
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 42),

                  Text(
                    "Processed (${processed.length})",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (processed.isEmpty)
                    const Text("No processed requests", style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: processed.map((req) {
                        return ProcessedRequestCard(request: req);
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
