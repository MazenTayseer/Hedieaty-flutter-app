import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';
import 'package:hedieaty_mobile_app/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';

class SingleGift extends StatelessWidget {
  final String giftId;
  final String giftName;
  final double giftPrice;
  final String giftStatus;
  final String cloudType;
  final VoidCallback onDelete;

  const SingleGift({
    super.key,
    required this.giftId,
    required this.giftName,
    required this.giftPrice,
    required this.giftStatus,
    required this.cloudType,
    required this.onDelete,
  });

  Future<void> _deleteFromCloud(String id, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('Gifts').doc(id).delete();
      showSnackBarSuccess(context, 'Gift deleted from cloud successfully!');
      onDelete();
    } catch (e) {
      showSnackBarError(context, 'Failed to delete from cloud: $e');
    }
  }

  Future<void> _deleteFromLocal(String id, BuildContext context) async {
    final db = DatabaseHelper.instance;
    try {
      await db.delete('Gifts', where: 'id = ?', whereArgs: [id]);
      showSnackBarSuccess(context, 'Gift deleted from local database!');
      onDelete();
    } catch (e) {
      showSnackBarError(context, 'Failed to delete from local: $e');
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete this $cloudType gift? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (cloudType == 'local') {
                _deleteFromLocal(giftId, context);
              } else {
                _deleteFromCloud(giftId, context);
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: CircleAvatar(
        backgroundColor: cloudType == 'local'
            ? AppColors.blue
            : giftStatus == 'pledged'
                ? AppColors.green
                : giftStatus == 'purchased'
                    ? AppColors.blue
                    : AppColors.red,
        child: Text(
          giftName[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        giftName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: AppColors.white,
        ),
      ),
      subtitle: Text(
        '\$${giftPrice.toStringAsFixed(2)}',
        style: const TextStyle(color: AppColors.greyText),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: AppColors.red),
        onPressed: () => _confirmDelete(context),
      ),
    );
  }
}
