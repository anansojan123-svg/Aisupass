import 'dart:async';

import 'package:Aisupass/core/constants/community_links.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/announcement/domain/models/announcement.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// 展示公告底部弹层，等用户关闭后返回。
Future<void> showAnnouncementPrompt(
  BuildContext context, {
  required Announcement announcement,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (BuildContext sheetContext) =>
      _AnnouncementSheet(announcement: announcement),
);

class _AnnouncementSheet extends HookWidget {
  const _AnnouncementSheet({required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.campaign_rounded,
                    size: 20.sp,
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    l10n.announcementTitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SelectableText(
                announcement.content,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.7,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(
                        launchUrl(
                          Uri.parse(CommunityLinks.communityGroup),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                      icon: Icon(Icons.menu_book_rounded, size: 18.sp),
                      label: Text(l10n.announcementTutorial),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.announcementClose),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
