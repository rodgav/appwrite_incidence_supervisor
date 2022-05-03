class UserSel {
  String area, typeUser;
  bool? active;

  UserSel({String? area, String? typeUser, this.active})
      : area = area ?? '',
        typeUser = typeUser ?? '';
}
