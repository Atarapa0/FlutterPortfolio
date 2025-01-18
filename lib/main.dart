import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/screens/about_screen.dart';
import 'package:portfolio/screens/contact_screen.dart';
import 'package:portfolio/screens/education_screen.dart';
import 'package:portfolio/screens/projects_screen.dart';
import 'package:portfolio/screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'providers/language_provider.dart';
import 'package:provider/provider.dart';

// Uygulama başlangıç fonksiyonu
void main() async {
  print('Uygulama başlatılıyor...');
  WidgetsFlutterBinding.ensureInitialized();

  // Dil desteği için logger başlatma
  LanguageProvider.initLogger();

  // Varsayılan dil olarak İngilizce yükleniyor
  final languageProvider = LanguageProvider();
  await languageProvider.loadTranslations('en');

  // Uygulama başlatılıyor ve dil sağlayıcı ekleniyor
  runApp(
    ChangeNotifierProvider(
      create: (_) => languageProvider,
      child: const MyApp(),
    ),
  );
}

// Ana uygulama widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

// Uygulama yönlendirme (router) yapılandırması
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Ekran genişliğine göre masaüstü kontrolü
        final isDesktop = MediaQuery.of(context).size.width > 870;
        final provider = Provider.of<LanguageProvider>(context);

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          // Mobil görünümde drawer menüsü
          drawer: isDesktop ? null : const NavigationDrawerWidget(),
          // Özel tasarlanmış app bar
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // Mobil görünümde menü butonu
                  leading: isDesktop
                      ? null
                      : Builder(
                          builder: (context) {
                            return IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                  title: Row(
                    children: [
                      // Masaüstü görünümde header ve navigasyon menüsü
                      if (isDesktop)
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: HeaderWidget(),
                        ),
                      if (isDesktop) const Spacer(),
                      if (isDesktop) ...[
                        // Navigasyon butonları
                        _buildNavButton(
                            context,
                            '/',
                            provider.translations['navigation']['home'] ??
                                'Ana Sayfa',
                            Icons.home_outlined),
                        _buildNavButton(
                            context,
                            '/about',
                            provider.translations['navigation']['about'] ??
                                'Hakkımda',
                            Icons.person_outline),
                        _buildNavButton(
                            context,
                            '/education',
                            provider.translations['navigation']['education'] ??
                                'Eğitim',
                            Icons.school_outlined),
                        _buildNavButton(
                            context,
                            '/projects',
                            provider.translations['navigation']['projects'] ??
                                'Projeler',
                            Icons.code_outlined),
                        _buildNavButton(
                            context,
                            '/contact',
                            provider.translations['navigation']['contact'] ??
                                'İletişim',
                            Icons.mail_outline),
                        const SizedBox(width: 16),
                        // Dil seçim menüsü
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.language,
                              color: AppTheme.textColor),
                          onSelected: (String value) {
                            provider.changeLanguage(value);
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            // Türkçe dil seçeneği
                            const PopupMenuItem<String>(
                              value: 'tr',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇹🇷', style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 8),
                                  Text('Türkçe'),
                                ],
                              ),
                            ),
                            // İngilizce dil seçeneği
                            const PopupMenuItem<String>(
                              value: 'en',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇬🇧', style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 8),
                                  Text('English'),
                                ],
                              ),
                            ),
                            // Japonca dil seçeneği
                            const PopupMenuItem<String>(
                              value: 'ja',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇯🇵', style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 8),
                                  Text('日本語'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Mobil görünümde başlık
                      if (!isDesktop)
                        Text(
                          provider.getString('header.name',
                              defaultValue: 'Furkan Erdogan'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Sayfa geçiş animasyonu
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(state.uri.path),
              child: child,
            ),
          ),
        );
      },
      // Sayfa rotaları
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/about',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const AboutContent(),
          ),
        ),
        GoRoute(
          path: '/education',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const EducationContent(),
          ),
        ),
        GoRoute(
          path: '/projects',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ProjectsContent(),
          ),
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ContactContent(),
          ),
        ),
      ],
    ),
  ],
);

// Navigasyon butonu oluşturucu yardımcı widget
Widget _buildNavButton(
    BuildContext context, String path, String label, IconData icon) {
  return TextButton(
    onPressed: () => context.go(path),
    child: Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label),
      ],
    ),
  );
}

// Header widget'ı
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            provider.getString('header.name', defaultValue: 'Furkan Erdogan'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Mobil menü drawer widget'ı
class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer başlığı
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
            ),
            child: Text(
              provider.translations['header']?['name'] ?? 'Furkan Erdoğan',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Drawer menü öğeleri
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
                provider.translations['navigation']['home'] ?? 'Ana Sayfa'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
                provider.translations['navigation']['about'] ?? 'Hakkımda'),
            onTap: () {
              Navigator.pop(context);
              context.go('/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(
                provider.translations['navigation']['education'] ?? 'Eğitim'),
            onTap: () {
              Navigator.pop(context);
              context.go('/education');
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(
                provider.translations['navigation']['projects'] ?? 'Projeler'),
            onTap: () {
              Navigator.pop(context);
              context.go('/projects');
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(
                provider.translations['navigation']['contact'] ?? 'İletişim'),
            onTap: () {
              Navigator.pop(context);
              context.go('/contact');
            },
          ),
          const Divider(),
          // Dil seçim menüsü
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Dil Seçimi / Language'),
            trailing: DropdownButton<String>(
              value: provider.currentLanguage,
              underline: Container(),
              onChanged: (String? value) {
                if (value != null) {
                  provider.changeLanguage(value);
                }
                Navigator.pop(context);
              },
              items: const [
                DropdownMenuItem(
                  value: 'tr',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🇹🇷'),
                      SizedBox(width: 8),
                      Text('Türkçe'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🇬🇧'),
                      SizedBox(width: 8),
                      Text('English'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'ja',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🇯🇵'),
                      SizedBox(width: 8),
                      Text('日本語'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
