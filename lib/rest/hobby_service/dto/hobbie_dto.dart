class HobbyDTO {
  int id;
  String name;
  int physicalActivityLevel;
  int creativityLevel;
  int complexityLevel;
  int entryStartLevel;
  int ageRange;
  int timeCommitment;
  int numberOfPeople;
  int remoteOnSite;
  int competitiveness;
  int budget;
  int seasonality;
  int riskOfInjury;
  int acceptableDisabilityLevel;
  int popularity;
  int phobias;
  int relaxationLevel;
  int stressLevel;
  int skillDevelopment;
  int regularity;
  int flexibility;
  int earningPotential;
  int emotionalEngagement;
  int mentalHealthImpact;
  bool isForDisabilityPerson;
  String summary;
  String? image;

  HobbyDTO({
    required this.id,
    required this.name,
    required this.physicalActivityLevel,
    required this.creativityLevel,
    required this.complexityLevel,
    required this.entryStartLevel,
    required this.ageRange,
    required this.timeCommitment,
    required this.numberOfPeople,
    required this.remoteOnSite,
    required this.competitiveness,
    required this.budget,
    required this.seasonality,
    required this.riskOfInjury,
    required this.acceptableDisabilityLevel,
    required this.popularity,
    required this.phobias,
    required this.relaxationLevel,
    required this.stressLevel,
    required this.skillDevelopment,
    required this.regularity,
    required this.flexibility,
    required this.earningPotential,
    required this.emotionalEngagement,
    required this.mentalHealthImpact,
    required this.isForDisabilityPerson,
    required this.summary,
    required this.image
  });

  factory HobbyDTO.fromJson(Map<String, dynamic> json) {
    return HobbyDTO(
      id: json['id'],
      name: json['name'],
      physicalActivityLevel: json['physicalActivityLevel'],
      creativityLevel: json['creativityLevel'],
      complexityLevel: json['complexityLevel'],
      entryStartLevel: json['entryStartLevel'],
      ageRange: json['ageRange'],
      timeCommitment: json['timeCommitment'],
      numberOfPeople: json['numberOfPeople'],
      remoteOnSite: json['remoteOnSite'],
      competitiveness: json['competitiveness'],
      budget: json['budget'],
      seasonality: json['seasonality'],
      riskOfInjury: json['riskOfInjury'],
      acceptableDisabilityLevel: json['acceptableDisabilityLevel'],
      popularity: json['popularity'],
      phobias: json['phobias'],
      relaxationLevel: json['relaxationLevel'],
      stressLevel: json['stressLevel'],
      skillDevelopment: json['skillDevelopment'],
      regularity: json['regularity'],
      flexibility: json['flexibility'],
      earningPotential: json['earningPotential'],
      emotionalEngagement: json['emotionalEngagement'],
      mentalHealthImpact: json['mentalHealthImpact'],
      isForDisabilityPerson: json['isForDisabilityPerson'],
      summary: json['summary'],
      image: json["image"]
    );
  }
}
