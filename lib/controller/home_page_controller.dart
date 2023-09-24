import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  AnimationController? controller;
  late Animation<double> animation =
      CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn);
}
