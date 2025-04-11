import 'package:flutter/material.dart';

class GlassShineEffect extends StatefulWidget {
  final Widget child;

  const GlassShineEffect({super.key, required this.child});

  @override
  _GlassShineEffectState createState() => _GlassShineEffectState();
}

class _GlassShineEffectState extends State<GlassShineEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    ); // biar terus looping

    _startLoopWithDelay();
  }

  void _startLoopWithDelay() async {
    while (mounted) {
      await _controller.forward(from: 0.0);   // jalankan animasi dari awal
      await Future.delayed(Duration(seconds: 1)); // jeda 1 detik
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(-0.0 + 2 * _controller.value, 0),
              colors: [
                Colors.white.withValues(alpha: 0.0),
                Colors.white.withValues(alpha: 0.5),
                Colors.white.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
