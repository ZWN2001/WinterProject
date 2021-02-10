class UserInfo{
  String account='';
  String headImage='';
  int age=0;
  String location='';
  String introduction='';
  int sex=0;
  String name='';

  UserInfo(this.account,this.headImage,this.age,this.location,this.introduction,this.sex,this.name);
  UserInfo.fromJson(Map<String, dynamic> jsonMap) {
  this.account=jsonMap['account'];
  this.headImage=jsonMap['headImage'];
  this.age=jsonMap['age'];
  this.location=jsonMap['location'];
  this.introduction=jsonMap['introduction'];
  this.sex=jsonMap['sex'];
  this.name=jsonMap['name'];
  }

  @override
  String toString() {
    return 'account: $account,headImage:$headImage,age:$age,location$location,introduction:$introduction,sex:$sex,name:$name';
  }
}