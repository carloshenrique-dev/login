import 'package:compound/ui/views/login_view.dart';
import 'package:compound/ui/widgets/busy_button.dart';
import 'package:compound/ui/widgets/text_link.dart';
import 'package:flutter/material.dart';

class LogoutView extends StatelessWidget {
  const LogoutView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff050210),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                child: Image.asset('assets/images/alien1.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextLink('Ei!! Vai embora?!'),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BusyButton(
                  title: 'Logout',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
