class TokenRefreshDTO{
  String refresh;

  TokenRefreshDTO(this.refresh);

  @override
  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
    };
  }

}