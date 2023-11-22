import 'package:objectbox/objectbox.dart';

@Entity()
class Categoria {
  @Id()
  int? id;
  String? createdAt;
  String? updatedAt;
  String? nome;

  Categoria({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.nome,
  });
}
