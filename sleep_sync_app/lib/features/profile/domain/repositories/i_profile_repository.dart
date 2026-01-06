abstract class IProfileRepository {
  Future<void> updateName(String newName);
  Future<void> updatePhoto(String url);
}