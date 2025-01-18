// İletişim Ekranı (Contact Screen)
// Bu dosya, kullanıcıların iletişim formunu ve iletişim bilgilerini içeren ekranı içerir
// Ekran iki ana bölümden oluşur:
// 1. İletişim formu - EmailJS ile entegre edilmiş mesaj gönderme formu
// 2. İletişim bilgileri - Email, telefon ve sosyal medya bağlantıları

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:emailjs/emailjs.dart';

// İletişim içeriği widget'ı
// StatefulWidget kullanılarak form durumu yönetilir
class ContactContent extends StatefulWidget {
  const ContactContent({super.key});

  @override
  State<ContactContent> createState() => _ContactContentState();
}

class _ContactContentState extends State<ContactContent> {
  // Form kontrolcüleri - kullanıcı girişlerini yönetmek için
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false; // Email gönderim durumu kontrolü

  @override
  void dispose() {
    // Widget dispose edildiğinde kontrolcüleri temizle
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Email gönderme işlemini gerçekleştiren metod
  Future<void> _sendEmail() async {
    // Form validasyonu - boş alan kontrolü
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doldurun.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Gönderim durumunu güncelle
    setState(() {
      _isSending = true;
    });

    try {
      // EmailJS servisi ile email gönder
      await EmailJS.send(
        'service_iimrq8p',
        'template_rj7rckh',
        {
          'name': _nameController.text,
          'email': _emailController.text,
          'message': _messageController.text,
        },
        const Options(
          publicKey: 'VcVSE037FOGYgKFYA',
        ),
      );

      if (mounted) {
        // Başarılı gönderim mesajı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<LanguageProvider>().getString(
                    'contact.success',
                    defaultValue: 'Message sent successfully!',
                  ),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Form'u temizle
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    } catch (e) {
      print('EmailJS Error: $e'); // Hata detayını logla
      if (mounted) {
        // Hata mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<LanguageProvider>().getString(
                    'contact.error',
                    defaultValue: 'An error occurred. Please try again.',
                  ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Gönderim durumunu sıfırla
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dil çevirilerini al
    final translations = context.watch<LanguageProvider>().translations;

    // Ana ekran yapısı
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık ve alt başlık
          Text(
            translations['contact']['title'] ?? 'Contact',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          Text(
            translations['contact']['subtitle'] ?? 'Get in touch with me',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
          const SizedBox(height: 40),
          // Responsive layout yönetimi
          LayoutBuilder(
            builder: (context, constraints) {
              // Geniş ekranlarda yan yana, dar ekranlarda alt alta yerleşim
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildContactInfo(context)),
                    const SizedBox(width: 40),
                    Expanded(child: _buildContactForm(context)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildContactInfo(context),
                    const SizedBox(height: 40),
                    _buildContactForm(context),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // İletişim bilgileri bölümünü oluşturan widget
  Widget _buildContactInfo(BuildContext context) {
    final translations = context.watch<LanguageProvider>().translations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // İletişim bilgileri başlığı
        Text(
          translations['contact']['contact_info'] ?? 'Contact Information',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(height: 20),
        // İletişim bilgileri öğeleri
        _buildContactItem(
          context: context,
          icon: Icons.email,
          title: translations['contact']['email'] ?? 'Email',
          content: 'furkaan.er.34@gmail.com',
        ),
        const SizedBox(height: 20),
        _buildContactItem(
          context: context,
          icon: Icons.phone,
          title: translations['contact']['phone'] ?? 'Phone',
          content: '+90 (536) 431 10 97',
        ),
        const SizedBox(height: 20),
        _buildContactItem(
          context: context,
          icon: Icons.location_on,
          title: translations['contact']['address'] ?? 'Address',
          content: translations['contact']['location'] ?? 'Istanbul, Turkey',
        ),
        const SizedBox(height: 40),
        // Sosyal medya bölümü
        Text(
          translations['contact']['social_media'] ?? 'Social Media',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(height: 20),
        // Sosyal medya butonları
        Row(
          children: [
            _buildSocialButton(
              'https://github.com/Atarapa0',
              'GitHub',
              Icons.code,
            ),
            const SizedBox(width: 10),
            _buildSocialButton(
              'https://www.linkedin.com/in/furkan-erdogan/',
              'LinkedIn',
              Icons.business,
            ),
            const SizedBox(width: 10),
            _buildSocialButton(
              'https://furkanerdogan.great-site.net',
              'Web Site',
              Icons.language,
            ),
          ],
        ),
      ],
    );
  }

  // İletişim formu bölümünü oluşturan widget
  Widget _buildContactForm(BuildContext context) {
    final translations = context.watch<LanguageProvider>().translations;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.accentColor.withAlpha(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İsim alanı
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: translations['contact']['name'] ?? 'Name',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          // Email alanı
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: translations['contact']['email'] ?? 'Email',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          // Mesaj alanı
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: translations['contact']['message'] ?? 'Message',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          // Gönder butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSending ? null : _sendEmail,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppTheme.accentColor,
              ),
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(translations['contact']['send'] ?? 'Send'),
            ),
          ),
        ],
      ),
    );
  }

  // İletişim bilgisi öğesi oluşturan yardımcı widget
  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      children: [
        // İkon container'ı
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(width: 15),
        // Başlık ve içerik
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            // Tıklanabilir içerik (email ve telefon için)
            InkWell(
              onTap: () async {
                String? url;
                if (title.contains('Email')) {
                  url = 'mailto:$content';
                } else if (title.contains('Phone')) {
                  url = 'tel:$content';
                }

                if (url != null && await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
              child: Text(
                content,
                style: TextStyle(
                  color: title.contains('Email') || title.contains('Phone')
                      ? AppTheme.accentColor
                      : Colors.white,
                  fontSize: 16,
                  decoration: title.contains('Email') || title.contains('Phone')
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Sosyal medya butonu oluşturan yardımcı widget
  Widget _buildSocialButton(String url, String platform, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.accentColor,
          ),
        ),
      ),
    );
  }
}

// Ana Contact ekranı widget'ı
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContactContent();
  }
}
