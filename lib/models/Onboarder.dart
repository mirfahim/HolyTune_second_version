import '../utils/StringsConst.dart';
import '../i18n/strings.g.dart';

class Onboarder {
  String image;
  String title;
  String hint;

  static List<Onboarder> getOnboardingItems() {
    List<Onboarder> items = [];
    for (int i = 0; i < t.onboardertitle.length; i++) {
      Onboarder obj = new Onboarder();
      obj.image = StringsConst.onboarder_image[i];
      obj.title = t.onboardertitle[i];
      obj.hint = t.onboarderhints[i];
      items.add(obj);
    }
    return items;
  }
}
