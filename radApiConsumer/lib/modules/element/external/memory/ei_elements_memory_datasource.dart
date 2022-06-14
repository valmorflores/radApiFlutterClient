import '/global/resources/kconstants.dart';
import '/global/resources/koptions_menu.dart';
import '/modules/element/domain/entities/element_types.dart';
import '/modules/element/infra/datasources/element_datasource.dart';
import '/modules/element/infra/models/element_model.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/routes.dart';
import '/utils/globals.dart';

class EIElementsMemoryDatasource implements ElementDatasource {
  EIElementsMemoryDatasource();

  @override
  Future<List<ElementModel>> searchText(String textSearch) async {
    var list = await getAll();
    return list;
  }

  @override
  Future<List<ElementModel>> getById(int id) async {
    var list = await getAll();
    List<ElementModel> res = [];
    list.forEach((element) {
      if (element.index == id) {
        res[0] = element;
      }
    });
    return res;
  }

  @override
  Future<List<ElementModel>> getByType(ElementType type) async {
    var list = await getAll();
    List<ElementModel> res = [];
    list.forEach((element) {
      if (element.type == type) {
        res.add(element);
      }
    });
    return res;
  }

  @override
  Future<List<ElementModel>> getAll() async {
    List<ElementModel> res = [];
    int i = 0;
    res.add(ElementModel(
        index: i, // FIRST IS 0
        id: kActivities,
        name: 'Atividades',
        subtitle: 'Relação de atividades',
        type: ElementType.menu_item,
        route: Routes.activities,
        visible: true,
        order: i));
    res.add(ElementModel(
        index: ++i, // +1
        id: kTodos,
        name: 'Anotações',
        subtitle: 'Anotações de tarefas pessoais',
        type: ElementType.menu_item,
        route: Routes.todo,
        selected: false,
        visible: true,
        order: i));
    res.add(ElementModel(
        index: ++i,
        id: kTasks,
        name: 'Tarefas',
        subtitle: 'Relação de tarefas',
        type: ElementType.menu_item,
        route: Routes.tasks,
        visible: true,
        selected: false,
        order: i));
    res.add(ElementModel(
        index: ++i,
        id: kProjects,
        name: 'Projetos',
        subtitle: 'Relação de projetos',
        type: ElementType.menu_item,
        visible: true,
        route: null,
        order: i));
    res.add(ElementModel(
        index: ++i,
        id: kTickets,
        name: 'Tíquetes',
        subtitle: 'Relação de tíquetes de suporte',
        type: ElementType.menu_item,
        visible: true,
        route: null,
        order: i));
    res.add(ElementModel(
        index: ++i,
        id: kContracts,
        name: 'Contratos',
        subtitle: 'Relação de contratos',
        type: ElementType.menu_item,
        visible: true,
        route: null,
        order: i));
    res.add(ElementModel(
        index: ++i,
        id: kKnowledgeBase,
        name: 'Base de conhecimento',
        subtitle: 'Biblioteca institucional',
        type: ElementType.menu_item,
        route: Routes.articles,
        visible: true,
        order: i));
    res.add(ElementModel(
        index: ++i,
        id: kCoursesMgr,
        name: 'Cursos',
        subtitle: 'Relação de cursos disponíveis',
        type: ElementType.menu_item,
        route: Routes.courses,
        visible: true,
        order: i));
    res.add(ElementModel(
        index: ++i,
        name: 'Perfil',
        id: kProfile,
        subtitle: 'Dados de usuário',
        type: ElementType.menu_item,
        route: Routes.profile,
        visible: true,
        order: i));
    res.add(ElementModel(
        index: ++i,
        id: kAbout,
        name: 'Sobre',
        subtitle: 'Sobre o sistema',
        type: ElementType.menu_item,
        route: Routes.about,
        visible: true,
        order: i));

    return res;
  }

  @override
  Future<List<ElementModel>> getStart() async {
    List<ElementModel> res = [];
    int i = 0;
    bool assign;
    if (setup_app_device == null) {
      assign = false;
    } else if (setup_app_device!.alias == '') {
      assign = false;
    } else {
      if (setup_app_device!.alias == null) {
        assign = false;
      } else {
        assign = setup_app_device!.alias.contains('@');
      }
    }
    res.add(ElementModel(
        index: ++i,
        name: 'Primeiro passo: Criar ou vincular uma conta',
        subtitle:
            'Esta é a primeira vez que uso este aplicativo neste dispositivo',
        type: ElementType.menu_item,
        route: !(assign) ? Routes.setup_main : null,
        refreshApp: true,
        wait: true,
        checked: assign,
        order: i));
    res.add(ElementModel(
        index: ++i,
        name: 'Segundo passo: Criar meu ambiente (workspace)',
        subtitle: 'Você pode criar seu próprio ambiente de trabalho',
        type: ElementType.menu_item,
        route: !(assign) ? null : Routes.setup_workspace,
        refreshApp: true,
        wait: true,
        order: i));
    res.add(ElementModel(
        index: ++i,
        name: 'Instalar um workspace com código',
        subtitle:
            'Usar caso faça parte de uma instituição e tenha um código para dispositivo',
        refreshApp: true,
        wait: true,
        type: ElementType.menu_item,
        route: Routes.install,
        order: i));
    res.add(ElementModel(
        index: ++i,
        name: 'Perfil',
        subtitle: 'Dados de usuário',
        type: ElementType.menu_item,
        route: Routes.profile,
        order: i));
    res.add(ElementModel(
        index: ++i,
        name: 'Sobre',
        subtitle: 'Sobre o sistema',
        type: ElementType.menu_item,
        route: Routes.about,
        order: i));
    return res;
  }

  @override
  Future<List<ElementModel>> getByIndex(int id) async {
    if (id == kMenuGetAllNow || id == kMenuGetMenuDefaultOptions) {
      return (await getAll());
    } else if (id == kMenuGetInstallOptions) {
      return (await getStart());
    } else {
      if (isInstalled) {
        return (await getAll());
      } else {
        return (await getStart());
      }
    }
  }
}
