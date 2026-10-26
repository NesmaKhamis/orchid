import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/link_identity_controller.dart';

class LinkIdentityView extends GetView<LinkIdentityController> {
  const LinkIdentityView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8B53A8);
    const lightInputBg = Color(0xFFFAF9FC);
    const textDark = Color(0xFF2D2D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: textDark),
        title: const Text(
          'ربط الهوية',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // 1. صورة الأوركيد المفردة
              Image.asset(
                'assets/images/orchid_single.png',
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.badge_outlined,
                    size: 110,
                    color: primaryPurple,
                  );
                },
              ),

              const SizedBox(height: 20),

              // 2. العنوان
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'التحقق من هوية الأسرة',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('🛡️', style: TextStyle(fontSize: 20)),
                ],
              ),

              const SizedBox(height: 10),

              // 3. الشرح
              const Text(
                'يرجى إدخال البيانات المعتمدة في النظام لنتمكن من عرض ملفات أبنائك المسجلين لدينا.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 35),

              // 4. حقل رقم الهوية
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'رقم هوية ولي الأمر',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: lightInputBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: TextField(
                  controller: controller.identityController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'مثال: 900123456',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: primaryPurple,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // 5. حقل تاريخ الميلاد (تحقق أمني)
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'تاريخ الميلاد (رمز الأمان)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => controller.pickBirthDate(context),
                child: AbsorbPointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: lightInputBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: TextField(
                      controller: controller.birthDateController,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: 'السنة - الشهر - اليوم',
                        hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.calendar_month_outlined,
                          color: primaryPurple,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // 6. زر التحقق والبحث
              Obx(
                () => SizedBox(
                  width: Get.width * 0.7,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.verifyAndSearchChildren,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      elevation: 4,
                      shadowColor: primaryPurple.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'التحقق والعثور على الأبناء',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}