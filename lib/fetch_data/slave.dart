class Slave{
  int id;
  String name;

  Slave._({this.id, this.name});
  Slave.init({this.id, this.name});
  
  factory Slave.fromJson(Map<String, dynamic> json){
    return new Slave._(
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