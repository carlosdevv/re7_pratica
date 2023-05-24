import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/ui_control.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextInputFormatter? mask;
  final String hintText;
  final double? hintFontSize;
  final String label;
  final double? width;
  final double? height;
  final double? padVertical;
  final double? padHorizontal;
  final bool readOnly;
  final bool? activeBorder;
  final int? maxLines;
  final bool? hasIcon;
  final Icon? icon;
  final Function()? onPressedIcon;
  const InputWidget({
    Key? key,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.mask,
    this.hintFontSize,
    required this.hintText,
    required this.label,
    this.width,
    this.height,
    this.padVertical = 16,
    this.padHorizontal = 18,
    required this.readOnly,
    this.activeBorder,
    this.maxLines,
    this.hasIcon,
    this.icon,
    this.onPressedIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.wsz),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.text100,
                fontSize: 16.wsz,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 4.wsz),
          TextFormField(
            controller: controller,
            textInputAction: textInputAction ?? TextInputAction.done,
            keyboardType: keyboardType ?? TextInputType.text,
            readOnly: readOnly,
            maxLines: maxLines ?? 1,
            inputFormatters: mask != null ? [mask!] : [],
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                    color: AppColors.text100,
                    fontWeight: FontWeight.w600,
                    fontSize: hintFontSize),
                errorStyle: const TextStyle(height: 0),
                focusedBorder: readOnly
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      )
                    : OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                enabledBorder: activeBorder != null
                    ? activeBorder!
                        ? OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          )
                    : const OutlineInputBorder(borderSide: BorderSide.none),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                fillColor: AppColors.containerInput,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: padVertical!, horizontal: padHorizontal!),
                suffixIcon: hasIcon != null
                    ? TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.containerInput,
                        ),
                        onPressed: onPressedIcon,
                        child: icon!,
                      )
                    : null),
            validator: (value) {
              if (value!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
