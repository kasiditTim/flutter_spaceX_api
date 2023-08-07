import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'launches_bloc.dart';
import 'model.dart';
import 'dart:math' as math;

class Details extends StatelessWidget {
  final String idMission;

  const Details({super.key, required this.idMission});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black,
          title: const Text('Details'),
        ),
        body: SafeArea(
            child: Container(
                height: 100.h,
                width: 100.w,
                color: Colors.black87,
                child: ListView(
                  children: [
                    BlocBuilder<LaunchesBloc, List<LaunchDataModel>>(
                        builder: (context, launches) {
                      final launchData = launches.firstWhere(
                          (element) => element.idMission == idMission);

                      final fmLunchDate = DateFormat('d MMM y, h:mm a').format(
                        DateTime.parse(launchData.launchDate),
                      );

                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //img
                            Center(
                              child: CustomCarouselSlider(
                                items: launchData.img.isNotEmpty
                                    ? launchData.img
                                        .take(10)
                                        .map((imgUrl) => CarouselItem(
                                            image: NetworkImage(imgUrl)))
                                        .toList()
                                    : [
                                        CarouselItem(
                                            image: launchData.logo != 'null'
                                                ? NetworkImage(launchData.logo)
                                                : Image.asset(
                                                        'assets/noImg.jpg')
                                                    .image)
                                      ],
                                height: 30.h,
                                subHeight: 50,
                                width: 100.w,
                                autoplay: false,
                                showText: false,
                                showSubBackground: false,
                                indicatorShape: BoxShape.circle,
                                indicatorPosition:
                                    IndicatorPosition.insidePicture,
                                selectedDotColor: Colors.black,
                                unselectedDotColor: Colors.white,
                              ),
                            ),

                            SizedBox(
                              height: 1.h,
                            ),

                            //name
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                                shadowColor:
                                    const Color.fromARGB(221, 7, 16, 21),
                                elevation: 5,
                                child: Container(
                                  color: const Color.fromARGB(221, 7, 16, 21),
                                  height: 6.h,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      launchData.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //date
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                shadowColor: Colors.black,
                                elevation: 5,
                                child: Container(
                                  color: const Color.fromARGB(221, 7, 16, 21),
                                  height: 5.h,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      fmLunchDate,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //list
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                              child: SizedBox(
                                height: 23.5.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: [
                                    _buildCard(
                                      Icons.rocket,
                                      launchData.success == 'true'
                                          ? const Color.fromARGB(
                                              255, 136, 249, 7)
                                          : launchData.success == 'false'
                                              ? Colors.red
                                              : Colors.grey.shade800,
                                      'Successful Launch',
                                      launchData.success == 'true'
                                          ? 'Yes'
                                          : launchData.success == 'false'
                                              ? 'No'
                                              : 'Not Launch',
                                    ),
                                    SizedBox(width: 1.w),
                                    if (launchData.landingAttempt.toString() ==
                                        'true')
                                      _buildCard(
                                        Icons.rocket,
                                        launchData.landingSuccess.toString() !=
                                                'null'
                                            ? launchData.landingSuccess
                                                        .toString() ==
                                                    'true'
                                                ? const Color.fromARGB(
                                                    255, 126, 216, 23)
                                                : Colors.red.shade700
                                            : Colors.grey.shade700,
                                        'Successful Landing',
                                        launchData.landingSuccess.toString() !=
                                                'null'
                                            ? launchData.landingSuccess
                                                        .toString() ==
                                                    'true'
                                                ? 'Yes'
                                                : 'No'
                                            : 'No Attempt',
                                        angle: 180,
                                      ),
                                    SizedBox(width: 1.w),
                                    _buildCard(
                                      Icons.people,
                                      Colors.lightBlue,
                                      'Crew',
                                      launchData.crew.length.toString(),
                                      subText: 'Members',
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //details
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                              child: Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  shadowColor:
                                      const Color.fromARGB(221, 7, 16, 21),
                                  elevation: 5,
                                  child: Container(
                                    width: 100.w,
                                    color: const Color.fromARGB(221, 7, 16, 21),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Mission Details \n   ${launchData.details}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ))));
  }
}

Widget buildCard(IconData icon, String topic, String details) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    clipBehavior: Clip.antiAlias,
    shadowColor: Colors.black54,
    elevation: 5,
    child: Container(
      height: 10.h,
      width: 20.w,
      color: Colors.black54,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            topic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            details,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCard(IconData icon, Color iconColor, String title, String content,
    {double angle = 0, String subText = ''}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    clipBehavior: Clip.antiAlias,
    shadowColor: const Color.fromARGB(221, 7, 16, 21),
    elevation: 5,
    child: Container(
      width: 38.w,
      color: const Color.fromARGB(221, 7, 16, 21),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Transform.rotate(
              angle: angle * math.pi / 180,
              child: Icon(
                icon,
                color: Colors.white,
                size: 25.sp,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: iconColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
