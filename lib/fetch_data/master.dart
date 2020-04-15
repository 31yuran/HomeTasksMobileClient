class Master{
  int id;
  String name;

  Master._({this.id, this.name});
  Master.init({this.id, this.name});
  
  factory Master.fromJson(Map<String, dynamic> json){
    return new Master._(
      id :json['id'],
      name : json['name']
    );
  }
  Map<String, dynamic> toJsonForPost(){
    return {
      'name':this.name
    };
  }
  Map<String, dynamic> toJsonForPut(){
    return {
      'id': this.id,
      'name' : this.name
    };
  }
}