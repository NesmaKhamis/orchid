import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان الرئيسية الموحدة تماماً مع شاشة تسجيل الدخول
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

              // 1. صورة الأوركيد (بنفس حجم ووضوح شاشة الدخول)
              Image.asset(
                'assets/images/orchid_single.png',
                height: 170,
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

              // 2. ترويسة انشاء حساب
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'انشاء حساب',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('🌸', style: TextStyle(fontSize: 20)),
                ],
              ),

              const SizedBox(height: 8),

              // 3. النص الفرعي
              const Text(
                'انضم إلى عائلة الأوركيد وابدأ رحلة المتابعة بكل حب.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              // 4. حقل اسم ولي الأمر رباعي مع أيقونة الشخص
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'اسم ولي الأمر رباعي',
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
                  controller: controller.nameController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'نسمة خميس دياب',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: primaryPurple,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. حقل البريد الإلكتروني مع أيقونة الإيميل
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'البريد الالكتروني',
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
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'nesma@gmail.com',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: primaryPurple,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 6. حقل كلمة المرور (الأيقونة على اليسار بنفس الطريقة)
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'كلمة المرور',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
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
                  child: TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

              const SizedBox(height: 20),

              // 7. حقل تأكيد كلمة المرور
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'تأكيد كلمة المرور',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
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
                  child: TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 8. زر إنشاء الحساب
              Obx(
                () => SizedBox(
                  width: Get.width * 0.65,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.register,
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
                        : const Text(
                            'انشاء حساب',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 9. لديك حساب بالفعل؟ تسجيل الدخول
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'لديك حساب بالفعل؟ ',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: controller.goToLogin,
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 12,
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