class Sms {
  int id;
  String number;
  String message;
  String feedback = '';
  String time='';

  Sms(int id , String number, String message) {
    this.id = id;
    this.number = number;
    this.message = message;
  }


  @override
  String toString() {
    return 'Sms{id: $id, number: $number, message: $message, feedback: $feedback, time: $time}';
  }

  Future<void> addFeedback(String feedback) async {
    this.feedback = feedback;
  }

  void addTime(String time) {
    this.time = time;
  }

  Sms.fromMap(Map<String, dynamic> res)
      : number = res["number"],
        message = res["message"],
        feedback = res["feedback"],
        time = res["time"];

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['number'] = number;
    map['message'] = message;
    map['feedback'] = feedback;
    map['time'] = time;
    return map;
  }
}

