import 'package:coin_ranking_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendsItem extends StatelessWidget {
  const InviteFriendsItem({super.key});

  static const _jobsUrl = 'https://www.7solutions.co.th/jobs';

  Future<void> _share(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        title: context.l10n.inviteFriends,
        text: _jobsUrl,
        sharePositionOrigin: renderBox == null
            ? null
            : renderBox.localToGlobal(Offset.zero) & renderBox.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _share(context),
      child: Container(
        width: double.infinity,
        height: 58.h,
        padding: REdgeInsets.symmetric(horizontal: 18, vertical: 9),
        color: const Color(0xFFF0E6FA),
        child: Row(
          children: [
            _buildIcon(),
            SizedBox(width: 14.w),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      width: 28.w,
      height: 28.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Icon(
              Icons.person_rounded,
              size: 23.sp,
              color: const Color(0xFF6815C5),
            ),
          ),
          Positioned(
            top: 1.h,
            right: 0,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 11.sp,
              color: const Color(0xFF6815C5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.inviteFriends,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF4B1591),
            fontSize: 14.sp,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          context.l10n.inviteDescription,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF8452C4),
            fontSize: 11.sp,
            height: 1.1,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
