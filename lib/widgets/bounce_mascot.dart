import 'package:flutter/material.dart';

/// Mascot image dengan animasi float/bounce loop yang cute
class BounceMascot extends StatefulWidget {
  final String assetPath;
  final double size;
  final double floatDistance;
  final Duration period;

  const BounceMascot({
    super.key,
    required this.assetPath,
    this.size = 200,
    this.floatDistance = 10,
    this.period = const Duration(milliseconds: 2200),
  });

  @override
  State<BounceMascot> createState() => _BounceMascotState();
}

class _BounceMascotState extends State<BounceMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
    _float = Tween<double>(begin: 0, end: widget.floatDistance).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -_float.value),
        child: child,
      ),
      child: Image.asset(
        widget.assetPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => SizedBox(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: Text('🍵', style: TextStyle(fontSize: widget.size * 0.5)),
          ),
        ),
      ),
    );
  }
}

/// Emoji mascot dengan animasi bounce (fallback tanpa asset)
class BounceEmoji extends StatefulWidget {
  final String emoji;
  final double size;

  const BounceEmoji({super.key, required this.emoji, this.size = 80});

  @override
  State<BounceEmoji> createState() => _BounceEmojiState();
}

class _BounceEmojiState extends State<BounceEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _float = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, -_float.value),
        child: Text(widget.emoji,
            style: TextStyle(fontSize: widget.size, height: 1.0)),
      ),
    );
  }
}
