import 'package:flutter/material.dart';
import '../../domain/entities/join_request.dart';
import 'approve_reject_buttons.dart';

class PendingRequestCard extends StatelessWidget {
  final JoinRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              _profile(),
              const SizedBox(width: 14),
              _info(),
            ],
          ),
          const SizedBox(height: 22),
          ApproveRejectButtons(
            onApprove: onApprove,
            onReject: onReject,
          ),
        ],
      ),
    );
  }

  Widget _profile() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFEAF1FF),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_outline,
        color: Color(0xFF1E5EFF),
        size: 30,
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          request.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.mail_outline, size: 18, color: Color(0xFF6B7280)),
            const SizedBox(width: 6),
            Text(
              request.email,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.08),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
