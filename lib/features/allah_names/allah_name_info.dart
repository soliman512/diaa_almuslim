import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';

class AllahNameInfoBottomSheet extends StatelessWidget {
  final String name;
  final String meaning;
  final double fontSizeFactor;

  // Premium Color Palette
  static const Color _darkTeal = Color(0xFF0F3943);
  static const Color _lightTeal = Color(0xFF1E656B);
  static const Color _goldAccent = Color(0xFFDFAC6B);

  const AllahNameInfoBottomSheet({
    super.key,
    required this.name,
    required this.meaning,
    this.fontSizeFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    final bool isCompoundName = name.trim().contains(' ');

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.7, // 70% minimum screen height
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_darkTeal, _lightTeal],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      clipBehavior: Clip.antiAlias, 
      child: Stack(
        children: [
          Positioned(
            top: -screenWidth * 0.1,
            right: -screenWidth * 0.2,
            child: Opacity(
              opacity: 0.03, // 3% opacity for a very subtle, premium feel
              child: Image.asset(
                ConstIcons.islamicMandala,
                width: screenWidth * 1.2,
                height: screenWidth * 1.2,
                color: Colors.white,
              ),
            ),
          ),

          // 2. Foreground Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: bottomPadding + 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Premium Drag Handle
                  _buildDragHandle(),
                  const SizedBox(height: 48),

                  // Elegant Header
                  _buildPremiumDivider(),
                  const SizedBox(height: 24),
                  
                  // Allah's Name Typography
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _goldAccent,
                      fontSize: isCompoundName ? 42 : 56,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'el-messiri',
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: const Offset(0, 8),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  _buildPremiumDivider(),
                  const SizedBox(height: 48),

                  // Premium Content Card
                  _buildMeaningCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a subtle, elegant drag handle at the top.
  Widget _buildDragHandle() {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: _goldAccent.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  /// Builds a modern, custom geometric divider using Flutter widgets.
  Widget _buildPremiumDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left fading line
        Container(
          width: 80,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, _goldAccent.withValues(alpha: 0.6)],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Center geometric diamond
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: _goldAccent, width: 1.5),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Right fading line
        Container(
          width: 80,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_goldAccent.withValues(alpha: 0.6), Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the luxury card container for the meaning text.
  Widget _buildMeaningCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        // Darker transparent background for contrast
        color: _darkTeal.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _goldAccent.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(fontSizeFactor),
        ),
        child: Text(
          meaning,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8, // Generous line height for breathability
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.95), // Softer white
                letterSpacing: 0.3,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}