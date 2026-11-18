import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowtime/core/theme/app_colors.dart';
import 'package:flowtime/core/widgets/glass_card.dart';
import '../providers/timer_provider.dart';
import '../widgets/circular_timer.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    
    final minutes = (timerState.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (timerState.remainingSeconds % 60).toString().padLeft(2, '0');
    final progress = timerState.totalSeconds > 0 
        ? timerState.remainingSeconds / timerState.totalSeconds 
        : 0.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.deepSpace,
              Color(0xFF161625),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildHeader(context),
                    const Spacer(),
                    _buildFocusLabel(context),
                    const SizedBox(height: 32),
                    CircularTimer(
                      progress: progress,
                      timeString: '$minutes:$seconds',
                    ),
                    const SizedBox(height: 32),
                    _buildStatsRow(context),
                    const SizedBox(height: 24),
                    _buildInsightChip(context),
                    const Spacer(),
                    _buildControls(ref, timerState),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 16,
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.cyanGlow, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'AI Insight: Your peak focus window is usually between 9 AM and 11 AM.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusLabel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.electricIndigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.electricIndigo.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, color: AppColors.cyanGlow, size: 16),
          const SizedBox(width: 8),
          Text(
            'DEEP FOCUS — UNTITLED SESSION',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.cyanGlow,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(context, '0', 'SESSIONS'),
          Container(width: 1, height: 24, color: Colors.white10),
          _buildStatItem(context, '100%', 'FOCUS SCORE'),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FLOWTIME', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2)),
              const Text('Deep Work Session', style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(WidgetRef ref, TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleButton(
          icon: Icons.refresh,
          onPressed: () => ref.read(timerProvider.notifier).resetTimer(),
          isSmall: true,
        ),
        const SizedBox(width: 32),
        _CircleButton(
          icon: state.isRunning ? Icons.pause : Icons.play_arrow,
          onPressed: () {
            if (state.isRunning) {
              ref.read(timerProvider.notifier).pauseTimer();
            } else {
              ref.read(timerProvider.notifier).startTimer();
            }
          },
          isPrimary: true,
        ),
        const SizedBox(width: 32),
        _CircleButton(
          icon: Icons.stop,
          onPressed: () => ref.read(timerProvider.notifier).resetTimer(),
          isSmall: true,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isSmall;

  const _CircleButton({
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isPrimary ? 80.0 : 56.0;
    final iconSize = isPrimary ? 40.0 : 28.0;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary ? AppColors.electricIndigo : Colors.white.withOpacity(0.05),
          boxShadow: isPrimary ? [
            BoxShadow(
              color: AppColors.electricIndigo.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ] : [],
          border: isPrimary ? null : Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}
