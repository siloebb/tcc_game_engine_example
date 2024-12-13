
abstract class GameObject {
  String get id;
}

mixin GameObjectViewModel<T extends GameObject> {
  late T _object;

  T get object => _object;

  bind(T object){
    this._object = object;
  }

  String get id => _object.id;

}