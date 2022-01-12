import 'dart:collection';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/UIScreens/drawer_screen.dart';
import 'package:oyaridedriver/UIScreens/trip_detail_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timelines/timelines.dart';
// ignore_for_file: prefer_const_constructors

class YourTripScreen extends StatefulWidget {
  const YourTripScreen({Key? key}) : super(key: key);

  @override
  _YourTripScreenState createState() => _YourTripScreenState();
}

class _YourTripScreenState extends State<YourTripScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  double largeFontSize = 22;
  double mediumFontSize = 19;
  double smallFontSize = 14;
  FontWeight largeFontWeight = FontWeight.w900;
  FontWeight mediumFontWeight = FontWeight.w600;
  FontWeight normalFontWeight = FontWeight.normal;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget("Your Trip", scaffoldKey),
      drawer: DrawerScreen(),
      body: Column(
        children: [
          calendarWidget(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [totalJobs(), totalEarn()],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(child: cartListview())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget totalJobs() {
    return Container(
      decoration: BoxDecoration(
          color: AllColors.blackColor, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(left: 7, right: 25, top: 10, bottom: 10),
      child: Row(
        children: [
          Icon(
            Icons.car_rental,
            color: AllColors.whiteColor,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  txt: "Total Jobs",
                  fontSize: ScreenUtil().setSp(smallFontSize),
                  color: AllColors.whiteColor,
                  bold: FontWeight.normal,
                  italic: false),
              textWidget(
                  txt: "1,432",
                  fontSize: ScreenUtil().setSp(largeFontSize),
                  color: AllColors.whiteColor,
                  bold: largeFontWeight,
                  italic: false),
            ],
          )
        ],
      ),
    );
  }

  Widget totalEarn() {
    return Container(
      decoration: BoxDecoration(
          color: AllColors.greenColor, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(left: 7, right: 25, top: 10, bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: AllColors.whiteColor,
              radius: 18,
              child: Icon(
                Icons.attach_money,
                color: AllColors.greenColor,
                size: 27,
              )),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  txt: "Total Earn",
                  fontSize: ScreenUtil().setSp(smallFontSize),
                  color: AllColors.whiteColor,
                  bold: normalFontWeight,
                  italic: false),
              textWidget(
                  txt: "\$ 2500",
                  fontSize: ScreenUtil().setSp(largeFontSize),
                  color: AllColors.whiteColor,
                  bold: largeFontWeight,
                  italic: false),
            ],
          )
        ],
      ),
    );
  }

  Widget cartListview() {
    return ListView.builder(
        itemCount: 3,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => TripDetailScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                color: AllColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textWidget(
                                txt: "29 Sept 2021",
                                fontSize: ScreenUtil().setSp(mediumFontSize),
                                color: AllColors.blackColor,
                                bold: normalFontWeight,
                                italic: false),
                            textWidget(
                                txt: "\$60",
                                fontSize: ScreenUtil().setSp(mediumFontSize),
                                color: AllColors.blackColor,
                                bold: mediumFontWeight,
                                italic: false),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textWidget(
                                txt: "Seden Car",
                                fontSize: ScreenUtil().setSp(mediumFontSize),
                                color: AllColors.blackColor,
                                bold: mediumFontWeight,
                                italic: false),
                            Row(
                              children: [
                                textWidget(
                                    txt: "Payment : ",
                                    fontSize: mediumFontSize,
                                    color: AllColors.blackColor,
                                    bold: normalFontWeight,
                                    italic: false),
                                textWidget(
                                    txt: "Cash",
                                    fontSize: ScreenUtil().setSp(mediumFontSize),
                                    color: AllColors.blackColor,
                                    bold: mediumFontWeight,
                                    italic: false),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).putPadding(0, 0, 7, 7),
                    SizedBox(
                      height: 5,
                    ),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemSize: 16,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: AllColors.greenColor,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      height: 2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        TimelineTile(
                          nodeAlign: TimelineNodeAlign.start,
                          contents: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(
                                    txt: "Source Location",
                                    fontSize: ScreenUtil().setSp(smallFontSize),
                                    color: AllColors.greyColor,
                                    bold: normalFontWeight,
                                    italic: false),
                                const SizedBox(
                                  height: 3,
                                ),
                                textWidget(
                                    txt: "Medical Education Center",
                                    fontSize: ScreenUtil().setSp(smallFontSize),
                                    color: AllColors.greyColor,
                                    bold: normalFontWeight,
                                    italic: false),
                              ],
                            ),
                          ),
                          node: TimelineNode(
                              indicator: ContainerIndicator(
                                  child: CircleAvatar(
                                backgroundColor: AllColors.greenColor,
                                radius: 4,
                              )),
                              endConnector: const DashedLineConnector(
                                color: AllColors.greyColor,
                              )),
                        ),
                        TimelineTile(
                          nodeAlign: TimelineNodeAlign.start,
                          contents: Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(
                                    txt: "Destination Location",
                                    fontSize: ScreenUtil().setSp(smallFontSize),
                                    color: AllColors.greyColor,
                                    bold: normalFontWeight,
                                    italic: false),
                                const SizedBox(
                                  height: 3,
                                ),
                                textWidget(
                                    txt: "Barthingam Collage",
                                    fontSize: ScreenUtil().setSp(smallFontSize),
                                    color: AllColors.greyColor,
                                    bold: normalFontWeight,
                                    italic: false),
                              ],
                            ),
                          ),
                          node: TimelineNode(
                            startConnector: const DashedLineConnector(
                              color: AllColors.greyColor,
                            ),
                            indicator: ContainerIndicator(
                                child: CircleAvatar(
                              backgroundColor: AllColors.blueColor,
                              radius: 4,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget calendarWidget() {
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      daysOfWeekVisible: true,startingDayOfWeek:StartingDayOfWeek.sunday ,

      calendarFormat: _calendarFormat,
      calendarBuilders: CalendarBuilders(
        singleMarkerBuilder: (context, dateTime,_){
          return Container(color: Colors.green,);
        }
      ),
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
          onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
    );
  }

  Widget textWidget(
      {required String txt,
      required double fontSize,
      required Color color,
      required FontWeight bold,
      required bool italic}) {
    return Text(
      txt,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
}..addAll({
    kToday: [
      const Event('Today\'s Event 1'),
      const Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class TableComplexExample extends StatefulWidget {
  @override
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class _TableComplexExampleState extends State<TableComplexExample> {
  late final PageController _pageController;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Complex'),
      ),
      body: Column(
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, value, _) {
              return _CalendarHeader(
                focusedDay: value,
                clearButtonVisible: canClearSelection,
                onTodayButtonTap: () {
                  setState(() => _focusedDay.value = DateTime.now());
                },
                onClearButtonTap: () {
                  setState(() {
                    _rangeStart = null;
                    _rangeEnd = null;
                    _selectedDays.clear();
                    _selectedEvents.value = [];
                  });
                },
                onLeftArrowTap: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onRightArrowTap: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
              );
            },
          ),
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay.value,
            headerVisible: false,
            selectedDayPredicate: (day) => _selectedDays.contains(day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            holidayPredicate: (day) {
              // Every 20th day of the month will be treated as a holiday
              return day.day == 20;
            },
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onCalendarCreated: (controller) => _pageController = controller,
            onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
              }
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}