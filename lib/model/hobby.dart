import '../rest/hobby_service/dto/hobbie_dto.dart';

class Hobby {
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

  Hobby(
      this.id,
      this.name,
      this.physicalActivityLevel,
      this.creativityLevel,
      this.complexityLevel,
      this.entryStartLevel,
      this.ageRange,
      this.timeCommitment,
      this.numberOfPeople,
      this.remoteOnSite,
      this.competitiveness,
      this.budget,
      this.seasonality,
      this.riskOfInjury,
      this.acceptableDisabilityLevel,
      this.popularity,
      this.phobias,
      this.relaxationLevel,
      this.stressLevel,
      this.skillDevelopment,
      this.regularity,
      this.flexibility,
      this.earningPotential,
      this.emotionalEngagement,
      this.mentalHealthImpact,
      this.isForDisabilityPerson,
      this.summary,
      this.image
      );

  factory Hobby.fromDTO(HobbyDTO dto) {
    return Hobby(
      dto.id,
      dto.name,
      dto.physicalActivityLevel,
      dto.creativityLevel,
      dto.complexityLevel,
      dto.entryStartLevel,
      dto.ageRange,
      dto.timeCommitment,
      dto.numberOfPeople,
      dto.remoteOnSite,
      dto.competitiveness,
      dto.budget,
      dto.seasonality,
      dto.riskOfInjury,
      dto.acceptableDisabilityLevel,
      dto.popularity,
      dto.phobias,
      dto.relaxationLevel,
      dto.stressLevel,
      dto.skillDevelopment,
      dto.regularity,
      dto.flexibility,
      dto.earningPotential,
      dto.emotionalEngagement,
      dto.mentalHealthImpact,
      dto.isForDisabilityPerson,
      dto.summary,
      dto.image
    );
  }
}
