// Ana Sayfa Ekranı
// Bu dosya, uygulamanın ana sayfasını ve kullanıcı profilini gösteren ekranı içerir
// Ekran üç ana bölümden oluşur:
// 1. Profil resmi ve kişisel bilgiler
// 2. Yetenekler ve uzmanlık alanları
// 3. Sosyal medya bağlantıları

import '../providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../utils/app_theme.dart';

// Ana sayfa içeriği widget'ı
// StatelessWidget kullanılarak performans optimizasyonu sağlanmıştır
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğine göre responsive tasarım için değişkenler
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Mobil görünüm kontrolü
    final isTablet =
        screenWidth >= 600 && screenWidth < 1200; // Tablet görünüm kontrolü
    final provider = Provider.of<LanguageProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile
          ? 16
          : isTablet
              ? 24
              : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            Center(child: _buildProfileSection(isMobile: true)),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.gradientStart.withAlpha(25),
                      AppTheme.gradientEnd.withAlpha(25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentColor.withAlpha(51),
                  ),
                ),
                child: Text(
                  provider.translations['home']['role'] ??
                      'Flutter Mobile Developer \n & UI/UX Developer',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
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
                          provider.translations['home']?['hello'] ?? 'Merhaba,',
                          style: TextStyle(
                            fontSize: isTablet ? 40 : 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: AppTheme.gradientStart.withAlpha(127),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: isTablet ? 40 : 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              provider.translations['home']?['name'] ??
                                  'Furkan Erdoğan',
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          isRepeatingAnimation: false,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 48),
                  _buildProfileSection(isMobile: false),
                ],
              ],
            ),
          ],
          if (!isMobile) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.gradientStart.withAlpha(25),
                    AppTheme.gradientEnd.withAlpha(25),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentColor.withAlpha(51),
                ),
              ),
              child: Text(
                provider.translations['home']['role'] ??
                    'Flutter Mobile Developer \n & UI/UX Developer',
                style: TextStyle(
                  fontSize: isTablet ? 22 : 24,
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          Container(
            constraints: BoxConstraints(
                maxWidth: isMobile
                    ? double.infinity
                    : isTablet
                        ? 800
                        : 1000),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withAlpha(76),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.accentColor.withAlpha(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.code,
                        color: AppTheme.accentColor,
                        size: isMobile ? 20 : 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      provider.translations['about']['title'] ?? 'Hakkımda',
                      style: TextStyle(
                        fontSize: isMobile
                            ? 18
                            : isTablet
                                ? 20
                                : 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  provider.translations['home']?['intro'] ?? '',
                  style: TextStyle(
                    fontSize: isMobile
                        ? 16
                        : isTablet
                            ? 17
                            : 18,
                    color: AppTheme.textColor.withAlpha(178),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            provider.translations['home']['tools_others'] ?? 'Tools & Others',
            style: TextStyle(
              fontSize: isMobile
                  ? 24
                  : isTablet
                      ? 28
                      : 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: isMobile
                ? 1
                : isTablet
                    ? 2
                    : 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: isMobile
                ? 1.5
                : isTablet
                    ? 1.5
                    : 2.5,
            children: [
              _buildSkillCard(
                provider.translations['home']?['skills_1'] ??
                    'Flutter, Dart, Native Android',
                'Flutter, Dart, Native Android',
                Icons.phone_android,
              ),
              _buildSkillCard(
                provider.translations['home']?['skills_2'] ??
                    'Figma, Adobe XD, Material Design',
                'Figma, Adobe XD, Material Design',
                Icons.design_services,
              ),
              _buildSkillCard(
                provider.translations['home']?['skills_3'] ??
                    'Node.js, Firebase, MongoDB',
                'Node.js, Firebase, MongoDB',
                Icons.storage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({required bool isMobile}) {
    return Container(
      width: isMobile ? 200 : 300,
      height: isMobile ? 200 : 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.gradientStart.withAlpha(25),
            AppTheme.gradientEnd.withAlpha(25),
          ],
        ),
        border: Border.all(
          color: AppTheme.accentColor.withAlpha(51),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/profile.png',
          width: isMobile ? 200 : 300,
          height: isMobile ? 200 : 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSkillCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 29),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
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
              color: AppTheme.primaryColor.withAlpha(25),
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
              color: Colors.white.withAlpha(178),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeContent(),
    );
  }
}
