import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/controllers/home_controller.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/features/home/sun_mode.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerTimesCardWidget extends StatelessWidget{
final HomeController homeController;

  const PrayerTimesCardWidget({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
               return ListenableBuilder(
                    listenable: homeController,
                    builder: (context, child) {
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          gradient: ConstColors.mainGradientColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          children: [
                            // background mosque
                            Positioned(
                              bottom: -80,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                ConstIcons.mosque,
                                color: Colors.white12,
                                height: 240,
                                width: 240,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                spacing: 16,
                                children: [
                                  //sun set and sun rise
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      spacing: 6,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SunModeWidget(
                                            isSunRise: true,
                                            time: homeController.sunrise,
                                          ),
                                        ),
                                        Expanded(
                                          child: SunModeWidget(
                                            isSunRise: false,
                                            time: homeController.sunset,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // next prayer box
                                  Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ConstColors.goldAccent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 20,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          homeController.remainingTime ==
                                                  "00:00:00"
                                              ? Icons.access_alarm_rounded
                                              : Icons.timer_outlined,
                                          size: 20,
                                          color: ConstColors.primaryTeal,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontFamily: 'el-messiri',
                                                fontSize: 15,
                                                color: ConstColors.primaryTeal,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      homeController
                                                              .remainingTime ==
                                                          "00:00:00"
                                                      ? "حان موعد صلاة "
                                                      : "باقي على  ",
                                                ),
                                                TextSpan(
                                                  text: homeController
                                                      .nextPrayer
                                                      .name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      homeController
                                                              .remainingTime ==
                                                          "00:00:00"
                                                      ? "  الآن"
                                                      : " : ",
                                                ),
                                                if (homeController
                                                        .remainingTime !=
                                                    "00:00:00")
                                                  TextSpan(
                                                    text: homeController
                                                        .remainingTime
                                                        .toArabicFormat(),
                                                    style: const TextStyle(
                                                      fontFamily: 'cairo',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // other prayers
                                  homeController.finalPrayerTimes.isEmpty
                                      ? SizedBox(
                                          height: 4,
                                          child: LinearProgressIndicator(
                                            color: ConstColors.deepYellow,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            trackGap: 1,
                                          ),
                                        )
                                      : GridView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 4,
                                                mainAxisSpacing: 4,
                                                childAspectRatio: 4,
                                              ),
                                          itemCount: homeController
                                              .finalPrayerTimes
                                              .length,
                                          itemBuilder: (context, i) => Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: ConstColors.primaryTeal
                                                  .withValues(alpha: .7),
                                              border: Border.all(
                                                color: ConstColors.goldAccent,
                                                width: .7,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              "${homeController.finalPrayerTimes[i].name} : ${DateFormat.jm('ar').format(homeController.finalPrayerTimes[i].time)}"
                                                  .toArabicFormat(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 15,
                                                    color:
                                                        ConstColors.goldAccent,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                  if (homeController.isLocationError)
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () async {
                                          /// TODO: function to refresh location
                                          await Geolocator.openLocationSettings();
                                        },
                                        icon: const Icon(
                                          Icons.update_rounded,
                                          color: ConstColors.primaryTeal,
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: ConstColors
                                              .goldAccent
                                              .withValues(alpha: .8),
                                          side: const BorderSide(
                                            color: ConstColors.goldAccent,
                                            width: 1,
                                          ),
                                        ),
                                        label: const Text(
                                          "يرجى تفعيل الموقع لتحديث أوقات الصلاة",
                                          style: TextStyle(
                                            color: ConstColors.primaryTeal,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
         
           }
}