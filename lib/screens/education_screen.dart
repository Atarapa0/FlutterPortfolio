// Bu dosya, kullanıcının eğitim bilgilerini gösteren ekranı içerir
// Temel bileşenler:
// - Üniversite eğitimi kartları
// - Sertifika kartları
// - Responsive tasarım desteği
// - Çoklu dil desteği

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';

// Eğitim içeriği ana widget'ı
class EducationContent extends StatelessWidget {
  const EducationContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğine göre responsive tasarım ayarları
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final shouldShowSidebar = screenWidth < 850;
    final provider = context.watch<LanguageProvider>();

    // Sertifika kartları için sütun sayısı hesaplama
    int getCardCount() {
      if (screenWidth >= 1200) return 3;
      if (screenWidth >= 770) return 2;
      return 1;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(shouldShowSidebar ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient efektli başlık
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppTheme.gradientStart,
                AppTheme.gradientMiddle,
                AppTheme.gradientEnd,
              ],
            ).createShader(bounds),
            child: Text(
              provider.getString('education.title', defaultValue: 'Eğitim'),
              style: TextStyle(
                fontSize: shouldShowSidebar ? 36 : 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Üniversite eğitimi başlığı
          Text(
            provider.getString('education.university_education',
                defaultValue: 'Üniversite Eğitimi'),
            style: TextStyle(
              fontSize: isMobile
                  ? 24
                  : isTablet
                      ? 28
                      : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Üniversite eğitimi kartları
          GridView.count(
            crossAxisCount: screenWidth > 800 ? 2 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: screenWidth > 800 ? 2.5 : 1,
            children: [
              // Lisans eğitimi kartı
              _buildEducationCard(
                provider.getString('education.university.bachelor.title',
                    defaultValue: 'Lisans'),
                provider.getString('education.university.bachelor.field',
                    defaultValue: 'Bilgisayar Mühendisliği'),
                provider.getString('education.university.bachelor.school',
                    defaultValue: 'Amasya Üniversitesi'),
                provider.getString('education.university.bachelor.period',
                    defaultValue: '2013 - Devam'),
                provider.getString('education.university.bachelor.degree',
                    defaultValue: 'Lisans derecesi'),
                Icons.school,
                provider.getStringList(
                        'education.university.bachelor.subjects') ??
                    [
                      'Mobil Programlama',
                      'Veri Yapıları',
                      'Veri Tabanı',
                      'Programlama'
                    ],
              ),
              // Ön lisans eğitimi kartı
              _buildEducationCard(
                provider.getString('education.university.master.title',
                    defaultValue: 'Ön Lisans'),
                provider.getString('education.university.master.field',
                    defaultValue: 'Bilgisayar Programcılığı'),
                provider.getString('education.university.master.school',
                    defaultValue: 'İstanbul Aydın Üniversitesi'),
                provider.getString('education.university.master.period',
                    defaultValue: '2019 - 2023'),
                provider.getString('education.university.master.degree',
                    defaultValue: 'Ön Lisans derecesi'),
                Icons.school_outlined,
                provider.getStringList(
                        'education.university.master.subjects') ??
                    [
                      'Programlama',
                      'Veri Yapıları',
                      'Algoritmalar',
                      'Yazılım Mühendisliği'
                    ],
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Sertifikalar başlığı
          Text(
            provider.getString('education.certificates.title',
                defaultValue: 'Sertifikalar & Başarılar'),
            style: TextStyle(
              fontSize: isMobile
                  ? 24
                  : isTablet
                      ? 28
                      : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Sertifika kartları grid görünümü
          GridView.count(
            crossAxisCount: getCardCount(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1.8,
            children: [
              ...(provider.getValue('education.certificates.items')
                          as List<dynamic>? ??
                      [])
                  .map((cert) => _buildCertificateCard(
                        cert['title']?.toString() ?? '',
                        cert['institution']?.toString() ?? '',
                        cert['year']?.toString() ?? '',
                        getIcon(cert['icon']?.toString() ?? ''),
                      ))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  // İkon seçimi için yardımcı metod
  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'code':
        return Icons.code;
      case 'cloud':
        return Icons.cloud;
      case 'design_services':
        return Icons.design_services;
      default:
        return Icons.school;
    }
  }

  // Eğitim kartı oluşturma yardımcı metodu
  Widget _buildEducationCard(
    String type,
    String title,
    String institution,
    String period,
    String degree,
    IconData icon,
    List<String> subjects,
  ) {
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
            type,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withAlpha(178),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            institution,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(178),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            period,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(127),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            degree,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(178),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: subjects
                  .map((subject) => Padding(
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
                                subject,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withAlpha(178),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

// Sertifika kartı oluşturma yardımcı metodu
  Widget _buildCertificateCard(
    String title,
    String institution,
    String year,
    IconData icon,
  ) {
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
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 600,
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
            institution,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(178),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            year,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(127),
            ),
          ),
        ],
      ),
    );
  }
}
