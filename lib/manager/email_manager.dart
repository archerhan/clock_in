import 'package:clock_in/utils/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailManager {
  static Future sendFeedbackEmail({String? filePath}) async {
    final Email email = Email(
      body:
          '\n\n\n\n\n App Version: 1.0.0\n Device: Android\n OS Version: 12\n',
      subject: 'Feedback Email Test',
      recipients: ['feedback@example.com'],
      cc: [],
      bcc: [],
      attachmentPaths: filePath?.isNotEmpty == true ? [filePath!] : [],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      final err = e as PlatformException;
      showToast('发送邮件出现错误:\n${err.message}');
    }
  }
}
