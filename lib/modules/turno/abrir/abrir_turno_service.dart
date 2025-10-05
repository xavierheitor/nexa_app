import 'package:get/get.dart';
import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/core/domain/dto/equipe_table_dto.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';

class AbrirTurnoService extends GetxService {
  final veiculoRepo = Get.find<VeiculoRepo>();
  final eletricistaRepo = Get.find<EletricistaRepo>();
  final equipeRepo = Get.find<EquipeRepo>();

  Future<List<VeiculoTableDto>> buscarVeiculos() async {
    final veiculos = await veiculoRepo.listar();
    return veiculos;
  }

  Future<List<EletricistaTableDto>> buscarEletricistas() async {
    final eletricistas = await eletricistaRepo.listar();
    return eletricistas;
  }

  Future<List<EquipeTableDto>> buscarEquipes() async {
    final equipes = await equipeRepo.listar();
    return equipes;
  }
}
