/* 

Model for relation of tables
Name used into database: 

Example: activities, clients, staff ... etc.;

*/

const kRelProjects = 'project';
const kRelActivities = 'activity';
const kRelNone = '';

class RelationModel {
  String relType;
  int relId;

  RelationModel({required this.relId, required this.relType});

  String getLabel() {
    switch (this.relType) {
      case kRelActivities:
        return 'Atividades';
      case kRelProjects:
        return 'Projetos';
      case kRelNone:
        return 'Nenhuma';
      default:
        return 'Indefinida';
    }
  }
}
