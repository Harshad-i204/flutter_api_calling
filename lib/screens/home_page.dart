import 'package:flutter/material.dart';
import 'package:flutter_api_calling/constant/color_utils.dart';
import 'package:flutter_api_calling/constant/string_utils.dart';
import 'package:flutter_api_calling/controller/home_page_controller.dart';
import 'package:flutter_api_calling/model/article_model.dart';
import 'package:flutter_api_calling/service/api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  HomePageController homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    ApiService().fetchArticles();
    homePageController.controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text(AppStrings.article),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: size.height.h,
        width: size.width.w,
        padding: const EdgeInsets.all(15),
        child: GetBuilder<HomePageController>(builder: (controller) {
          homePageController = controller;
          return FutureBuilder<ArticleModel?>(
              future: ApiService().fetchArticles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('No Data Found'),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.articles?.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final article = snapshot.data?.articles?[index];
                        return RotationTransition(
                          turns: controller.animation,
                          child: Container(
                            height: 200.h,
                            width: double.infinity.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              image: DecorationImage(
                                  image: NetworkImage(article?.urlToImage ?? AppStrings.noImage),
                                  scale: 2.0,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.high),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 200.h,
                                  width: double.infinity.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      gradient:  LinearGradient(
                                          colors: [
                                            article?.urlToImage == AppStrings.noImage ? Colors.red : Colors.transparent ,
                                            Colors.black
                                          ],
                                          begin: Alignment.center,
                                          end: Alignment.bottomCenter)),
                                ),
                                SizedBox(height: 15.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      article?.title ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Wrap(
                                      children: [
                                        Text(
                                          article?.author ?? '',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.sp),
                                        ),
                                        SizedBox(width: 20.w),
                                        Text(
                                          article?.publishedAt?.split('T').first ?? '',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.sp),
                                        ),
                                      ],
                                    )
                                  ],
                                ).paddingSymmetric(
                                    horizontal: 20.w, vertical: 15.h)
                              ],
                            ),
                          ).paddingOnly(bottom: 15.h),
                        );
                      });
                }
                return const SizedBox();
              });
        }),
      ),
    );
  }
}
