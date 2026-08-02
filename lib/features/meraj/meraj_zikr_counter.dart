import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/widgets/counter_button.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:diaa_almuslim/features/meraj/meraj_user_completed_azkar.dart';

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
  int counter = 0;
 
  final MerajUserCompletedAzkar _userCompletedAzkar = MerajUserCompletedAzkar();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar:const MyAppbar(showSettingsButton: true, pageName: "",),

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
                                  color: context.isDarkMode
                                      ? ConstColors.goldAccent
                                      : ConstColors.primaryTeal,
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
            const SizedBox(height: 40),
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
                      color: context.isDarkMode
                          ? ConstColors.goldAccent
                          : ConstColors.primaryTeal,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.repeat.toString()} مرة".toArabicFormat(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: context.isDarkMode
                          ? ConstColors.goldAccent
                          : ConstColors.primaryTeal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
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
                          backgroundColor: ConstColors.primaryTeal,
                          title: Text(
                            "تم بحمد الله",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ConstColors.goldAccent,
                                ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "ثبتك الله على طاعته وزادك",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: ConstColors.goldAccent),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  await _userCompletedAzkar.addNewZikr(
                                    widget.id,
                                  );
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pop(context);

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: ConstColors.goldAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    ConstIcons.check,
                                    color: ConstColors.primaryTeal,
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
