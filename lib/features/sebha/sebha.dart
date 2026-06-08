import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/core/widgets/counter_button.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/progress.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:zad_almuslim/features/sebha/sebha_logic.dart';
import 'package:zad_almuslim/features/sebha/user_azkar_storage.dart';

class Sebha extends StatefulWidget {
  const Sebha({super.key});

  @override
  State<Sebha> createState() => _SebhaState();
}

class _SebhaState extends State<Sebha> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List sebhaAzkar = [];
  bool isLoading = true;
  bool isFirst33 = false;
  int counter = 0;
  GlobalKey<FormState> addZikrFormState = GlobalKey<FormState>();
  late String zikrAddedByUser;
  bool isZikrSelected = false;
  List<Map<String, dynamic>> userAzkar = [];
  final UserAzkarStorage _storage = UserAzkarStorage();
  void _showMilestoneSnackbar(int currentCounter) {
    final int milestone = currentCounter;

    String message = "تَمّت $milestone.. زادك الله نوراً";
    if (milestone == 33) {
      message = "ثلث المائة.. تقبّل الله منك";
    } else if (milestone == 66) {
      message = "ثلثا المائة.. واصل بقلبٍ حاضر";
    } else if (milestone == 99) {
      message = "٩٩.. بقي ذكرٌ واحد لتمام المائة";
    }
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: ConstColors.mainColor.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void showAddZikrForm() {
    showAdaptiveDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.orange,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "تستطيع حذفه إذا قمت بتمريره لليسار",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "تم إضافة الذكر بنجاح",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: ConstColors.mainColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ConstColors.input,
                      hintText: "اكتب الذكر هنا...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ), // متناسق مع زوايا الحاوية
                        borderSide: BorderSide.none,
                      ),
                      // إضاءة خفيفة عند التركيز والكتابة
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: ConstColors.mainColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  // 3. زر التأكيد (Confirm Button)
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
                        width: 24,
                        height: 24,
                      ),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: ConstColors.mainColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: ConstColors.mainColor.withOpacity(0.4),
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
    Map<String, dynamic> zikrData = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "content": zikrAddedByUser,
    };

    await _storage.addNewZikr(zikrData);
  }

  Future<void> loadUserAzkar() async {
    userAzkar = await _storage.loadUserAzkar();
    setState(() {
      isLoading = false;
    });
  }

  void loadData() async {
    var data = await SebhaLogic.loadSebhaAzkar();
    if (data.isNotEmpty) {
      setState(() {
        sebhaAzkar.addAll(data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    loadUserAzkar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldState,
      appBar: MyAppbar(
        onPressDrawer: () {
          scaffoldState.currentState!.openDrawer();
        },
        pageName: ConstTexts.mesbha,
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Porgress()
          : SpecialBody(
              body: Column(
                children: [
                  SizedBox(height: 180),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownMenu<String>(
                          onSelected: (value) => setState(() {
                            isZikrSelected = true;
                          }),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: "uthman",
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                          expandedInsets: EdgeInsets.zero,
                          showTrailingIcon: false,

                          inputDecorationTheme: InputDecorationTheme(
                            fillColor: ConstColors.mainColor,
                            filled: true,
                            alignLabelWithHint: false,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          label: const Center(
                            child: Text(
                              "اختر ذكرََا",
                              style: TextStyle(
                                color: Color.fromARGB(125, 255, 255, 255),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          menuStyle: MenuStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 4),
                            ),
                            maximumSize: WidgetStatePropertyAll(
                              Size(
                                double.infinity,
                                MediaQuery.sizeOf(context).height * 0.54,
                              ),
                            ),
                            alignment: Alignment.bottomRight,
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            elevation: const WidgetStatePropertyAll(12),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),

                          dropdownMenuEntries: [
                            ...List.generate(sebhaAzkar.length, (zikr) {
                              return DropdownMenuEntry<String>(
                                value: sebhaAzkar[zikr]["content"],
                                label: sebhaAzkar[zikr]["content"],

                                labelWidget: Container(
                                  width: double.infinity,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: ConstColors.mainColor.withValues(
                                          alpha: 0.8,
                                        ),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),

                                  child: Text(
                                    sebhaAzkar[zikr]["content"],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: "uthman",
                                      fontSize: 18,
                                    ),
                                  ),
                                ),

                                style: MenuItemButton.styleFrom(
                                  alignment: Alignment.center,
                                  fixedSize: const Size.fromHeight(60),
                                  padding: EdgeInsets.zero,
                                ),
                              );
                            }),
                            //user azkar
                            ...List.generate(userAzkar.length, (userZikr) {
                              final uZikr = userAzkar[userZikr];
                              return DropdownMenuEntry<String>(
                                value: uZikr['content'],
                                label: uZikr['content'],

                                labelWidget: Dismissible(
                                  key: Key(uZikr['content']),
                                  background: Container(
                                    padding: EdgeInsets.only(right: 20),
                                    alignment: Alignment.centerRight,
                                    color: Colors.red.withOpacity(0.7),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.startToEnd,

                                  // confirmDismiss: (direction) => showDialog(
                                  //   context: context,
                                  //   builder: (context) => AlertDialog(
                                  //     title: Text("تأكيد الحذف"),
                                  //     content: Text(
                                  //       "هل انت متأكد من حذف العنصر ؟",
                                  //     ),
                                  //     actions: [
                                  //       TextButton(
                                  //         onPressed: () {},
                                  //         child: Text("حذف"),
                                  //       ),
                                  //       TextButton(
                                  //         onPressed: () {},
                                  //         child: Text("تراجع"),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  onDismissed: (direction) async {
                                    // 1. أضفنا async هنا
                                    // 2. احذف من الملف الموقت وانتظر انتهاء العملية
                                    await _storage.removeZikr(uZikr["id"]);

                                    // 3. حدث الواجهة واحذف العنصر من القائمة المحلية في الذاكرة
                                    setState(() {
                                      userAzkar.removeAt(userZikr);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,

                                        content: Text(
                                          "تم حذف الذكر بنجاح",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: ConstColors.mainColor
                                              .withValues(alpha: 0.8),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),

                                    child: Text(
                                      userAzkar[userZikr]['content'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),

                                style: MenuItemButton.styleFrom(
                                  alignment: Alignment.center,
                                  fixedSize: const Size.fromHeight(60),
                                  padding: EdgeInsets.zero,
                                ),
                              );
                            }),

                            DropdownMenuEntry<String>(
                              value: "اضافة ذكر جديد",
                              label: "add_new_zikr",

                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                              ),

                              labelWidget: IconButton(
                                onPressed: showAddZikrForm,

                                icon: const Icon(Icons.add),

                                color: ConstColors.mainColor,

                                style: IconButton.styleFrom(
                                  backgroundColor: ConstColors.mainColor
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // reset counter
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              counter = 0;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 40),
                            side: BorderSide(
                              color: ConstColors.mainColor,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            "تصفير العداد",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: ConstColors.mainColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: isZikrSelected
                          ? CounterButton(
                              onPressed: () {
                                setState(() {
                                  counter++;
                                });
                                if (counter % 33 == 0 && counter > 0) {
                                  _showMilestoneSnackbar(counter);
                                }
                              },
                              label: counter.toString(),
                            )
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ConstColors.mainColor.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                "اختر الذكر اولا",
                                style: TextStyle(
                                  color: ConstColors.mainColor.withOpacity(0.2),
                                  fontSize: 30,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
