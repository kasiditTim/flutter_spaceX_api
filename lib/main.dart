import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:space_x/details.dart';

import 'launches_bloc.dart';
import 'model.dart';

// Your other classes and code here...

void setupLocator() {
  GetIt.I.registerLazySingleton(() => LaunchesBloc());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<LaunchesBloc>(),
      child: ResponsiveSizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          home: HomePageContent(),
        );
      }),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final launchesBloc = context.watch<LaunchesBloc>();

    launchesBloc.fetchData();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text('SPACE X'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black87,
          height: 100.h,
          width: 100.w,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 8.h,
                        width: 80.w,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          onChanged: (query) {
                            launchesBloc.startSearch(query);
                          },
                          decoration: const InputDecoration(
                            focusColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 3,
                                )),
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(221, 7, 16, 21),
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.sort_by_alpha,
                                        color: Colors.white,
                                      ),
                                      title: Text('Sort by Name A-Z',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        launchesBloc.sortByNameAZ();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(
                                        color: Colors.white,
                                        endIndent: 1,
                                        indent: 1),
                                    ListTile(
                                      leading: const Icon(Icons.sort_by_alpha,
                                          color: Colors.white),
                                      title: Text('Sort by Name Z-A',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        launchesBloc.sortByNameZA();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(
                                        color: Colors.white,
                                        endIndent: 1,
                                        indent: 1),
                                    ListTile(
                                      leading: const Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      title: Text('Sort by Date Oldest-Newest',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        launchesBloc.sortByDateOldestNewest();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(
                                        color: Colors.white,
                                        endIndent: 1,
                                        indent: 1),
                                    ListTile(
                                      leading: const Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      title: Text('Sort by Date Newest-Oldest',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        launchesBloc.sortByDateNewestOldest();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        )),
                    const Spacer(),
                  ],
                ),

                //
                SizedBox(
                  height: 1.h,
                ),

                BlocBuilder<LaunchesBloc, List<LaunchDataModel>>(
                    builder: (context, launches) {
                  final filteredLaunches = launchesBloc.filteredLaunches;

                  if (filteredLaunches.isEmpty) {
                    return const CircularProgressIndicator();
                  } else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: filteredLaunches
                                .length, //filteredLaunches.length,
                            itemBuilder: (context, index) {
                              final launchData = filteredLaunches[index];

                              final fmLunchDate = DateFormat('d MMM y').format(
                                DateTime.parse(launchData.launchDate),
                              );

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  shadowColor:
                                      const Color.fromARGB(221, 7, 16, 21),
                                  elevation: 5,
                                  child: Container(
                                    color: const Color.fromARGB(221, 7, 16, 21),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: 30.w,
                                              height: 18.h,
                                              child: launchData.img.isNotEmpty
                                                  ? Image.network(
                                                      launchData.img[0],
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: launchData.logo !=
                                                              'null'
                                                          ? Image.network(
                                                              launchData.logo,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : Image.asset(
                                                              'assets/noImg.jpg',
                                                              fit: BoxFit.fill),
                                                    ),
                                            ),
                                          ],
                                        ),

                                        //
                                        SizedBox(
                                          width: 3.w,
                                        ),

                                        //
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 34.w,
                                                    height: 10.h,
                                                    //  color: Colors.red,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          launchData.name
                                                                      .length >
                                                                  7
                                                              ? '${launchData.name.substring(0, 7)}...'
                                                              : launchData.name,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),

                                                        //
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),
                                                        //

                                                        Text(
                                                          fmLunchDate,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),

                                                        //
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),

                                                        //
                                                      ],
                                                    ),
                                                  ),

                                                  //
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),

                                                  //
                                                  SizedBox(
                                                    width: 25.w,
                                                    child: Column(
                                                      children: [
                                                        buildStatusWidget(
                                                            launchData),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: 1.h,
                                              ),

                                              //
                                              SizedBox(
                                                width: 55.w,
                                                height: 6.h,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Details(
                                                                      idMission:
                                                                          launchData
                                                                              .idMission,
                                                                    )),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.black54),
                                                    child: Text('View Details',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.sp,
                                                        ))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }));
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildStatusWidget(LaunchDataModel launchData) {
  Color statusColor;
  String statusLabel;

  if (launchData.success == 'true') {
    statusColor = const Color.fromARGB(255, 113, 206, 7);
    statusLabel = 'Success';
  } else if (launchData.success == 'false') {
    statusColor = Colors.red;
    statusLabel = 'Failed';
  } else {
    statusColor = Colors.grey;
    statusLabel = 'Not Launch';
  }

  return Column(
    children: [
      Icon(
        Icons.rocket,
        color: statusColor,
        size: 27.sp,
      ),
      const SizedBox(width: 1),
      Text(
        statusLabel,
        style: TextStyle(
          color: statusColor,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
