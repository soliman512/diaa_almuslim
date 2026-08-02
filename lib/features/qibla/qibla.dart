import 'dart:math' as math;

import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/widgets/progress.dart';

class Qibla extends StatefulWidget {
  const Qibla({super.key});

  @override
  State<Qibla> createState() => _QiblaState();
}

enum ManualDirections { top, right, bottom, left }

enum RotateDirection { normal, toRight, toLeft }

class _QiblaState extends State<Qibla> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  double? _qiblaBearing;
  bool _isLoading = true;
  String _errorMessage = '';

  final double kaabaLat = 21.422571025736325;
  final double kaabaLng = 39.82619017980769;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _fetchLocationAndCalculateQibla();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Future<void> _fetchLocationAndCalculateQibla() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable GPS.';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied.';
          _isLoading = false;
        });
        return;
      }

      // Fetch the location
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      double bearing = _calculateQiblaBearing(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _qiblaBearing = bearing;
        _isLoading = false;
      });
    } catch (e) {}
  }

  double _calculateQiblaBearing(double currentLat, double currentLng) {
    final lat1 = currentLat * math.pi / 180.0;
    final lng1 = currentLng * math.pi / 180.0;
    final lat2 = kaabaLat * math.pi / 180.0;
    final lng2 = kaabaLng * math.pi / 180.0;

    final dLng = lng2 - lng1;

    final y = math.sin(dLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    double bearing = math.atan2(y, x);
    bearing = bearing * 180.0 / math.pi; // Convert back to degrees
    return (bearing + 360) % 360; // Normalize to 0-360 degrees
  }

  // manual way
  String _getDirectionText(double bearing) {
    if (bearing >= 0 && bearing < 90) {
      return 'الشمال الشرقي \nاجعل شروق الشمس على يمينك';
    } else if (bearing >= 90 && bearing < 180) {
      return 'الجنوب الشرقي \nاجعل شروق الشمس على يسارك، ثم التفت قليلاً نحوها';
    } else if (bearing >= 180 && bearing < 270) {
      return 'الجنوب الغربي \nاجعل غروب الشمس على يمينك، ثم التفت قليلاً نحوها';
    } else {
      return 'الشمال الغربي \nاجعل غروب الشمس على يسارك';
    }
  }

  Widget _buildManualMode(double qiblaBearing) {
    double qiblaRadians = qiblaBearing * (math.pi / 180.0);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _getDirectionText(
                qiblaBearing,
              ).split(' ').toList().sublist(0, 2).join(' '),
              style: TextStyle(
                color: context.isDarkMode
                    ? ConstColors.goldAccent
                    : ConstColors.primaryTeal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              _getDirectionText(qiblaBearing).split(' ').sublist(2).join(' '),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width,
              child: Stack(
                // alignment: Alignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 400,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.grey[100],
                      // border: Border.all(
                      //   color: ConstColors.primaryTeal,
                      //   width: 2,
                      // ),
                    ),
                    child: Transform.rotate(
                      angle: qiblaRadians,
                      child: Image.asset(ConstIcons.manualKaabaDirection),
                    ),
                  ),

                  _createDirection(
                    title: 'شمال (N)',
                    direction: ManualDirections.top,
                  ),
                  _createDirection(
                    title: 'شرق (E)',
                    direction: ManualDirections.right,
                    rotateDirection: RotateDirection.toRight,
                  ),
                  _createDirection(
                    title: 'جنوب (S)',
                    direction: ManualDirections.bottom,
                  ),
                  _createDirection(
                    title: 'غرب (W)',
                    direction: ManualDirections.left,
                    rotateDirection: RotateDirection.toLeft,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDirection({
    required String title,
    required ManualDirections direction,
    RotateDirection rotateDirection = RotateDirection.normal,
  }) {
    int quarterTurns = 0;
    switch (rotateDirection) {
      case RotateDirection.toRight:
        quarterTurns = 1;
        break;
      case RotateDirection.toLeft:
        quarterTurns = 3;
        break;
      case RotateDirection.normal:
        quarterTurns = 0;
        break;
    }

    Alignment alignment = Alignment.center;
    switch (direction) {
      case ManualDirections.top:
        alignment = Alignment.topCenter;
        break;
      case ManualDirections.bottom:
        alignment = Alignment.bottomCenter;
        break;
      case ManualDirections.right:
        alignment = Alignment.centerRight;
        break;
      case ManualDirections.left:
        alignment = Alignment.centerLeft;
        break;
    }

    return Align(
      alignment: alignment,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: context.isDarkMode
                ? ConstColors.goldAccent
                : ConstColors.primaryTeal,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: context.isDarkMode
                  ? ConstColors.primaryTeal
                  : ConstColors.goldAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  //Auto qibla (compass)
  Widget _buildAutoMode(double qiblaBearing) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Porgress());
        }

        double? deviceHeading = snapshot.data?.heading;

        if (deviceHeading == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_tabController!.index == 0) {
              _tabController!.animateTo(1);
            }
          });

          return const Center(
            child: Text(
              'جهازك لا يدعم البوصلة.. جاري التحويل للوضع اليدوي ⏳',
              style: TextStyle(color: Colors.amber, fontSize: 16),
            ),
          );
        }

        double qiblaAngle = (qiblaBearing - deviceHeading) * (math.pi / 180.0);

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'اظبط المؤشر على الكعبة',
                  style: TextStyle(
                    color: context.isDarkMode
                        ? ConstColors.goldAccent
                        : ConstColors.primaryTeal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "من الافضل ان يكون الهاتف على سطح مستوي",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 18,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 400,
                      height: 400,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.grey[100],
                        // border: Border.all(
                        //   color: ConstColors.primaryTeal,
                        //   width: 2,
                        // ),
                      ),
                      child: Transform.rotate(
                        angle: qiblaAngle,
                        child: Image.asset(ConstIcons.autoKaabaDirection),
                      ),
                    ),
            
                    Positioned(
                      top: 10,
                      child: Image.asset(ConstIcons.kaabaLocation, width: 60),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: Porgress()));
    }

    return _isLoading
        ? const Center(child: Porgress())
        : AppScaffold(
            appBar: MyAppbar(
              pageName: ConstTexts.qibla,
              showSettingsButton: true,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: ConstColors.tealGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                indicatorColor: Colors.white,
                indicatorAnimation: TabIndicatorAnimation.elastic,
                overlayColor: WidgetStatePropertyAll<Color>(
                  context.isDarkMode
                      ? Colors.white.withValues(alpha: .2)
                      : ConstColors.primaryTeal.withValues(alpha: .2),
                ),
                tabs: const [
                  Tab(
                    icon: Icon(
                      CupertinoIcons.compass_fill,
                      // color: ,
                    ),
                    text: 'بوصلة',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.directions,
                      // color: isDark ? Colors.white : ConstColors.primaryTeal,
                    ),
                    text: 'توجيه',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildAutoMode(_qiblaBearing!),
                _buildManualMode(_qiblaBearing!),
              ],
            ),
          );
  }
}
