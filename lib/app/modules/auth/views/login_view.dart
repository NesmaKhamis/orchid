import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان الرئيسية للتصميم
    const primaryPurple = Color(0xFF8B53A8);
    const lightInputBg = Color(0xFFFAF9FC);
    const textDark = Color(0xFF2D2D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // 1. صورة أوركيد (أكبر وأوضح)
              Image.asset(
                'assets/images/orchid_single.png',
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.filter_vintage,
                    size: 120,
                    color: primaryPurple,
                  );
                },
              ),

              const SizedBox(height: 16),

              // 2. ترويسة أهلاً بك
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'أهلاً بك من جديد',
                    style: AppTextStyles.sectionTitle.copyWith(color: textDark),
                  ),
                  const SizedBox(width: 8),
                  const Text('🌸', style: AppTextStyles.sectionTitle),
                ],
              ),

              const SizedBox(height: 8),

              // 3. النص الفرعي
              Text(
                'سعداء بعودتك، تابع مسيرة طفلك بكل حب وسهولة.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.black87,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 25),

              // 4. حقل البريد الإلكتروني
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'البريد الالكتروني',
                  style: AppTextStyles.label.copyWith(color: textDark),
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
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body.copyWith(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'nesma@gmail.com',
                    hintStyle: AppTextStyles.bodySmall.copyWith(color: Colors.black38),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: primaryPurple,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 5. حقل كلمة المرور
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'كلمة المرور',
                  style: AppTextStyles.label.copyWith(color: textDark),
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: lightInputBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.body.copyWith(color: Colors.black87),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 6. نسيت كلمة المرور؟
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // منطق استعادة كلمة المرور
                  },
                  child: Text(
                    'نسيت كلمة المرور؟',
                    style: AppTextStyles.caption.copyWith(
                      color: primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 7. زر تسجيل الدخول (تم إظهاره وتفعيله بوضوح)
              Obx(
                () => SizedBox(
                  width: Get.width * 0.65,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      elevation: 4,
                      shadowColor: primaryPurple.withValues(alpha: 0.4),
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
                        : Text(
                            'تسجيل الدخول',
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 8. إنشاء حساب جديد (تم تصحيح الترتيب والنصوص)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟ ',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: controller.goToRegister,
                    child: Text(
                      'إنشاء حساب جديد',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
