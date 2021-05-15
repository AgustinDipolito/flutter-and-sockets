class Band {
  String id;
  String name;
  int votes;

  Band({
    this.name,
    this.id,
    this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj) =>
      Band(id: obj["id"], name: obj["name"], votes: obj["votes"]);
}
