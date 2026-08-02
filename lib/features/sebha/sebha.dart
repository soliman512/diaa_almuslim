
import 'package:auto_size_text/auto_size_text.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:diaa_almuslim/core/widgets/progress.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';
import 'package:diaa_almuslim/features/sebha/sebha_logic.dart';
import 'package:diaa_almuslim/features/sebha/user_azkar_storage.dart';
import 'package:share_plus/share_plus.dart';

class Sebha extends StatefulWidget {
  const Sebha({super.key});

  @override
  State<Sebha> createState() => _SebhaState();
}

class _SebhaState extends State<Sebha> with SingleTickerProviderStateMixin {
  List sebhaAzkar = [];
  bool isLoading = true;
  final ValueNotifier<int> counter = ValueNotifier<int>(0);
  final ValueNotifier<int> allSebhaCount = ValueNotifier<int>(0);
  GlobalKey<FormState> addZikrFormState = GlobalKey<FormState>();
  late String zikrAddedByUser;
  final PageController _pageController = PageController();
  List<String> userAzkar = [];
  final UserAzkarStorage _storage = UserAzkarStorage();
  late final AnimationController dottedBorderController;

  void _showMilestoneSnackbar(int currentCounter) {
    final int milestone = currentCounter;

    String message = "تَمّت $milestone.. زادك الله نوراً \n هذه 33 اخرى";
    if (milestone == 33) {
      message = "ثلث المائة.. تقبّل الله منك";
    } else if (milestone == 66) {
      message = "ثلثا المائة.. واصل بقلبٍ حاضر";
    } else if (milestone == 99) {
      message = "99.. بقي ذكرٌ واحد لتمام المائة";
    } else {
      if (milestone / 33 is int) {
        message = "أكملت 33 اخرى.. تقبّل الله منك";
      }
    }
    if (!mounted) {
      return;
    }
    Fluttertoast.showToast(
      msg: message.toArabicFormat(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: ConstColors.primaryTeal.withValues(alpha: 0.9),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void showAddZikrForm() {
    showCupertinoDialog(
      barrierDismissible: true,

      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,

        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: ConstColors.primaryTeal,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: addZikrFormState,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  //text field
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "رجاءً لا تدع الحقل فارغاً";
                      }
                      if (value.length < 2) {
                        return "هذا المحتوى قليل جداً، يبدو أنه ليس ذكراً";
                      }
                      if (value.contains(RegExp(r'[0-9٠-٩]'))) {
                        return "يجب ألا يحتوي المحتوى على أرقام";
                      }
                      return null;
                    },
                    onSaved: (value) async {
                      zikrAddedByUser = value!;
                      await _saveData();
                      await loadUserAzkar();
                      await loadData();

                      if (context.mounted) {
                        Fluttertoast.showToast(
                          msg: "تم إضافة الذكر بنجاح",
                          backgroundColor: ConstColors.primaryTeal,
                          textColor: Colors.white,
                          gravity: ToastGravity.TOP,
                          toastLength: Toast.LENGTH_SHORT,
                        );

                        Navigator.pop(context);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_pageController.hasClients) {
                            _pageController.animateToPage(
                              sebhaAzkar.length - 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          }
                        });
                      }
                    },
                    cursorColor: ConstColors.goldAccent,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ConstColors.goldAccent.withValues(alpha: .1),

                      hintText: "اكتب الذكر هنا...",
                      hintStyle: TextStyle(
                        color: ConstColors.goldAccent.withValues(alpha: .5),
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: ConstColors.goldAccent.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  //info box
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      // color: ConstColors.goldAccent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ConstColors.goldAccent,
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: ConstColors.goldAccent,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "يمكنك حذفه لاحقا",
                            style: TextStyle(
                              fontSize: 14,
                              color: ConstColors.goldAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //confirmation button
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: IconButton(
                      onPressed: () {
                        if (addZikrFormState.currentState!.validate()) {
                          addZikrFormState.currentState!.save();
                        }
                      },
                      icon: Image.asset(
                        ConstIcons.check,
                        color: ConstColors.primaryTeal,
                        width: 24,
                        height: 24,
                      ),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: ConstColors.goldAccent,
                        elevation: 4,
                        shadowColor: ConstColors.goldAccent.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    String zikrData = zikrAddedByUser;

    await _storage.addNewZikr(zikrData);
  }

  Future<void> loadUserAzkar() async {
    userAzkar.clear();
    userAzkar = await _storage.loadUserAzkar();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadData() async {
    var data = await SebhaLogic.loadSebhaAzkar();
    if (data.isNotEmpty) {
      sebhaAzkar.clear();
      setState(() {
        sebhaAzkar.addAll(data);
        sebhaAzkar.addAll(userAzkar);
      });
    }
  }

  void setAllSebhaCount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('sebha_counter', allSebhaCount.value);
  }

  void getallSebhaCount() async {
    final prefs = await SharedPreferences.getInstance();
    allSebhaCount.value = prefs.getInt('sebha_counter') ?? 0;
  }

  @override
  void initState() {
    super.initState();
    loadData();
    loadUserAzkar();
    // setAllSebhaCount();
    getallSebhaCount();
    dottedBorderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
  }

  @override
  void dispose() {
    dottedBorderController.dispose();
    counter.dispose();
    _pageController.dispose();
    allSebhaCount.dispose();
    // selectedIndex.dispose();
    super.dispose();
  }

  void _showAzkarList() {
    showModalBottomSheet(
      backgroundColor: ConstColors.primaryTeal,
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return ListView.builder(
            itemCount: sebhaAzkar.length,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                leading: Text(
                  (index + 1).toString().toArabicFormat(),
                  style: const TextStyle(
                    color: ConstColors.goldAccent,
                    fontSize: 18,
                  ),
                ),
                title: Text(
                  sebhaAzkar[index],
                  style: const TextStyle(
                    color: ConstColors.goldAccent,
                    fontSize: 14,
                  ),
                ),
                trailing: (userAzkar.contains(sebhaAzkar[index]))
                    ? IconButton(
                        onPressed: () async {
                          var itemToDelete = sebhaAzkar[index];
                          int indexInUserAzkar = userAzkar.indexOf(
                            itemToDelete,
                          );

                          if (indexInUserAzkar != -1) {
                            setModalState(() {
                              userAzkar.removeAt(indexInUserAzkar);
                              sebhaAzkar.removeAt(index);
                            });
                            setState(() {});

                            try {
                              await _storage.removeZikrAt(indexInUserAzkar);
                            } catch (e) {
                              print("Error removing from storage: $e");
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(showSettingsButton: true, pageName: ConstTexts.mesbha),

      body: isLoading
          ? const Porgress()
          : SpecialBody(
              body: Column(
                children: [
                  const SizedBox(height: 80),
                  Expanded(
                    flex: 2,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      // width: double.infinity,
                      // height: context.screenSize.height * .22,
                      decoration: BoxDecoration(
                        gradient: ConstColors.tealGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            child: Image.asset(
                              width: 400,
                              ConstIcons.mosque,
                              color: const Color.fromARGB(15, 255, 255, 255),
                            ),
                          ),
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    20,
                                    context.screenSize.height < 700 ? 12 : 36,
                                    20,
                                    12,
                                  ),
                                  child: PageView.builder(
                                    controller: _pageController,

                                    itemCount: sebhaAzkar.length,
                                    itemBuilder: (context, index) =>
                                        AutoSizeText(
                                          sebhaAzkar[index],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'arsura',
                                            fontSize: 18,
                                            color: ConstColors.goldAccent,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _pageController.previousPage(
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                    icon: Image.asset(
                                      ConstIcons.nextZikr,
                                      color: ConstColors.goldAccent,
                                      width: 14,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                    icon: Transform.flip(
                                      flipX: true,
                                      child: Image.asset(
                                        ConstIcons.nextZikr,
                                        color: ConstColors.goldAccent,
                                        width: 14,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: showAddZikrForm,
                                    icon: const Icon(
                                      Icons.add,
                                      color: ConstColors.goldAccent,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _showAzkarList,
                                    icon: const Icon(
                                      Icons.list_rounded,
                                      color: ConstColors.goldAccent,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      int zikrIndex = _pageController.page!
                                          .round();
                                      SharePlus.instance.share(
                                        ShareParams(
                                          text: sebhaAzkar[zikrIndex],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      color: ConstColors.goldAccent,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ValueListenableBuilder(
                      valueListenable: counter,
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () {
                            if (counter.value % 33 == 0 && counter.value > 0) {
                              _showMilestoneSnackbar(counter.value);
                            }
                            counter.value++;
                            allSebhaCount.value++;
                            setAllSebhaCount();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                ConstIcons.sebhaBox,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: AutoSizeText(
                                  counter.value.toString().toArabicFormat(),
                                  key: ValueKey(counter.value),
                                  maxFontSize: 60,
                                  style: TextStyle(
                                    fontSize: 60,
                                    color: context.isDarkMode
                                        ? ConstColors.goldAccent
                                        : ConstColors.primaryTeal,
                                    // fontFamily: '',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: ConstColors.primaryTeal,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                counter.value = 0;
                              },
                              child: const AutoSizeText(
                                'تصفير العداد',
                                maxLines: 1,
                                minFontSize: 8,
                                style: TextStyle(
                                  color: ConstColors.goldAccent,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 35,
                            width: 1,
                            color: Colors.white24,
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: allSebhaCount,
                              builder: (context, value, child) {
                                return FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'حصالتك',
                                        style: TextStyle(
                                          color: ConstColors.goldAccent,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        allSebhaCount.value
                                            .toString()
                                            .toArabicFormat(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 1,
                            color: Colors.white24,
                          ),

                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                counter.value = 0;
                                allSebhaCount.value = 0;
                                setAllSebhaCount();
                              },
                              child: const AutoSizeText(
                                'تصفير الحصالة',
                                maxLines: 1,
                                minFontSize: 8,
                                style: TextStyle(
                                  color: ConstColors.goldAccent,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
