import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';

// Ana içerik widget'ı
class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final shouldShowSidebar = screenWidth < 870;
    final isNarrow = screenWidth < 870;
    final isWide = screenWidth >= 1200;
    final translations = context.watch<LanguageProvider>().translations;

    return SingleChildScrollView(
      padding: EdgeInsets.all(shouldShowSidebar ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppTheme.gradientStart,
                AppTheme.gradientMiddle,
                AppTheme.gradientEnd,
              ],
            ).createShader(bounds),
            child: Text(
              translations['about']['title'] ?? 'About Me',
              style: TextStyle(
                fontSize: shouldShowSidebar ? 36 : 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            constraints: BoxConstraints(
                maxWidth: shouldShowSidebar ? double.infinity : 1000),
            child: Text(
              translations['about']['content'] ?? '',
              style: TextStyle(
                fontSize: shouldShowSidebar ? 16 : 18,
                color: AppTheme.textColor.withAlpha(128),
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            translations['about']['skills']['title'] ?? 'Skills',
            style: TextStyle(
              fontSize: shouldShowSidebar ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: isNarrow
                ? 2
                : isWide
                    ? 4
                    : 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: isNarrow ? 0.60 : 0.75,
            padding: EdgeInsets.only(bottom: isNarrow ? 20 : 0),
            children: [
              _buildSkillCard(
                translations['about']['skills']['mobile_dev'] ??
                    'Mobile Development',
                'Flutter, Dart, Native Android',
                Icons.phone_android,
                ['Flutter', 'Dart', 'Native Android'],
              ),
              _buildSkillCard(
                translations['about']['skills']['ui_ux'] ?? 'UI/UX Design',
                'Figma, Adobe XD, Material Design',
                Icons.design_services,
                ['Figma', 'Adobe XD', 'Material Design'],
              ),
              _buildSkillCard(
                translations['about']['skills']['backend'] ??
                    'Backend Development',
                'Node.js, Firebase, MongoDB',
                Icons.storage,
                ['Node.js', 'Firebase', 'MongoDB'],
              ),
              _buildSkillCard(
                translations['about']['skills']['version_control'] ??
                    'Version Control',
                'Git, GitHub, GitLab',
                Icons.code,
                ['Git', 'GitHub', 'GitLab'],
              ),
              _buildSkillCard(
                translations['about']['skills']['cloud_services'] ??
                    'Cloud Services',
                'AWS, Firebase, Google Cloud',
                Icons.cloud,
                ['AWS', 'Firebase', 'Google Cloud'],
              ),
              _buildSkillCard(
                translations['about']['skills']['tools_others'] ??
                    'Tools & Others',
                'VS Code, Android Studio, Postman',
                Icons.build,
                ['VS Code', 'Android Studio', 'Postman'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(
      String title, String description, IconData icon, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 2,
            width: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF4D4D),
                  Color(0xFFFF4D4D),
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 16),
          ...items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  IconData getSkillIcon(String skill) {
    switch (skill.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'dart':
        return Icons.code;
      case 'native android':
        return Icons.android;
      case 'figma':
        return Icons.brush;
      case 'adobe xd':
        return Icons.design_services;
      case 'material design':
        return Icons.style;
      case 'node.js':
        return Icons.javascript;
      case 'firebase':
        return Icons.local_fire_department;
      case 'mongodb':
        return Icons.storage;
      case 'git':
        return Icons.source;
      case 'github':
      case 'gitlab':
        return Icons.code;
      case 'aws':
        return Icons.cloud;
      case 'google cloud':
        return Icons.cloud_queue;
      case 'vs code':
        return Icons.code;
      case 'android studio':
        return Icons.android;
      case 'postman':
        return Icons.send;
      default:
        return Icons.circle;
    }
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AboutContent();
  }
}
