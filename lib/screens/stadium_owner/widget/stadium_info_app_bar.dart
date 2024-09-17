import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class StadiumInfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onUpdateStatus;
  final bool isStadiumOwnerUser;

  const StadiumInfoAppBar({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateStatus,
    required this.isStadiumOwnerUser,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Stadium Information',
        style: SportifindTheme.sportifindFeatureAppBarBluePurpleSmall,
      ),
      centerTitle: true,
      backgroundColor: SportifindTheme.backgroundColor,
      iconTheme: IconThemeData(color: SportifindTheme.bluePurple),
      elevation: 0,
      surfaceTintColor: SportifindTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        isStadiumOwnerUser
            ? PopupMenuButton(
                constraints: const BoxConstraints(
                  maxWidth: 40,
                ),
                color: Colors.white,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      height: 30,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Icon(Icons.edit, size: 25),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      height: 30,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Icon(Icons.delete, size: 25),
                    ),
                    const PopupMenuItem(
                      value: 'update',
                      height: 30,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Icon(Icons.rule, size: 25),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  } else if (value == 'update') {
                    onUpdateStatus();
                  }
                },
                child: const Icon(
                  Icons.more_vert,
                  size: 30,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
