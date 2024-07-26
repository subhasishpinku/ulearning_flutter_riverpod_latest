import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/pages/profile/account/account_logic.dart';
import 'package:ulearning/pages/profile/account/notifiers/account_notifier.dart';

class Account extends ConsumerStatefulWidget {
  const Account({super.key});


  @override
  ConsumerState<Account> createState() => _AccountPage();
}

class _AccountPage extends ConsumerState<Account> {
  late AccountLogic accountLogic;
  @override
  void initState() {
    super.initState();
    accountLogic = AccountLogic(ref: ref);
    Future.delayed(Duration.zero,(){
      accountLogic.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountProvider);
      return Container(
          color: Colors.white,
          child: SafeArea(
          child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: 10.h,
              left: 25.w,
              right: 25.w,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                child: Text(
                  "History",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 18.h,
              horizontal: 25.w,
            ),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (content, index) {

                    return _buildListItem(content,state.courseItem.elementAt(index));
                  },
                  childCount: state.courseItem.length,
                )),
          ),
        ]),
      )));


  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Container(
        child: Text(
          "My Account",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }


  Widget _buildListItem(BuildContext context,CourseItem item) {
    return Container(
      width: 325.w,
      height: 80.h,
      margin: EdgeInsets.only(
        bottom: 20.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${item.thumbnail}"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.h)),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 180.w,
                          margin: EdgeInsets.only(left: 10.w),
                          child: Text(
                            "${item.name}",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 180.w,
                          margin: EdgeInsets.only(left: 10.w),
                          child: Text(
                            "${item.lesson_num} lesson",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.primaryThreeElementText,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
              // 右侧
              Container(
                width: 55.w,
                alignment: Alignment.centerRight,
                child: Text(
                  "-\$${item.price}",
                  maxLines: 2,
                  style: TextStyle(
                    color: AppColors.primaryElementBg,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          )),
    );
  }
}