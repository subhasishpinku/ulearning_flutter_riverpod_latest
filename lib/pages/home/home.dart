import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/pages/home/controller/home_controller.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => Home());
  }

  @override
  ConsumerState<Home> createState() => _HomePage();
}

class _HomePage extends ConsumerState<Home> {
  PageController pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final userItem = ref.watch(homeUserItemProvider);
    final asyncCourseList = ref.watch(asyncNotifierHomeControllerProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 25.w,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 0.h, top: 20.h),
                  child: Text(
                    "Hello,",
                    style: TextStyle(
                      color: AppColors.primaryThreeElementText,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 21.h, top: 5.h),
                  child: Text(
                    "${userItem.name}",
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 25.w,
          ),
          sliver: SliverToBoxAdapter(child: _searchView()),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 25.w,
          ),
          sliver: SliverToBoxAdapter(child: _bannerView()),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 25.w,
          ),
          sliver: SliverToBoxAdapter(child: _menuView()),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 25.w,
          ),
          sliver: SliverToBoxAdapter(
              child: switch (asyncCourseList) {
            AsyncData(:final value) => value == null
                ? Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.black26, strokeWidth: 2)),
                  )
                : GridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.6),
                    itemCount: value.length,
                    itemBuilder: (_, int index) {
                      return GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "${value.elementAt(index).thumbnail}"),
                                    fit: BoxFit.fill),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.h)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                    "${value.elementAt(index).name}",
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: AppColors.primaryElementText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                    ),
                                  )),
                                  Container(
                                      margin: EdgeInsets.only(top: 6.h),
                                      child: Text(
                                        "${value.elementAt(index).lesson_num} Lesson",
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          color:
                                              AppColors.primaryFourElementText,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 8.sp,
                                        ),
                                      ))
                                ],
                              )),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.CourseDetail,
                                arguments: {"id": value.elementAt(index).id});
                          });
                    }),
            AsyncError(:final error) => Text('Error: $error'),
            _ => const Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.black26, strokeWidth: 2)),
              ),
          }),
        ),
      ]),
    );
  }

  AppBar _buildAppBar() {
    final userItem = ref.watch(homeUserItemProvider);
    return AppBar(
        title: Container(
      margin: EdgeInsets.only(left: 7.w, right: 7.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 18.w,
            height: 12.h,
            child: Image.asset("assets/icons/menu.png"),
          ),
          GestureDetector(
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("${userItem.avatar}"),
                      fit: BoxFit.fitHeight),
                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
            ),
            onTap: () {},
          ),
        ],
      ),
    ));
  }

  Widget _searchView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 280.w,
          height: 40.h,
          margin: EdgeInsets.only(bottom: 0.h, top: 0.h),
          padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
          decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.all(Radius.circular(15.h)),
              border: Border.all(color: AppColors.primaryFourElementText)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 17.w),
                padding: EdgeInsets.only(left: 0.w, top: 0.w),
                width: 16.w,
                height: 16.w,
                child: Image.asset("assets/icons/search.png"),
              ),
              Container(
                width: 240.w,
                height: 40.h,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Search your course...",
                    hintStyle: TextStyle(
                      color: AppColors.primaryThreeElementText,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp,
                  ),
                  onChanged: (value) {
                    // controller.state.email.value = value;
                  },
                  maxLines: 1,
                  autocorrect: false, // 自动纠正
                  obscureText: false, // 隐藏输入内容, 密码框
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            width: 40.h,
            height: 40.h,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.all(Radius.circular(13.w)),
                border: Border.all(color: AppColors.primaryElement)),
            child: Image.asset("assets/icons/options.png"),
          ),
          onTap: () {
            // EasyLoading.show(indicator: CircularProgressIndicator(),maskType: EasyLoadingMaskType.clear,dismissOnTap: false);
            // Global.TopSnakbarKey.currentState?.show("xiaoxioa");
          },
        ),
      ],
    );
  }

  Widget _bannerView() {
    final index = ref.watch(homeBannerDotsProvider);
    return Column(
      children: [
        Container(
          width: 325.w,
          height: 160.h,
          margin: EdgeInsets.only(top: 20.h),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              PageView(
                scrollDirection: Axis.horizontal,
                reverse: false,
                onPageChanged: (index) {
                  ref.read(homeBannerDotsProvider.notifier).setIndex(index);
                },
                controller: pageController,
                pageSnapping: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                    width: 325.w,
                    height: 160.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Art.png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.h)),
                    ),
                  ),
                  Container(
                    width: 325.w,
                    height: 160.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Image(1).png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.h)),
                    ),
                  ),
                  Container(
                    width: 325.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Image(2).png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.h)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 8.h),
          child: DotsIndicator(
              mainAxisAlignment: MainAxisAlignment.center,
              reversed: false,
              dotsCount: 3,
              position: index.toDouble(),
              decorator: DotsDecorator(
                color: AppColors.primaryThreeElementText,
                activeColor: AppColors.primaryElement,
                size: const Size.square(5.0),
                activeSize: const Size(17.0, 5.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              )),
        )
      ],
    );
  }

  Widget _menuView() {
    return Column(
      children: [
        Container(
            width: 325.w,
            margin: EdgeInsets.only(top: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 0.h, top: 0.h),
                  child: Text(
                    "Choice your course",
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 0.h, top: 0.h),
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: AppColors.primaryThreeElementText,
                        fontWeight: FontWeight.normal,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  onTap: () {},
                )
              ],
            )),
        Container(
            margin: EdgeInsets.only(top: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 30.w),
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 5.h, bottom: 5.h),
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(7.w)),
                      border: Border.all(color: AppColors.primaryElement)),
                  child: Text(
                    "All",
                    style: TextStyle(
                      color: AppColors.primaryElementText,
                      fontWeight: FontWeight.normal,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 30.w),
                  child: Text(
                    "Popular",
                    style: TextStyle(
                      color: AppColors.primaryThreeElementText,
                      fontWeight: FontWeight.normal,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Newest",
                    style: TextStyle(
                      color: AppColors.primaryThreeElementText,
                      fontWeight: FontWeight.normal,
                      fontSize: 11.sp,
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
