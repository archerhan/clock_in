import 'package:clock_in/constants/app_strings.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailManager {
  static Future sendFeedbackEmail(
      {required bool? isFeedback,
      String? subject,
      String? attachmentPath}) async {
    final Email email = Email(
      body: '\n\n\n\n\n',
      subject: subject ?? "暂无主题",
      recipients: isFeedback == true ? [AppStrings.feedbackEmailAddress] : [],
      cc: [],
      bcc: [],
      attachmentPaths:
          attachmentPath?.isNotEmpty == true ? [attachmentPath!] : [],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      final err = e as PlatformException;
      showToast('发送邮件出现错误,请检查您是否安装邮件客户端,并且已经登录可用的邮箱账号');
      logger.e('发送邮件出现错误: ${err.message}');
    }
  }
}
