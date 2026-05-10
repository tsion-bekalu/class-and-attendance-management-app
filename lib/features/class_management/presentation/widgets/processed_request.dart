import 'package:flutter/material.dart';
import '../../domain/entities/join_request.dart';

class ProcessedRequestCard extends StatelessWidget {
  final JoinRequest request;

  const ProcessedRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final isApproved = request.status == JoinRequestStatus.approved;

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          _profile(),
          const SizedBox(width: 14),
          Expanded(child: _info()),
          _statusBadge(isApproved),
        ],
      ),
    );
  }

  Widget _profile() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_outline,
        color: Color(0xFF4B5563),
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

  Widget _statusBadge(bool isApproved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isApproved ? const Color(0xFFD8F7E4) : const Color(0xFFFFE2E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isApproved ? "approved" : "rejected",
        style: TextStyle(
          color: isApproved ? const Color(0xFF20A15A) : const Color(0xFFFF4D4F),
          fontWeight: FontWeight.w500,
        ),
      ),
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
