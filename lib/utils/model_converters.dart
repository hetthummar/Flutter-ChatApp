import 'package:moor_flutter/moor_flutter.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/models/chat_models/private_message_model.dart';
import 'package:socketchat/models/chat_models/update_message_model.dart';

class ModelConverters {
  MessagesTableCompanion convertMongoModelToLocalModel(
      PrivateMessageModel _privateMessageModel) {
    return MessagesTableCompanion(
      mongoId: Value(_privateMessageModel.id!),
      msgContentType: Value(_privateMessageModel.msgContentType),
      msgContent: Value(_privateMessageModel.msgContent),
      msgStatus: Value(_privateMessageModel.msgStatus),
      senderId: Value(_privateMessageModel.senderId),
      receiverId: Value(_privateMessageModel.receiverId),
        createdAt: Value(_privateMessageModel.createdAt),
      networkFileUrl: Value(_privateMessageModel.networkFileUrl),
      imageInfo: Value(_privateMessageModel.imageInfo),
      blurHashImageUrl:  Value(_privateMessageModel.blurHashImage),
      // receiverName:Value(_privateMessageModel.re)
    );
  }

  MessagesTableCompanion convertUpdateModelToLocalModel(
      UpdateMessageModel _updateMessageModel) {
    return MessagesTableCompanion(
    );
  }

}
