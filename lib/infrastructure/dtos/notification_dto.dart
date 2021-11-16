import 'dart:core';

class BaseNotificationDto {
  final String typeNotification;
  final NotificationPayloadDto payload;

  BaseNotificationDto({required this.typeNotification, required this.payload});

  factory BaseNotificationDto.fromJson(Map<String, dynamic> json) {
    String typeNotification = json['type_notification'] as String;
    return BaseNotificationDto(typeNotification: typeNotification, payload: NotificationPayloadEmptyDto());
  }
}

abstract class NotificationPayloadDto {
  NotificationPayloadDto();
}

class NotificationPayloadEmptyDto extends NotificationPayloadDto {
  NotificationPayloadEmptyDto();
}
