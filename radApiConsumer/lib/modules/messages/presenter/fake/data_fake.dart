import '/modules/messages/infra/models/message_conversation_model.dart';

class DataFake {
  List<MessageConversationModel> conversation;
  DataFake({
    required this.conversation,
  }) {
    this.conversation = [];
  }

  loadData() {
    add(0, 'Oi, tudo bem?');
    add(1, 'Oi, tudo e com você?');
    add(0, 'Certo, estou aqui esperando para fazer a entrevista para Globo');
    add(1, 'ah, que legal. me liga para dizer como foi e boa sorte');
    add(1,
        'hannibal disse em um texto: Que coleção de cicatrizes você tem? Nunca se esqueça de quem lhe deu as melhores. E seja grato. Nossas cicatrizes têm o poder de nos fazer lembrar que o passado foi real.');
    add(0, 'ta, pode deixar');
    add(0, 'eu te ligo assim que concluir a entrevista lá');
    add(0, 'obrigado');
    add(0, 'até mais');
  }

  getData() {
    return this.conversation;
  }

  add(int staffId, String message) {
    this.conversation.add(MessageConversationModel(
        cid: 0123456, memberId: staffId, message: message));
  }
}
