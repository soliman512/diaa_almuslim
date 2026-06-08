import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/services/app_actions_service.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/header.dart';
import 'package:zad_almuslim/core/widgets/progress.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zad_almuslim/features/allah_names/allah_name_info.dart';
import 'package:zad_almuslim/features/allah_names/allah_names_logic.dart';

class AllahNames extends StatefulWidget {
  const AllahNames({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;
  @override
  State<AllahNames> createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Uri websiteUrl = Uri.parse("https://surahquran.com");
  final AllahNamesLogic names = AllahNamesLogic();
  bool isLoading = true;
  final AllahNamesLogic _logic = AllahNamesLogic();

  Future<void> openUrl() async {
    if (!await launchUrl(websiteUrl, mode: LaunchMode.externalApplication)) {
      if (!mounted) {
        return;
      }
      AppActionsService.showErrorSnackBar(
        context,
        "حدثت مشكلة غير متوقعة ، حاول لاحقا",
      );
    }
  }

  void _initData() async {
    try {
      await _logic.fetchData();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      throw Exception("Error while initializing data: $e");
    }
  }

  @override
  void initState() {
    // _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        pageName: ConstTexts.allahNames,
        onPressDrawer: () => scaffoldState.currentState!.openDrawer(),
      ),
      drawer: AppDrawer(),
      body: SpecialBody(
        showTopIcon: false,
        body: Column(
                children: [
                  SizedBox(height: 60),
                  // header
                  Header(
                    content:
                        "يقول ﷺ: إن لله تسعة وتسعين اسمًا،\n من أحصاها دخل الجنة",
                  ),
                  // source
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'المصدر:\t',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("فتح الموقع ؟"),
                            content: Text(
                              "سيؤدي فتح الموقع الى الخروج من التطبيق",
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(color: Colors.black54),
                            ),
                            alignment: Alignment.center,
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                onPressed: openUrl,
                                child: Text(
                                  "فتح",
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: const Color.fromARGB(
                                          255,
                                          15,
                                          117,
                                          19,
                                        ),
                                      ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "إلغاء",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Text(
                          "http://surahquran.com",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(color: Color.fromARGB(255, 199, 7, 7)),
                        ),
                      ),
                    ],
                  ),
                  // names
                  Expanded(
                    child: FutureBuilder(
                      future: _logic.loadSavedNames(),
                      builder: (context, snapshot) {
                        //waiting
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Porgress();
                        }
                        //no data
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          _initData();
                          return const Center(
                            child: Text(
                              "جاري جلب الأسماء من الإنترنت...\nتأكد من اتصالك بالشبكة إذا طال الانتظار.\nهذا فقط في اول مرة",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }
                        final nameList = snapshot.data!;

                        return GridView.builder(
                          itemCount: nameList.length,
                          padding: EdgeInsets.only(top: 20),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final name = nameList[index]['name'];
                            final meaning = nameList[index]['meaning'];
                            final parts = name.split(' ');

                            final formattedName = parts.length > 2
                                ? "${parts[0]} ${parts[1]}\n${parts.sublist(2).join(' ')}"
                                : name;

                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return AllahNameInfoBottomSheet(
                                      name_param: name,
                                      meaning_param: meaning,
                                      fontSizeFactor: widget.fontSizeFactor,
                                    );
                                  },
                                );
                              },

                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(ConstIcons.allahNameBox),
                                  Text(
                                    formattedName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: ConstColors.mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: name.split(' ').length > 2
                                              ? 12
                                              : null,
                                        ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
