import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import '../theme/app_colors.dart';

/// App bar untuk halaman form/detail: tombol kembali + judul.
class FormAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const FormAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => openProfileScreen(context),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child:
                      Icon(Icons.person_outline, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}