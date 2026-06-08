import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/widgets/counter_button.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/features/meraj/meraj_user_completed_azkar.dart';

// ignore: must_be_immutable
class MerajZikrCounter extends StatefulWidget {
  int id;
  String zikr;
  String title;
  int repeat;
  final double fontSizeFactor;
  MerajZikrCounter({
    super.key,
    required this.id,
    required this.zikr,
    required this.repeat,
    required this.title,
    this.fontSizeFactor = 1.0,
  });

  @override
  State<MerajZikrCounter> createState() => _MerajZikrCounterState();
}

class _MerajZikrCounterState extends State<MerajZikrCounter> {
  final GlobalKey<ScaffoldState> _scaffoldKeyState = GlobalKey<ScaffoldState>();

  int counter = 0;

  final MerajUserCompletedAzkar _userCompletedAzkar = MerajUserCompletedAzkar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyState,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        onPressDrawer: () {
          _scaffoldKeyState.currentState!.openDrawer();
        },
        pageName: "",
      ),
      drawer: AppDrawer(),
      body: SpecialBody(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // zikr
            Expanded(
              child: SizedBox(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(widget.fontSizeFactor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * .15,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: MediaQuery.sizeOf(context).height * .05,
                        children: [
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            widget.zikr,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontSize: 18, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            // times of repeat
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() {
                      counter = 0;
                    }),
                    label: Icon(
                      Icons.replay_outlined,
                      color: ConstColors.mainColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.repeat.toString()} مرة",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: ConstColors.mainColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            // controls
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: CounterButton(
                  onPressed: () {
                    if (counter < widget.repeat - 1) {
                      setState(() {
                        counter++;
                      });
                    } else {
                      if (counter < widget.repeat) {
                        setState(() {
                          counter++;
                        });
                      }
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            "تم بحمد الله",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "ثبتك الله على طاعته وزادك",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  await _userCompletedAzkar.addNewZikr(
                                    widget.id,
                                  );

                                  Navigator.pop(context);

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: ConstColors.mainGradientColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    ConstIcons.check,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  label: counter.toString(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
