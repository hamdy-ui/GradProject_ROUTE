import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingPosterGridWidget extends StatelessWidget {
  const OnboardingPosterGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 3 columns of stylized poster cards with varied heights & colors
    return Stack(
      children: [
        // Rotated collage container
        Positioned(
          top: -120,
          left: -80,
          right: -80,
          height: 750,
          child: Transform.rotate(
            angle: -25 * math.pi / 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildColumn([
                  _posterCard(180, const Color(0xFF1E3A8A)),
                  _posterCard(200, const Color(0xFF831843)),
                  _posterCard(170, const Color(0xFF14532D)),
                  _posterCard(190, const Color(0xFF701A75)),
                ]),
                const SizedBox(width: 16),
                _buildColumn([
                  _posterCard(210, const Color(0xFFB45309)),
                  _posterCard(180, const Color(0xFF0F766E)),
                  _posterCard(220, const Color(0xFF4C1D95)),
                  _posterCard(170, const Color(0xFF991B1B)),
                ]),
                const SizedBox(width: 16),
                _buildColumn([
                  _posterCard(170, const Color(0xFF312E81)),
                  _posterCard(210, const Color(0xFF9A3412)),
                  _posterCard(180, const Color(0xFF065F46)),
                  _posterCard(200, const Color(0xFF581C87)),
                ]),
              ],
            ),
          ),
        ),

        // Dark gradient overlay matching Figma (fade to #121312)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.4, 0.7, 1.0],
                colors: [
                  Colors.transparent,
                  Color(0x80121312),
                  Color(0xE8121312),
                  AppColors.scaffoldBackground,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children
          .map((card) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: card,
              ))
          .toList(),
    );
  }

  Widget _posterCard(double height, Color color) {
    return Container(
      width: 130,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.movie_outlined,
              color: Colors.white.withValues(alpha: 0.25),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
