class Message {

  int messageId;
  String senderAccount;
  String targetAccount;
  DateTime timestamp;
  String message;
  int readTimes;

  Message(this.messageId, this.senderAccount, this.targetAccount,
      this.timestamp, this.message, this.readTimes);

  Message.fromJson(Map<String, dynamic> jsonMap) {
    this.messageId = jsonMap['messageId'];
    this.senderAccount = jsonMap['senderAccount'];
    this.targetAccount = jsonMap['targetAccount'];
    this.timestamp = jsonMap['timestamp'];
    this.message = jsonMap['message'];
    this.readTimes = jsonMap['readTimes'];
  }

  @override
  String toString() {
    return 'Message{messageId: $messageId, senderAccount: $senderAccount, targetAccount: $targetAccount, timestamp: $timestamp, message: $message, readTimes: $readTimes}';
  }
}