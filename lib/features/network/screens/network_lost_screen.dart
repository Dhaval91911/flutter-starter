import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custome_toast.dart';
import '../../../generated/assets.gen.dart';
import '../state_notifier/network_notifier.dart';

class NetworkLostScreen extends ConsumerWidget {
  const NetworkLostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(networkProvider).isConnected;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 193.h, child: Assets.png.internet.image()),
                SizedBox(height: 10.h),
                Text(
                  'No Internet Connection',
                  style: TextStyle(fontSize: 18.sp, color: const Color(0xff424757), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Please check your connection and try again.',
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xff898B94), fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () async {
                    // await ref.read(networkProvider.notifier).retryConnection(context, ref);

                    if (!isConnected && context.mounted) {
                      showStyledToast('Please check your internet connection.', ToastType.warning);
                    }
                  },
                  child: Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
