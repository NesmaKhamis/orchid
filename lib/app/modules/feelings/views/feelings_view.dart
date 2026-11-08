import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/feelings_controller.dart';

class FeelingsView extends GetView<FeelingsController> {
  const FeelingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
