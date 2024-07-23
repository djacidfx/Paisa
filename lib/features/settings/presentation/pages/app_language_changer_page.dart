import 'package:flutter/material.dart';
import 'package:paisa/core/widgets/paisa_scaffold.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'package:paisa/config/routes.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/widgets/paisa_widget.dart';

class AppLanguageChangerPage extends StatefulWidget {
  const AppLanguageChangerPage({
    super.key,
    this.currentLanguage,
  });

  final String? currentLanguage;

  @override
  State<AppLanguageChangerPage> createState() => _AppLanguageChangerPageState();
}

class _AppLanguageChangerPageState extends State<AppLanguageChangerPage> {
  final List<LanguageEntity> languages = Languages.languages.sorted(
    (a, b) => a.englishName.compareTo(b.englishName),
  );

  late String? selectedLanguage = widget.currentLanguage;

  Future<void> _save(BuildContext context) async {
    await settings.put(appLanguageKey, selectedLanguage);
    if (context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PaisaAnnotatedRegionWidget(
      color: context.surface,
      child: PaisaScaffold(
        appBar: context.materialYouAppBar(context.loc.chooseAppLanguage),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: languages.length,
          itemBuilder: (_, index) {
            final LanguageEntity entity = languages[index];
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              selectedTileColor: context.primaryContainer,
              selectedColor: context.onPrimaryContainer,
              selected: selectedLanguage == entity.code,
              onTap: () {
                setState(() {
                  selectedLanguage = entity.code;
                });
              },
              title: Text(
                entity.value,
                style: context.titleMedium?.copyWith(
                    color: selectedLanguage == entity.code
                        ? context.primary
                        : null),
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PaisaButton.mediumText(
                  text: context.loc.cancel,
                  onPressed: () => context.pop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 16),
                child: PaisaButton.mediumElevated(
                  text: context.loc.done,
                  onPressed: () => _save(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageEntity {
  const LanguageEntity({
    required this.code,
    required this.value,
    required this.englishName,
  });

  final String code;
  final String value;
  final String englishName;
}

class Languages {
  const Languages._();

  static const languages = [
    LanguageEntity(code: 'en', value: 'English', englishName: 'English'),
    LanguageEntity(code: 'ar', value: 'العربية', englishName: 'Arabic'),
    LanguageEntity(code: 'es', value: 'Española', englishName: 'Spanish'),
    LanguageEntity(code: 'pl', value: 'Polski', englishName: 'Polish'),
    LanguageEntity(code: 'ne', value: 'नेपाली', englishName: 'Nepali'),
    LanguageEntity(code: 'cs', value: 'čeština', englishName: 'Czech'),
    LanguageEntity(code: 'uk', value: 'українська', englishName: 'Ukrainian'),
    LanguageEntity(code: 'be', value: 'беларуская', englishName: 'Belarusian'),
    LanguageEntity(code: 'de', value: 'Deutsch', englishName: 'German'),
    LanguageEntity(code: 'fr', value: 'Français', englishName: 'French'),
    LanguageEntity(code: 'it', value: 'Italiana', englishName: 'Italian'),
    LanguageEntity(code: 'kn', value: 'ಕನ್ನಡ (IN)', englishName: 'Kannada'),
    LanguageEntity(code: 'pt', value: 'Português', englishName: 'Portuguese'),
    LanguageEntity(code: 'ru', value: 'русский', englishName: 'Russian'),
    LanguageEntity(code: 'ta', value: 'தமிழ் (IN)', englishName: 'Tamil'),
    LanguageEntity(code: 'ml', value: 'മലയാളം (IN)', englishName: 'Malayalam'),
    LanguageEntity(code: 'vi', value: 'Tiếng Việt', englishName: 'Vietnamese'),
    LanguageEntity(code: 'zh', value: '中国人', englishName: 'Chinese'),
    LanguageEntity(
        code: 'zh_TW', value: '繁体中文', englishName: 'Traditional Chinese'),
    LanguageEntity(code: 'gu', value: 'ગુજરાતી (IN)', englishName: 'Gujarati'),
    LanguageEntity(code: 'tr', value: 'Türkçe', englishName: 'Turkish'),
    LanguageEntity(code: 'ur', value: 'اردو', englishName: 'Urdu'),
  ];
}
