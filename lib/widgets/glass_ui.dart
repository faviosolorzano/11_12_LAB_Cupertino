import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract final class AppColors {
  static const violet = Color(0xFF6551D9);
  static const ink = Color(0xFF252444);
  static const muted = Color(0xFF6D6C85);
  static const background = Color(0xFFF3F3FB);
  static const green = Color(0xFF16866F);
  static const red = Color(0xFFCE4F6B);
}

/// Vidrio con desenfoque real y borde luminoso. Sin componentes Material.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.tint = const Color(0xAAFFFFFF),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color tint;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      boxShadow: const [
        BoxShadow(
          color: Color(0x09604EAA),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xE6FFFFFF), width: 1.4),
          ),
          child: child,
        ),
      ),
    ),
  );
}

class GlassPage extends StatelessWidget {
  const GlassPage({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.back = true,
  });
  final String title;
  final Widget child;
  final Widget? trailing;
  final bool back;
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    backgroundColor: AppColors.background,
    navigationBar: CupertinoNavigationBar(
      backgroundColor: const Color(0xB3F7F6FF),
      border: null,
      automaticallyImplyLeading: back,
      middle: Text(title),
      trailing: trailing,
      previousPageTitle: 'Atrás',
    ),
    child: Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8E4FF),
                  Color(0xFFF6F6FC),
                  Color(0xFFE1F5F2),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: -95,
          child: _orb(const Color(0xFFB3A0F5), 300),
        ),
        Positioned(
          bottom: 45,
          left: -100,
          child: _orb(const Color(0xFF9EDFD3), 300),
        ),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: child,
            ),
          ),
        ),
      ],
    ),
  );
  Widget _orb(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withValues(alpha: .6), color.withValues(alpha: 0)],
      ),
    ),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key, this.eyebrow});
  final String title, subtitle;
  final String? eyebrow;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!,
            style: const TextStyle(
              color: AppColors.violet,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

class IconBadge extends StatelessWidget {
  const IconBadge(
    this.icon, {
    super.key,
    this.color = AppColors.violet,
    this.size = 44,
  });
  final IconData icon;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(size * .3),
    ),
    child: Icon(icon, color: color, size: size * .5),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.icon = CupertinoIcons.arrow_right,
  });
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: CupertinoButton.filled(
      borderRadius: BorderRadius.circular(18),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 19),
        ],
      ),
    ),
  );
}

class LabeledField extends StatelessWidget {
  const LabeledField(
    this.label, {
    super.key,
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
    this.formatters,
    this.onSubmitted,
    this.last = false,
  });
  final String label, placeholder;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscure, last;
  final Widget? suffix;
  final List<TextInputFormatter>? formatters;
  final ValueChanged<String>? onSubmitted;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 9),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          obscureText: obscure,
          keyboardType: keyboardType,
          inputFormatters: formatters,
          suffix: suffix,
          textCapitalization: keyboardType == TextInputType.name
              ? TextCapitalization.words
              : TextCapitalization.none,
          textInputAction: last ? TextInputAction.done : TextInputAction.next,
          onSubmitted: onSubmitted ?? (_) => FocusScope.of(context).nextFocus(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          style: const TextStyle(fontSize: 15, color: AppColors.ink),
          placeholderStyle: const TextStyle(
            color: AppColors.muted,
            fontSize: 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0x80FFFFFF),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0x1A6551D9)),
          ),
        ),
      ],
    ),
  );
}

Future<void> showMessage(BuildContext context, String title, String message) =>
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );

Future<bool> confirmAction(
  BuildContext context,
  String title,
  String message,
  String action,
) async =>
    await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(action),
          ),
        ],
      ),
    ) ??
    false;
