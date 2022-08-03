class EndPoints {

  static const String addUser = "/users";
  static const String searchUser = "/users/search";
  static const String getSingleUser = "/users";
  static const String updateUserToken = "/users/userUpdateToken";
  static const String getBackupDetails = "/users/getBackupDetails";
  static const String getUserBackupData = "/users/userBackUpData";

  static const String updateUser = "/userUpdate";

  static const String sendMessage = "/messages";
  static const String updateMessageSeenAt = "/messages/updateMsgSeenTime";
  static const String updateMessageDeliverTime = "/messages/updateMsgDeliverTime";
  static const String getMissedMessage = "/messages/getMissedMessage";
  static const String msgUpdatedLocallyForSender = "/messages/updateSenderLocalMsgStatus";
  static const String recentChatUpdate = "/messages/recentChatUpdate";

  static const String userConnectionStatus = "/connectionStatus/userConnectionStatus";
}

//
// }[{$match: {
// participants: {
// $in: [
// 'MrJqaUWBEzf0pwo1JQkvXTgMEdh2'
// ]
// }
// }}, {$addFields: {
// matchedIndex: {
// $indexOfArray: [
// '$participants',
// 'MrJqaUWBEzf0pwo1JQkvXTgMEdh2'
// ]
// }
// }}, {$set: {
// "user1_name": {
// "$cond":{
// if:
// {
// $and: [
// { $eq: [ "$matchedIndex", 0 ]},
// { $ne: [ "hetNickk", null ]}
// ]
// },
// then: "hetNickk",
// else: "$user1_name"
// }
// },
// "user1_compressed_image": {
// "$cond":{
// if:
// {
// $and: [
// { $eq: [ "$matchedIndex", 0 ]},
// { $ne: [ "hetNickk", null ]}
// ]
// },
// then: "hetNickk",
// else: "$user1_compressed_image"
// }
// },
// "user2_name": {
// "$cond":{
// if:
// {
// $and: [
// { $eq: [ "$matchedIndex", 0 ]},
// { $ne: [ "hetNickk", null ]}
// ]
// },
// then: "hetNickk",
// else: "$user2_name"
// }
// },
// "user2_compressed_image": {
// "$cond":{
// if:
// {
// $and: [
// { $eq: [ "$matchedIndex", 0 ]},
// { $ne: [ "hetNickk", null ]}
// ]
// },
// then: "hetNickk",
// else: "$user2_compressed_image"
// }
// },
//
// }}]