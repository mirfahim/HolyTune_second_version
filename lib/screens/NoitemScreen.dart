import 'package:flutter/material.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../i18n/strings.g.dart';

class NoitemScreen extends StatelessWidget {
  final String title;
  final String message;
  final Function onClick;

  const NoitemScreen({
    Key key,
    @required this.title,
    @required this.message,
    @required this.onClick,
  })  : assert(title != null),
        assert(message != null),
        assert(onClick != null),
        super(key: key);

  void onItemClick() {
    onClick();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: InkWell(
          onTap: () {
            onItemClick();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(title,
                  style: TextStyles.display1(context)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 22)),
              Container(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyles.medium(context).copyWith(fontSize: 16)),
              ),
              Container(height: 25),
              Container(
                //color: MyColors.accent,
                width: 180,
                height: 40,
                child: ElevatedButton(
                  child: Text(t.retry, style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: MyColors.accentDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  onPressed: () {
                    onItemClick();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
