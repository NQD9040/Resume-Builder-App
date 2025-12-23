import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume_builder_project/core/screens/home_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/activity_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/award_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/certification_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/contact_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/cover_letter_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/education_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/experience_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/objective_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/photo_sign_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/preview_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/project_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/reference_information_screen.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/skill_information_screen.dart';

class ResumeInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ResumeInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<ResumeInformationScreen> createState() =>
      _ResumeInformationScreenState();
}

class _ResumeInformationScreenState extends State<ResumeInformationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _tabScrollController = ScrollController();

  final List<String> tabs = [
    "1. Contact",
    "2. Education",
    "3. Experience",
    "4. Project",
    "5. Skill",
    "6. Award",
    "7. Activity",
    "8. Certification",
    "9. Reference",
    "10. Objective",
    "11. Cover Letter",
    "12. Photo - Sign",
    "13. Preview",
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToCenter(_tabController.index);
      }
    });
  }

  void _scrollToCenter(int index) {
    double offset = 0;

    for (int i = 0; i < index; i++) {
      offset += _estimateTabWidth(tabs[i]);
    }

    final currentWidth = _estimateTabWidth(tabs[index]);
    final screenWidth = MediaQuery.of(context).size.width;

    final targetOffset = offset - (screenWidth / 2) + (currentWidth / 2);

    _tabScrollController.animateTo(
      targetOffset.clamp(
        0,
        _tabScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  double _estimateTabWidth(String text) {
    const basePadding = 32;
    final textWidth = text.length * 8.0;
    return textWidth + basePadding;
  }
  Future<void> _saveResumeToFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/resumes_info.json');

    final content = await file.readAsString();
    final List data = jsonDecode(content);

    final index = data.indexWhere(
          (e) =>
      e["name"] == widget.resume["name"] &&
          e["createdAt"] == widget.resume["createdAt"],
    );

    if (index != -1) {
      data[index] = widget.resume;
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumeName = widget.resume['name'] ?? 'Resume';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          resumeName,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          /// TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ContactInformationScreen(
                  resume: widget.resume,
                  onSave: _saveResumeToFile,
                ),
                EducationInformationScreen(resume: widget.resume),
                ExperienceInformationScreen(resume: widget.resume),
                ProjectInformationScreen(resume: widget.resume),
                SkillInformationScreen(resume: widget.resume),
                AwardInformationScreen(resume: widget.resume),
                ActivityInformationScreen(resume: widget.resume),
                CertificationInformationScreen(resume: widget.resume),
                ReferenceInformationScreen(resume: widget.resume),
                ObjectiveInformationScreen(),
                CoverLetterInformationScreen(),
                PhotoSignInformationScreen(),
                PreviewScreen(),
              ],
            ),
          ),

          /// TAB BAR
          SizedBox(
            height: 48,
            child: ListView.builder(
              controller: _tabScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final isSelected = _tabController.index == index;

                return GestureDetector(
                  onTap: () {
                    _tabController.animateTo(index);
                    _scrollToCenter(index);
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color:
                          isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}