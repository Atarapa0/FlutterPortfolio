// Projeler Ekranı
// Bu dosya, kullanıcının geliştirdiği projeleri gösteren ekranı içerir
// Her proje için aşağıdaki bilgiler gösterilir:
// - Proje başlığı ve açıklaması
// - Kullanılan teknolojiler
// - Proje görselleri (otomatik geçişli)
// - GitHub bağlantısı

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/language_provider.dart';
import '../utils/app_theme.dart';
import 'dart:async';

// Proje kartları için StatefulWidget
// StatefulWidget kullanılarak resim geçişleri ve animasyonlar yönetilir
class ProjectsContent extends StatefulWidget {
  const ProjectsContent({super.key});

  @override
  State<ProjectsContent> createState() => _ProjectsContentState();
}

class _ProjectsContentState extends State<ProjectsContent> {
  @override
  Widget build(BuildContext context) {
    // Ekran genişliğine göre responsive tasarım için değişkenler
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<LanguageProvider>(context);

    // Ekran genişliğine göre dinamik grid yapılandırması
    final crossAxisCount = screenWidth > 1200
        ? 3 // Geniş ekranlarda 3 sütun
        : screenWidth > 800
            ? 2 // Orta ekranlarda 2 sütun
            : 1; // Mobil ekranlarda 1 sütun

    // Kart boyutları için en-boy oranı ayarı
    final childAspectRatio = screenWidth > 800 ? 0.85 : 0.6;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
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
              provider.getString('projects.title', defaultValue: 'Projects'),
              style: TextStyle(
                fontSize: screenWidth > 800 ? 48 : 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Alt başlık
          Text(
            provider.getString('projects.description',
                defaultValue: 'My projects and works.'),
            style: TextStyle(
              fontSize: screenWidth > 800 ? 18 : 16,
              color: Colors.white.withAlpha(178),
            ),
          ),
          const SizedBox(height: 32),
          // Proje kartları grid görünümü
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: childAspectRatio,
            children: [
              _buildProjectCard(
                provider.translations['projects']['items'][0]['title'] ??
                    'Flutter Portfolio',
                provider.translations['projects']['items'][0]['description'] ??
                    'Personal portfolio website',
                ['Flutter', 'Dart', 'Responsive Design'],
                [
                  'assets/projects/portfolio1.jpeg',
                  'assets/projects/portfolio2.jpeg',
                  'assets/projects/portfolio3.jpeg',
                  'assets/projects/portfolio4.jpeg'
                ],
                'https://github.com/Atarapa0/FlutterPortfolio',
              ),
              _buildProjectCard(
                provider.translations['projects']['items'][1]['title'] ??
                    'Weather App Vol1',
                provider.translations['projects']['items'][1]['description'] ??
                    'Mobile Weather Application',
                ['Flutter', 'REST API', 'Location Services'],
                [
                  'assets/projects/weathervol1-1.png',
                  'assets/projects/weathervol1-2.png'
                ],
                'https://github.com/Atarapa0/Weather_vol2',
              ),
              _buildProjectCard(
                provider.translations['projects']['items'][2]['title'] ??
                    'Weather App Vol2',
                provider.translations['projects']['items'][2]['description'] ??
                    'Mobile Weather Application - UI redesigned',
                ['Flutter', 'REST API', 'Location Services'],
                [
                  'assets/projects/weathervol2-1.png',
                  'assets/projects/weathervol2-2.png'
                ],
                'https://github.com/Atarapa0/Weather_vol3',
              ),
              _buildProjectCard(
                provider.translations['projects']['items'][3]['title'] ??
                    'AudioBooks App',
                provider.translations['projects']['items'][3]['description'] ??
                    'Audiobook application',
                ['Flutter', 'Provider', 'Audio Player'],
                [
                  'assets/projects/audiobook1.png',
                  'assets/projects/audiobook2.png'
                ],
                'https://github.com/Atarapa0/AudioBook',
              ),
              _buildProjectCard(
                provider.translations['projects']['items'][4]['title'] ??
                    'Call Clink Button',
                provider.translations['projects']['items'][4]['description'] ??
                    'WordPress Plugin',
                ['PHP', 'JavaScript', 'CSS'],
                [
                  'assets/projects/callclink1.png',
                  'assets/projects/callclink2.png'
                ],
                'https://github.com/Atarapa0/Call-Clink-Buttom',
              ),
              _buildProjectCard(
                provider.translations['projects']['items'][5]['title'] ??
                    'Library Automation',
                provider.translations['projects']['items'][5]['description'] ??
                    'Library automation system',
                ['C#', 'SQL', 'Console'],
                [
                  'assets/projects/library1.png',
                  'assets/projects/library2.png',
                  'assets/projects/library3.png'
                ],
                'https://github.com/Atarapa0/Library',
              ),
              _buildProjectCard(
                provider.translations['projects']['items'][6]['title'] ??
                    'The Pixel Game',
                provider.translations['projects']['items'][6]['description'] ??
                    'Pixel-style game',
                ['Unity', 'Game Development', 'Animation'],
                ['assets/projects/pixel.png'],
                'https://github.com/Atarapa0/The-Pixel-Game',
              ),
            ],
          ),
        ],
      ),
    );
  }

// Proje kartı oluşturma yardımcı metodu
  Widget _buildProjectCard(
    String title,
    String description,
    List<String> technologies,
    List<String> images,
    String githubLink,
  ) {
    return ProjectCard(
      title: title,
      description: description,
      technologies: technologies,
      images: images,
      githubLink: githubLink,
    );
  }
}

// Proje kartı widget'ı
class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> technologies;
  final List<String> images;
  final String githubLink;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.technologies,
    required this.images,
    required this.githubLink,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Otomatik resim geçişi için zamanlayıcı
    if (widget.images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
        if (_pageController.hasClients) {
          if (_pageController.page?.round() == widget.images.length - 1) {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 33),
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
          // Proje görselleri için slider
          if (widget.images.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.surfaceColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.images.length > 1
                    ? PageView.builder(
                        controller: _pageController,
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            widget.images[index],
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: AppTheme.surfaceColor,
                              child: const Icon(
                                Icons.error_outline,
                                color: AppTheme.primaryColor,
                                size: 32,
                              ),
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        widget.images[0],
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppTheme.surfaceColor,
                          child: const Icon(
                            Icons.error_outline,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                      ),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(178),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.technologies
                .map((tech) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.gradientStart.withAlpha(51),
                            AppTheme.gradientEnd.withAlpha(51),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.code,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tech,
                            style: TextStyle(
                              color: Colors.white.withAlpha(178),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          const Spacer(),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              final Uri url = Uri.parse(widget.githubLink);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.gradientStart.withAlpha(25),
                    AppTheme.gradientEnd.withAlpha(25),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.link,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    provider.getString('projects.github_button',
                        defaultValue: 'GitHub'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
