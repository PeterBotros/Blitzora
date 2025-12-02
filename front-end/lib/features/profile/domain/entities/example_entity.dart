import 'package:equatable/equatable.dart';

/// Domain entity - pure business logic object
class ExampleEntity extends Equatable {
  final int id;
  final String title;
  final String description;

  const ExampleEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [id, title, description];
}


