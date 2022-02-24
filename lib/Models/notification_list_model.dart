class NotificationListModel {
  NotificationListModel({
    required this.message,
    required this.status,
    required this.data,
  });
  late final String message;
  late final int status;
  late final List<NotificationModel> data;

  NotificationListModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    status = json['status'];
    data = List.from(json['data']).map((e)=>NotificationModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.userId,
    required this.notificationType,
    required this.notificationTitle,
    required this.description,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int userId;
  late final int notificationType;
  late final String notificationTitle;
  late final String description;
  late final int isRead;
  late final String createdAt;
  late final String updatedAt;

  NotificationModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    notificationType = json['notification_type'];
    notificationTitle = json['notification_title'];
    description = json['description'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['notification_type'] = notificationType;
    _data['notification_title'] = notificationTitle;
    _data['description'] = description;
    _data['is_read'] = isRead;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}