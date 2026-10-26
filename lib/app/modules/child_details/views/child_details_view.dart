import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/child_details_controller.dart';

class ChildDetailsView extends GetView<ChildDetailsController> {
  const ChildDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8B53A8);
    const lightBg = Color(0xFFFAF9FC);
    const textDark = Color(0xFF2D2D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: textDark),
        title: const Text(
          'بيانات الطفل',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryPurple, width: 2),
                ),
                child: const Icon(
                  Icons.person,
                  size: 45,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                controller.selectedChild.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.selectedChild.grade,
                style: const TextStyle(
                  fontSize: 14,
                  color: primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView(
                  children: [
                    _buildInfoCard(
                      icon: Icons.badge_outlined,
                      title: 'رقم هوية الطفل',
                      value: controller.childNationalId,
                      lightBg: lightBg,
                      primaryColor: primaryPurple,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'تاريخ الميلاد',
                      value: controller.birthDate,
                      lightBg: lightBg,
                      primaryColor: primaryPurple,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.cake_outlined,
                      title: 'العمر الحالي',
                      value: controller.calculatedAge,
                      lightBg: lightBg,
                      primaryColor: primaryPurple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.proceedToDashboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'متابعة إلى لوحة التحكم',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color lightBg,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }}