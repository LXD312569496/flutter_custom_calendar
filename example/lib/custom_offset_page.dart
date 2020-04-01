import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

/**
 * 自定义风格+单选
 */
class CustomOffsetPage extends StatefulWidget {
  CustomOffsetPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CustomOffsetPageState createState() => _CustomOffsetPageState();
}

class _CustomOffsetPageState extends State<CustomOffsetPage> {
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  CalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = new CalendarController(
        offset: 1
    );

    controller.addMonthChangeListener(
          (year, month) {
        text.value = "$year年$month月";
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      selectText.value =
      "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}";
    });

    text = new ValueNotifier("${DateTime.now().year}年${DateTime.now().month}月");

    selectText = new ValueNotifier(
        "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      controller.moveToPreviousMonth();
                    }),
                ValueListenableBuilder(
                    valueListenable: text,
                    builder: (context, value, child) {
                      return new Text(text.value);
                    }),
                new IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    }),
              ],
            ),
            CalendarViewWidget(
                calendarController: controller,
                weekBarItemWidgetBuilder: () {
                  return CustomStyleWeekBarItem();
                },
                dayWidgetBuilder: (dateModel) {
                  return CustomStyleDayWidget(dateModel);
                }
              ),
            ValueListenableBuilder(
                valueListenable: selectText,
                builder: (context, value, child) {
                  return new Text(selectText.value);
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["日", "一", "二", "三", "四", "五", "六"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      child: new Center(
        child: new Text(weekList[index]),
      ),
    );
  }
}

class CustomStyleDayWidget extends BaseCustomDayWidget {
  CustomStyleDayWidget(DateModel dateModel) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    if (!dateModel.isCurrentMonth) {
      return;
    }
    bool isWeekend = dateModel.isWeekend;
    bool isInRange = dateModel.isInRange;

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(
              color: !isInRange
                  ? Colors.grey
                  : isWeekend ? Colors.blue : Colors.black,
              fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(
              color: !isInRange
                  ? Colors.grey
                  : isWeekend ? Colors.blue : Colors.grey,
              fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    if (!dateModel.isCurrentMonth) {
      return;
    }
    //绘制背景
    Paint backGroundPaint = new Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    double padding = 8;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        (size.width - padding) / 2, backGroundPaint);

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(color: Colors.white, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(color: Colors.white, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }
}
