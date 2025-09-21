# Arquitetura de DTOs

Esta arquitetura fornece uma base robusta e reutilizável para todos os DTOs do projeto, com tratamento de erros, validações e integração com Drift.

## Estrutura da Arquitetura

### 1. `BaseDto` - Classe Base

- **Localização**: `base_dto.dart`
- **Funcionalidades**:
  - Métodos estáticos para validação e conversão
  - Tratamento de erros padronizado
  - Suporte a múltiplos formatos de dados
  - Fallbacks para diferentes chaves JSON

### 2. `BaseTableDto` - DTOs de Tabela

- **Localização**: `base_table_dto.dart`
- **Funcionalidades**:
  - Extends `BaseDto`
  - Campos comuns: `id`, `createdAt`
  - Validações automáticas de datas
  - Métodos para integração com Drift

### 3. Mixins Especializados

- **`TableValidationMixin`**: Validações específicas de tabelas
- **`DriftDtoMixin`**: Integração com Drift

## Como Implementar um Novo DTO

### Passo 1: Criar a Classe

```dart
class MeuDto extends BaseTableDto {
  final String campo1;
  final int? campo2;
  final DateTime? campo3;

  MeuDto({
    required super.id,
    required this.campo1,
    this.campo2,
    this.campo3,
    required super.createdAt,
  });
}
```

### Passo 2: Implementar `fromJson`

```dart
factory MeuDto.fromJson(Map<String, dynamic> json) {
  return BaseTableDto.fromJson(json, (json) {
    return MeuDto(
      id: BaseDto.validateRequiredString(json['id'], 'id'),
      campo1: BaseDto.validateRequiredString(json['campo1'], 'campo1'),
      campo2: BaseDto.parseOptionalInt(json['campo2'], 'campo2'),
      campo3: BaseDto.parseOptionalDateTime(
        BaseDto.getValueWithFallback(json, ['campo3', 'field3']),
        'campo3'
      ),
      createdAt: BaseDto.parseRequiredDateTime(
        BaseDto.getValueWithFallback(json, ['createdAt', 'created_at']) ?? DateTime.now(),
        'createdAt'
      ),
    );
  });
}
```

### Passo 3: Implementar `toSpecificJson`

```dart
@override
Map<String, dynamic> toSpecificJson() {
  return {
    'campo1': campo1,
    'campo2': campo2,
    'campo3': campo3?.toIso8601String(),
  };
}
```

### Passo 4: Implementar `validateSpecific`

```dart
@override
void validateSpecific() {
  validateNome(campo1); // Usando validação do mixin
  // ou validações customizadas:
  if (campo2 != null && campo2! < 0) {
    throw DtoError('Campo2 não pode ser negativo', field: 'campo2', value: campo2);
  }
}
```

### Passo 5: Métodos do Drift (se necessário)

```dart
MeuDtoCompanion toCompanion() {
  return MeuDtoCompanion(
    campo1: createValue(campo1),
    campo2: createValue(campo2),
    campo3: createValue(campo3),
  );
}

MeuDtoData toEntity() {
  return MeuDtoData(
    id: int.parse(id),
    campo1: campo1,
    campo2: campo2,
    campo3: campo3,
    createdAt: createdAt,
  );
}

factory MeuDto.fromEntity(MeuDtoData entity) {
  return MeuDto(
    id: entity.id.toString(),
    campo1: entity.campo1,
    campo2: entity.campo2,
    campo3: entity.campo3,
    createdAt: entity.createdAt,
  );
}
```

## Métodos Disponíveis

### Validação e Conversão

- `BaseDto.validateRequiredString(value, fieldName)` - String obrigatória
- `BaseDto.parseOptionalDateTime(value, fieldName)` - Data opcional
- `BaseDto.parseRequiredDateTime(value, fieldName)` - Data obrigatória
- `BaseDto.parseOptionalInt(value, fieldName)` - Int opcional
- `BaseDto.parseRequiredInt(value, fieldName)` - Int obrigatório
- `BaseDto.parseOptionalBool(value, fieldName)` - Bool opcional
- `BaseDto.parseRequiredBool(value, fieldName)` - Bool obrigatório

### Fallbacks JSON

- `BaseDto.getStringWithFallback(json, ['key1', 'key2'])` - String com fallback
- `BaseDto.getValueWithFallback(json, ['key1', 'key2'])` - Valor com fallback

### Validações de Tabela

- `validateRequiredId(id)` - ID obrigatório
- `validateTableString(value, fieldName, minLength, maxLength)` - String de tabela
- `validateMatricula(matricula)` - Matrícula
- `validateNome(nome)` - Nome
- `validateToken(token)` - Token
- `validateRemoteId(remoteId)` - Remote ID

## Tratamento de Erros

A arquitetura fornece erros específicos e informativos:

```dart
try {
  final dto = MeuDto.fromJson(json);
} on RequiredFieldError catch (e) {
  print('Campo obrigatório: ${e.field}');
} on InvalidDateFormatError catch (e) {
  print('Data inválida: ${e.field}');
} on DtoError catch (e) {
  print('Erro no DTO: ${e.message}');
}
```

## Vantagens

1. **Reutilização**: Código comum compartilhado entre todos os DTOs
2. **Consistência**: Padrões uniformes de validação e erro
3. **Manutenibilidade**: Mudanças na base afetam todos os DTOs
4. **Robustez**: Tratamento de erros detalhado e informativo
5. **Flexibilidade**: Suporte a múltiplos formatos JSON
6. **Simplicidade**: Implementação de novos DTOs muito mais simples

## Exemplo Completo

Veja `example_product_dto.dart` para um exemplo completo de implementação.
