import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

enum SettingDialogType { helpAndFeedback, aboutUs, policy }

class SettingDialog extends StatelessWidget {
  final SettingDialogType type;

  const SettingDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_getTitle(), style: SportifindTheme.normalTextBlack.copyWith(color: SportifindTheme.bluePurple, fontSize: 20)),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            _buildSection(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          child: Text('Close', style: SportifindTheme.normalTextBlack.copyWith(color: SportifindTheme.bluePurple)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  String _getTitle() {
    switch (type) {
      case SettingDialogType.helpAndFeedback:
        return 'Help & Feedback';
      case SettingDialogType.aboutUs:
        return 'About Us';
      case SettingDialogType.policy:
        return 'Policy';
      default:
        return '';
    }
  }

  Widget _buildSection() {
    switch (type) {
      case SettingDialogType.helpAndFeedback:
        return _buildHelpAndFeedbackSection();
      case SettingDialogType.aboutUs:
        return _buildAboutUsSection();
      case SettingDialogType.policy:
        return _buildPolicySection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHelpAndFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Text(
          'If you need help or have feedback, please reach out to us via email or phone. We are here to assist you with any issues or suggestions.',
        style: SportifindTheme.normalTextBlack),
        const SizedBox(height: 20),
        Text(
          'Contact Us:',
          style: SportifindTheme.normalTextBlack,
        ),
        const SizedBox(height: 10),
        Text('Email: pleasedontsend@ourteam.com', style: SportifindTheme.normalTextBlack),
        Text('Phone: +123 456 7890', style: SportifindTheme.normalTextBlack),
      ],
    );
  }

  Widget _buildAboutUsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Text(
          'We are a passionate team of developers, designers, and product managers committed to building amazing apps that solve real-world problems.',
        style: SportifindTheme.normalTextBlack),
        const SizedBox(height: 20),
        Text(
          'Team Members:',
          style: SportifindTheme.normalTextBlack,
        ),
        const SizedBox(height: 10),
        Text('• Nguyen Hoang Khai Minh', style: SportifindTheme.normalTextBlack),
        Text('• Tran Minh Thu', style: SportifindTheme.normalTextBlack),
        Text('• Nguyen Van Le Ba Thanh', style: SportifindTheme.normalTextBlack),
        Text('• Pham Gia Bao', style: SportifindTheme.normalTextBlack),
        Text('• Vu Thai Phuc', style: SportifindTheme.normalTextBlack),
      ],
    );
  }

  Widget _buildPolicySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Text(
          'Our policies are designed to protect your privacy and ensure that your data is safe with us. Please review our terms and conditions for more details.',
        style: SportifindTheme.normalTextBlack),
        const SizedBox(height: 20),
        Text(
          'Privacy Policy:',
          style: SportifindTheme.normalTextBlack,
        ),
        const SizedBox(height: 10),
        Text(
          'We collect minimal data necessary to provide our services. Your data is stored securely and never shared with third parties without your consent.',
        style: SportifindTheme.normalTextBlack),
        const SizedBox(height: 20),
        Text(
          'Terms & Conditions:',
          style: SportifindTheme.normalTextBlack,
        ),
        const SizedBox(height: 10),
        Text(
          'By using our app, you agree to comply with our terms and conditions. Please read them carefully to understand your rights and responsibilities.',
        style: SportifindTheme.normalTextBlack),
      ],
    );
  }
}
