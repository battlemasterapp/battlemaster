import 'data_service.dart';

abstract class Pf2eDataService<T> extends DataService<T> {
  Pf2eDataService({required super.initialData})
      : super(
          baseUrl:
              'https://raw.githubusercontent.com/VytorCalixto/pf2e-fvtt-bestiary/refs/heads/main',
        );
}
