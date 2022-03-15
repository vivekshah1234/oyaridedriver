import 'package:flutter/material.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);
  final String _faceBookUrl = 'https://www.facebook.com/Oyaride.ng';
  final String _instaUrl = "https://www.instagram.com/oyaride.ng/";
  final String _gmail = "info@oyaride.com";
  final String _phoneNumber = "tel://21213123123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  extendBodyBehindAppBar: true,
      backgroundColor: AllColors.whiteColor,
      appBar: appBarWidget2(
        "Help Center",
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  await launch(_faceBookUrl, forceSafariVC: false);
                } catch (e) {
                  await launch(_faceBookUrl, forceSafariVC: false);
                }
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        ImageAssets.fbLogo,
                        scale: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Like us on facebook",
                        style: TextStyle(color: AllColors.blueColor, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: _gmail,
                );
                var url = params.toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        ImageAssets.gmailLogo,
                        scale: 50,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Send an email",
                        style: TextStyle(color: AllColors.blueColor, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await launch(_instaUrl, forceSafariVC: false);
                } catch (e) {
                  await launch(_instaUrl, forceSafariVC: false);
                }
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        ImageAssets.instaLogo,
                        scale: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Follow us on instagram",
                        style: TextStyle(color: AllColors.blueColor, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                //  launch("tel://21213123123");
                try {
                  await launch(_phoneNumber, forceSafariVC: false);
                } catch (e) {
                  await launch(_phoneNumber, forceSafariVC: false);
                }
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 17),
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        ImageAssets.callLogo,
                        scale: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Contact us",
                        style: TextStyle(color: AllColors.blueColor, fontSize: 17),
                      ),
                    ],
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
