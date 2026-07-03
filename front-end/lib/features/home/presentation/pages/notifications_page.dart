import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: fg),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationsLoaded && state.notifications.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    // Mark all unread as read
                    for (final n in state.notifications.where((n) => !n.isRead)) {
                      context.read<NotificationBloc>().add(
                            MarkNotificationReadEvent(n.id),
                          );
                    }
                  },
                  child: Text('Mark all read',
                      style: TextStyle(color: primary, fontSize: 12)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(
                child: CircularProgressIndicator(color: primary));
          }
          if (state is NotificationError) {
            return _ErrorView(
              message: state.message,
              primary: primary,
              fg: fg,
              muted: muted,
              onRetry: () => context
                  .read<NotificationBloc>()
                  .add(const LoadNotificationsEvent()),
            );
          }
          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return _EmptyView(primary: primary, fg: fg, muted: muted);
            }
            return RefreshIndicator(
              color: primary,
              onRefresh: () async {
                context
                    .read<NotificationBloc>()
                    .add(const LoadNotificationsEvent());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _NotificationCard(
                    notification: notification,
                    primary: primary,
                    card: card,
                    fg: fg,
                    muted: muted,
                    border: border,
                    onTap: () {
                      if (!notification.isRead) {
                        context.read<NotificationBloc>().add(
                              MarkNotificationReadEvent(notification.id),
                            );
                      }
                      _showNotificationDetail(
                          context, notification, primary, fg, muted, card, bg);
                    },
                    onDelete: () {
                      context.read<NotificationBloc>().add(
                            DeleteNotificationEvent(notification.id),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Notification deleted'),
                          backgroundColor: Colors.red.shade600,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showNotificationDetail(
    BuildContext context,
    NotificationEntity notification,
    Color primary,
    Color fg,
    Color muted,
    Color card,
    Color bg,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<NotificationBloc>(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: muted.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.notifications_rounded,
                          color: primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.title,
                              style: TextStyle(
                                  color: fg,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('MMM d, y · h:mm a')
                                .format(notification.createdAt.toLocal()),
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(notification.content,
                    style: TextStyle(color: fg, fontSize: 15, height: 1.5)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.red),
                    label: const Text('Delete notification',
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      context.read<NotificationBloc>().add(
                            DeleteNotificationEvent(notification.id),
                          );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final Color primary, card, fg, muted, border;
  final VoidCallback onTap, onDelete;

  const _NotificationCard({
    required this.notification,
    required this.primary,
    required this.card,
    required this.fg,
    required this.muted,
    required this.border,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? card
                : primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notification.isRead
                  ? border
                  : primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? muted.withOpacity(0.1)
                      : primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification.isRead
                      ? Icons.notifications_none_rounded
                      : Icons.notifications_rounded,
                  color: notification.isRead ? muted : primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: fg,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: primary, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.content,
                      style: TextStyle(color: muted, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notification.createdAt),
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt.toLocal());
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt.toLocal());
  }
}

class _EmptyView extends StatelessWidget {
  final Color primary, fg, muted;
  const _EmptyView({required this.primary, required this.fg, required this.muted});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: primary.withOpacity(0.08), shape: BoxShape.circle),
            child:
                Icon(Icons.notifications_none_rounded, color: primary, size: 40),
          ),
          const SizedBox(height: 16),
          Text('No notifications yet',
              style: TextStyle(
                  color: fg, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("You're all caught up!",
              style: TextStyle(color: muted, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Color primary, fg, muted;
  final VoidCallback onRetry;

  const _ErrorView(
      {required this.message,
      required this.primary,
      required this.fg,
      required this.muted,
      required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text('Something went wrong',
              style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message,
              style: TextStyle(color: muted, fontSize: 12),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
