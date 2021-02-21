class ChatTargetUnit {

  String targetAccount;
  String targetUsername;
  String targetHeadImage;
  String lastMessage;
  String timestamp;

  ChatTargetUnit(this.targetAccount, this.targetUsername, this.targetHeadImage,
      this.lastMessage, this.timestamp);

  @override
  String toString() {
    return 'ChatTargetUnit{targetAccount: $targetAccount, targetUsername: $targetUsername, targetHeadImage: $targetHeadImage, lastMessage: $lastMessage, timestamp: $timestamp}';
  }
}