import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_children_controller.dart';

class SelectChildrenView extends GetView<SelectChildrenController> {
  const SelectChildrenView({super.key});

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
          'اختيار الطفل',
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

              // 1. العنوان
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'الأبناء المسجلون',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('👶', style: TextStyle(fontSize: 22)),
                ],
              ),

              const SizedBox(height: 8),

              // 2. النص الفرعي
              const Text(
                'عثرنا على الأطفال التابعين لرقم الهوية المدخل. اختر الطفل الذي تود متابعة رحلته اليوم.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              // 3. قائمة الأطفال
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.childrenList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final child = controller.childrenList[index];
                      return Obx(() {
                        final isSelected = controller.selectedChildId.value == child.id;
                        return GestureDetector(
                          onTap: () => controller.selectChild(child.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryPurple.withOpacity(0.08) : lightInputBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? primaryPurple : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: primaryPurple.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                // أيقونة الاختيار
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected ? primaryPurple : Colors.grey,
                                ),
                                const SizedBox(width: 14),

                                // صورة الطفل / الرمز
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryPurple.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      child.avatarAsset,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.person, color: primaryPurple),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // بيانات الطفل
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        child.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        child.grade,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 4. زر المتابعة
              SizedBox(
                width: Get.width * 0.7,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.proceedToChildDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    elevation: 4,
                    shadowColor: primaryPurple.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'متابعة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 18,
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
  }}