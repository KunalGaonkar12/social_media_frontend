class Post {
   String? id;
  late String userId;
  late String imageUrl;
  late String caption;
  late String userName;
  DateTime? date;
 late bool enableMore;

  Post(
      { this.id,
      required this.userId,
      required this.imageUrl,
      required this.caption,
        this.enableMore=false,
       this.date,required this.userName});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    imageUrl = json['image'];
    caption = json['caption'];
    enableMore=false;
    userName=json['userName']??"";
    date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['date']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['imageUrl'] = this.imageUrl;
    data['caption'] = this.caption;
    data['date'] = this.date;
    return data;
  }
}
