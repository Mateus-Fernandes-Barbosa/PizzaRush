enum DefaultUsers {
  // Store locally without verification, but cant transfer to cloud
  visitor(0, 'visitor@gmail.com', 'visitor user');

  final int id;
  final String email;
  final String previewName;
  const DefaultUsers(this.id, this.email, this.previewName);
}
