import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class StadiumDeleteDialog extends StatelessWidget {
  final String content;
  final bool isDeleting;
  final VoidCallback onDelete;

  const StadiumDeleteDialog({
    super.key,
    required this.content,
    required this.isDeleting,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color.fromARGB(255, 255, 126, 126),
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Are you sure?",
              style: SportifindTheme.titleDeletStadium,
            ),
            const SizedBox(height: 16),
            Text(
              content,
              textAlign: TextAlign.center,
              style: SportifindTheme.contentDeletStadium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();  // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 33),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      )
                    ),
                  ),
                  child: Text("No", style: SportifindTheme.noDeleteDialog),
                ),
                TextButton(
                  onPressed: isDeleting ? null : onDelete,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 32),
                    backgroundColor: const Color.fromARGB(255, 255, 126, 126),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isDeleting
                      ? SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            color: SportifindTheme.bluePurple,
                          ),
                        )
                      : Text("Yes", style: SportifindTheme.yesDeleteDialog),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
