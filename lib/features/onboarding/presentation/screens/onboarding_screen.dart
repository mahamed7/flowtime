import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flowtime/core/theme/app_colors.dart';
import 'package:flowtime/core/widgets/glass_card.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5, -0.5),
                radius: 1.5,
                colors: [
                  Color(0xFF1A1A3A),
                  AppColors.deepSpace,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    children: [
                      _buildWelcomePage(),
                      _buildGuardianPage(),
                      _buildPersonalityPage(),
                    ],
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.waves, size: 80, color: AppColors.electricIndigo),
          const SizedBox(height: 32),
          Text(
            'Master Your Flow',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'FlowTime combines the Pomodoro technique with AI to help you stay focused.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGuardianPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, size: 80, color: AppColors.cyanGlow),
          const SizedBox(height: 32),
          Text(
            'Screen Guardian',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'We gently monitor your app usage during focus blocks to prevent doom-scrolling.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityPage() {
    final settings = ref.watch(userSettingsProvider);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose Your Coach',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildPersonalityOption(
            'zen',
            '🧘 Zen Coach',
            'Calm, mindful, and patient.',
            settings.aiPersonality == 'zen',
          ),
          const SizedBox(height: 16),
          _buildPersonalityOption(
            'sergeant',
            '⚡ Drill Sergeant',
            'Direct, firm, and motivating.',
            settings.aiPersonality == 'sergeant',
          ),
          const SizedBox(height: 16),
          _buildPersonalityOption(
            'partner',
            '🤝 Accountability Partner',
            'Friendly and encouraging.',
            settings.aiPersonality == 'partner',
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityOption(String id, String title, String subtitle, bool isSelected) {
    return GestureDetector(
      onTap: () => ref.read(userSettingsProvider.notifier).updatePersonality(id),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderRadius: 16,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.cyanGlow),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(3, (index) => _buildDot(index)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentPage < 2) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                ref.read(userSettingsProvider.notifier).completeOnboarding();
                context.go('/home');
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 56),
            ),
            child: Text(_currentPage == 2 ? 'Let\'s Go' : 'Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.electricIndigo : Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
