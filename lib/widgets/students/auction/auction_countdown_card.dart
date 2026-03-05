import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/auction_model.dart';

class AuctionCountdownCard extends StatefulWidget {
  final AuctionEvent event;

  const AuctionCountdownCard({super.key, required this.event});

  @override
  State<AuctionCountdownCard> createState() => _AuctionCountdownCardState();
}

class _AuctionCountdownCardState extends State<AuctionCountdownCard> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.event.eventDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remaining = widget.event.eventDate.difference(DateTime.now());
        if (_remaining.isNegative) _remaining = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmt2(int n) => n.toString().padLeft(2, '0');

  String _dateLabel() {
    final d = widget.event.eventDate;
    return '${d.year} M${_fmt2(d.month)} ${_fmt2(d.day)} - ${_fmt2(d.hour)}:${_fmt2(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final days    = _remaining.inDays;
    final hours   = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF3B00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Clock icon
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            widget.event.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),

          // Date
          Text(
            _dateLabel(),
            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            widget.event.description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),

          // Countdown boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CountBox(value: days,    label: 'Kun'),
              _CountBox(value: hours,   label: 'Soat'),
              _CountBox(value: minutes, label: 'Daqiqa'),
              _CountBox(value: seconds, label: 'Soniya'),
            ],
          ),
        ]),
      ),
    );
  }
}

class _CountBox extends StatelessWidget {
  final int value;
  final String label;
  const _CountBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(children: [
    Container(
      width: 64, height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        value.toString().padLeft(2, '0'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const SizedBox(height: 6),
    Text(label, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11)),
  ]);
}