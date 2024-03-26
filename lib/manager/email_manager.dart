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

    await FlutterEmailSender.send(email);
  }
}
