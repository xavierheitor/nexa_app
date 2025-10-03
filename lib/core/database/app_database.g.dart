// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsuarioTableTable extends UsuarioTable
    with TableInfo<$UsuarioTableTable, UsuarioTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuarioTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _matriculaMeta =
      const VerificationMeta('matricula');
  @override
  late final GeneratedColumn<String> matricula = GeneratedColumn<String>(
      'matricula', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
      'refresh_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ultimoLoginMeta =
      const VerificationMeta('ultimoLogin');
  @override
  late final GeneratedColumn<DateTime> ultimoLogin = GeneratedColumn<DateTime>(
      'ultimo_login', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        nome,
        matricula,
        token,
        refreshToken,
        ultimoLogin,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuario_table';
  @override
  VerificationContext validateIntegrity(Insertable<UsuarioTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('matricula')) {
      context.handle(_matriculaMeta,
          matricula.isAcceptableOrUnknown(data['matricula']!, _matriculaMeta));
    } else if (isInserting) {
      context.missing(_matriculaMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableOrUnknown(
              data['refresh_token']!, _refreshTokenMeta));
    }
    if (data.containsKey('ultimo_login')) {
      context.handle(
          _ultimoLoginMeta,
          ultimoLogin.isAcceptableOrUnknown(
              data['ultimo_login']!, _ultimoLoginMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsuarioTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsuarioTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      matricula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}matricula'])!,
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token']),
      refreshToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}refresh_token']),
      ultimoLogin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ultimo_login']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsuarioTableTable createAlias(String alias) {
    return $UsuarioTableTable(attachedDatabase, alias);
  }
}

class UsuarioTableData extends DataClass
    implements Insertable<UsuarioTableData> {
  final int id;
  final String remoteId;
  final String nome;
  final String matricula;
  final String? token;
  final String? refreshToken;
  final DateTime? ultimoLogin;
  final DateTime createdAt;
  const UsuarioTableData(
      {required this.id,
      required this.remoteId,
      required this.nome,
      required this.matricula,
      this.token,
      this.refreshToken,
      this.ultimoLogin,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['nome'] = Variable<String>(nome);
    map['matricula'] = Variable<String>(matricula);
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    if (!nullToAbsent || ultimoLogin != null) {
      map['ultimo_login'] = Variable<DateTime>(ultimoLogin);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsuarioTableCompanion toCompanion(bool nullToAbsent) {
    return UsuarioTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      nome: Value(nome),
      matricula: Value(matricula),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
      ultimoLogin: ultimoLogin == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimoLogin),
      createdAt: Value(createdAt),
    );
  }

  factory UsuarioTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsuarioTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      nome: serializer.fromJson<String>(json['nome']),
      matricula: serializer.fromJson<String>(json['matricula']),
      token: serializer.fromJson<String?>(json['token']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      ultimoLogin: serializer.fromJson<DateTime?>(json['ultimoLogin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'nome': serializer.toJson<String>(nome),
      'matricula': serializer.toJson<String>(matricula),
      'token': serializer.toJson<String?>(token),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'ultimoLogin': serializer.toJson<DateTime?>(ultimoLogin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UsuarioTableData copyWith(
          {int? id,
          String? remoteId,
          String? nome,
          String? matricula,
          Value<String?> token = const Value.absent(),
          Value<String?> refreshToken = const Value.absent(),
          Value<DateTime?> ultimoLogin = const Value.absent(),
          DateTime? createdAt}) =>
      UsuarioTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        nome: nome ?? this.nome,
        matricula: matricula ?? this.matricula,
        token: token.present ? token.value : this.token,
        refreshToken:
            refreshToken.present ? refreshToken.value : this.refreshToken,
        ultimoLogin: ultimoLogin.present ? ultimoLogin.value : this.ultimoLogin,
        createdAt: createdAt ?? this.createdAt,
      );
  UsuarioTableData copyWithCompanion(UsuarioTableCompanion data) {
    return UsuarioTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      nome: data.nome.present ? data.nome.value : this.nome,
      matricula: data.matricula.present ? data.matricula.value : this.matricula,
      token: data.token.present ? data.token.value : this.token,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      ultimoLogin:
          data.ultimoLogin.present ? data.ultimoLogin.value : this.ultimoLogin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('nome: $nome, ')
          ..write('matricula: $matricula, ')
          ..write('token: $token, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('ultimoLogin: $ultimoLogin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, nome, matricula, token,
      refreshToken, ultimoLogin, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsuarioTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.nome == this.nome &&
          other.matricula == this.matricula &&
          other.token == this.token &&
          other.refreshToken == this.refreshToken &&
          other.ultimoLogin == this.ultimoLogin &&
          other.createdAt == this.createdAt);
}

class UsuarioTableCompanion extends UpdateCompanion<UsuarioTableData> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> nome;
  final Value<String> matricula;
  final Value<String?> token;
  final Value<String?> refreshToken;
  final Value<DateTime?> ultimoLogin;
  final Value<DateTime> createdAt;
  const UsuarioTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.nome = const Value.absent(),
    this.matricula = const Value.absent(),
    this.token = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.ultimoLogin = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsuarioTableCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String nome,
    required String matricula,
    this.token = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.ultimoLogin = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : remoteId = Value(remoteId),
        nome = Value(nome),
        matricula = Value(matricula);
  static Insertable<UsuarioTableData> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? nome,
    Expression<String>? matricula,
    Expression<String>? token,
    Expression<String>? refreshToken,
    Expression<DateTime>? ultimoLogin,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (nome != null) 'nome': nome,
      if (matricula != null) 'matricula': matricula,
      if (token != null) 'token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (ultimoLogin != null) 'ultimo_login': ultimoLogin,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsuarioTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? remoteId,
      Value<String>? nome,
      Value<String>? matricula,
      Value<String?>? token,
      Value<String?>? refreshToken,
      Value<DateTime?>? ultimoLogin,
      Value<DateTime>? createdAt}) {
    return UsuarioTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      matricula: matricula ?? this.matricula,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      ultimoLogin: ultimoLogin ?? this.ultimoLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (matricula.present) {
      map['matricula'] = Variable<String>(matricula.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (ultimoLogin.present) {
      map['ultimo_login'] = Variable<DateTime>(ultimoLogin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('nome: $nome, ')
          ..write('matricula: $matricula, ')
          ..write('token: $token, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('ultimoLogin: $ultimoLogin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TipoVeiculoTableTable extends TipoVeiculoTable
    with TableInfo<$TipoVeiculoTableTable, TipoVeiculoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TipoVeiculoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descricaoMeta =
      const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, remoteId, nome, descricao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipo_veiculo_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TipoVeiculoTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TipoVeiculoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TipoVeiculoTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      descricao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descricao']),
    );
  }

  @override
  $TipoVeiculoTableTable createAlias(String alias) {
    return $TipoVeiculoTableTable(attachedDatabase, alias);
  }
}

class TipoVeiculoTableData extends DataClass
    implements Insertable<TipoVeiculoTableData> {
  final int id;
  final String remoteId;
  final String nome;
  final String? descricao;
  const TipoVeiculoTableData(
      {required this.id,
      required this.remoteId,
      required this.nome,
      this.descricao});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    return map;
  }

  TipoVeiculoTableCompanion toCompanion(bool nullToAbsent) {
    return TipoVeiculoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      nome: Value(nome),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
    );
  }

  factory TipoVeiculoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TipoVeiculoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String?>(json['descricao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String?>(descricao),
    };
  }

  TipoVeiculoTableData copyWith(
          {int? id,
          String? remoteId,
          String? nome,
          Value<String?> descricao = const Value.absent()}) =>
      TipoVeiculoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        nome: nome ?? this.nome,
        descricao: descricao.present ? descricao.value : this.descricao,
      );
  TipoVeiculoTableData copyWithCompanion(TipoVeiculoTableCompanion data) {
    return TipoVeiculoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TipoVeiculoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, nome, descricao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TipoVeiculoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.nome == this.nome &&
          other.descricao == this.descricao);
}

class TipoVeiculoTableCompanion extends UpdateCompanion<TipoVeiculoTableData> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> nome;
  final Value<String?> descricao;
  const TipoVeiculoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
  });
  TipoVeiculoTableCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String nome,
    this.descricao = const Value.absent(),
  })  : remoteId = Value(remoteId),
        nome = Value(nome);
  static Insertable<TipoVeiculoTableData> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? nome,
    Expression<String>? descricao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
    });
  }

  TipoVeiculoTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? remoteId,
      Value<String>? nome,
      Value<String?>? descricao}) {
    return TipoVeiculoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TipoVeiculoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }
}

class $VeiculoTableTable extends VeiculoTable
    with TableInfo<$VeiculoTableTable, VeiculoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VeiculoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _placaMeta = const VerificationMeta('placa');
  @override
  late final GeneratedColumn<String> placa = GeneratedColumn<String>(
      'placa', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 7, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
      'modelo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _anoMeta = const VerificationMeta('ano');
  @override
  late final GeneratedColumn<int> ano = GeneratedColumn<int>(
      'ano', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tipoVeiculoIdMeta =
      const VerificationMeta('tipoVeiculoId');
  @override
  late final GeneratedColumn<int> tipoVeiculoId = GeneratedColumn<int>(
      'tipo_veiculo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  @override
  late final GeneratedColumn<String> deletedBy = GeneratedColumn<String>(
      'deleted_by', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        placa,
        modelo,
        ano,
        tipoVeiculoId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'veiculo_table';
  @override
  VerificationContext validateIntegrity(Insertable<VeiculoTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('placa')) {
      context.handle(
          _placaMeta, placa.isAcceptableOrUnknown(data['placa']!, _placaMeta));
    } else if (isInserting) {
      context.missing(_placaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('ano')) {
      context.handle(
          _anoMeta, ano.isAcceptableOrUnknown(data['ano']!, _anoMeta));
    } else if (isInserting) {
      context.missing(_anoMeta);
    }
    if (data.containsKey('tipo_veiculo_id')) {
      context.handle(
          _tipoVeiculoIdMeta,
          tipoVeiculoId.isAcceptableOrUnknown(
              data['tipo_veiculo_id']!, _tipoVeiculoIdMeta));
    } else if (isInserting) {
      context.missing(_tipoVeiculoIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VeiculoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VeiculoTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      placa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}placa'])!,
      modelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modelo'])!,
      ano: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ano'])!,
      tipoVeiculoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo_veiculo_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  $VeiculoTableTable createAlias(String alias) {
    return $VeiculoTableTable(attachedDatabase, alias);
  }
}

class VeiculoTableData extends DataClass
    implements Insertable<VeiculoTableData> {
  final int id;
  final String remoteId;
  final String placa;
  final String modelo;
  final int ano;
  final int tipoVeiculoId;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final DateTime? deletedAt;
  final String? deletedBy;
  const VeiculoTableData(
      {required this.id,
      required this.remoteId,
      required this.placa,
      required this.modelo,
      required this.ano,
      required this.tipoVeiculoId,
      required this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['placa'] = Variable<String>(placa);
    map['modelo'] = Variable<String>(modelo);
    map['ano'] = Variable<int>(ano);
    map['tipo_veiculo_id'] = Variable<int>(tipoVeiculoId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<String>(deletedBy);
    }
    return map;
  }

  VeiculoTableCompanion toCompanion(bool nullToAbsent) {
    return VeiculoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      placa: Value(placa),
      modelo: Value(modelo),
      ano: Value(ano),
      tipoVeiculoId: Value(tipoVeiculoId),
      createdAt: Value(createdAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory VeiculoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VeiculoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      placa: serializer.fromJson<String>(json['placa']),
      modelo: serializer.fromJson<String>(json['modelo']),
      ano: serializer.fromJson<int>(json['ano']),
      tipoVeiculoId: serializer.fromJson<int>(json['tipoVeiculoId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deletedBy: serializer.fromJson<String?>(json['deletedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'placa': serializer.toJson<String>(placa),
      'modelo': serializer.toJson<String>(modelo),
      'ano': serializer.toJson<int>(ano),
      'tipoVeiculoId': serializer.toJson<int>(tipoVeiculoId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deletedBy': serializer.toJson<String?>(deletedBy),
    };
  }

  VeiculoTableData copyWith(
          {int? id,
          String? remoteId,
          String? placa,
          String? modelo,
          int? ano,
          int? tipoVeiculoId,
          DateTime? createdAt,
          Value<String?> createdBy = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> updatedBy = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<String?> deletedBy = const Value.absent()}) =>
      VeiculoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        placa: placa ?? this.placa,
        modelo: modelo ?? this.modelo,
        ano: ano ?? this.ano,
        tipoVeiculoId: tipoVeiculoId ?? this.tipoVeiculoId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  VeiculoTableData copyWithCompanion(VeiculoTableCompanion data) {
    return VeiculoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      placa: data.placa.present ? data.placa.value : this.placa,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      ano: data.ano.present ? data.ano.value : this.ano,
      tipoVeiculoId: data.tipoVeiculoId.present
          ? data.tipoVeiculoId.value
          : this.tipoVeiculoId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VeiculoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('placa: $placa, ')
          ..write('modelo: $modelo, ')
          ..write('ano: $ano, ')
          ..write('tipoVeiculoId: $tipoVeiculoId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      remoteId,
      placa,
      modelo,
      ano,
      tipoVeiculoId,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VeiculoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.placa == this.placa &&
          other.modelo == this.modelo &&
          other.ano == this.ano &&
          other.tipoVeiculoId == this.tipoVeiculoId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class VeiculoTableCompanion extends UpdateCompanion<VeiculoTableData> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> placa;
  final Value<String> modelo;
  final Value<int> ano;
  final Value<int> tipoVeiculoId;
  final Value<DateTime> createdAt;
  final Value<String?> createdBy;
  final Value<DateTime?> updatedAt;
  final Value<String?> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<String?> deletedBy;
  const VeiculoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.placa = const Value.absent(),
    this.modelo = const Value.absent(),
    this.ano = const Value.absent(),
    this.tipoVeiculoId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  VeiculoTableCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String placa,
    required String modelo,
    required int ano,
    required int tipoVeiculoId,
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : remoteId = Value(remoteId),
        placa = Value(placa),
        modelo = Value(modelo),
        ano = Value(ano),
        tipoVeiculoId = Value(tipoVeiculoId);
  static Insertable<VeiculoTableData> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? placa,
    Expression<String>? modelo,
    Expression<int>? ano,
    Expression<int>? tipoVeiculoId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<String>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (placa != null) 'placa': placa,
      if (modelo != null) 'modelo': modelo,
      if (ano != null) 'ano': ano,
      if (tipoVeiculoId != null) 'tipo_veiculo_id': tipoVeiculoId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  VeiculoTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? remoteId,
      Value<String>? placa,
      Value<String>? modelo,
      Value<int>? ano,
      Value<int>? tipoVeiculoId,
      Value<DateTime>? createdAt,
      Value<String?>? createdBy,
      Value<DateTime?>? updatedAt,
      Value<String?>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<String?>? deletedBy}) {
    return VeiculoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      placa: placa ?? this.placa,
      modelo: modelo ?? this.modelo,
      ano: ano ?? this.ano,
      tipoVeiculoId: tipoVeiculoId ?? this.tipoVeiculoId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (placa.present) {
      map['placa'] = Variable<String>(placa.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (ano.present) {
      map['ano'] = Variable<int>(ano.value);
    }
    if (tipoVeiculoId.present) {
      map['tipo_veiculo_id'] = Variable<int>(tipoVeiculoId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<String>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VeiculoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('placa: $placa, ')
          ..write('modelo: $modelo, ')
          ..write('ano: $ano, ')
          ..write('tipoVeiculoId: $tipoVeiculoId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuarioTableTable usuarioTable = $UsuarioTableTable(this);
  late final $TipoVeiculoTableTable tipoVeiculoTable =
      $TipoVeiculoTableTable(this);
  late final $VeiculoTableTable veiculoTable = $VeiculoTableTable(this);
  late final UsuarioDao usuarioDao = UsuarioDao(this as AppDatabase);
  late final TipoVeiculoDao tipoVeiculoDao =
      TipoVeiculoDao(this as AppDatabase);
  late final VeiculoDao veiculoDao = VeiculoDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [usuarioTable, tipoVeiculoTable, veiculoTable];
}

typedef $$UsuarioTableTableCreateCompanionBuilder = UsuarioTableCompanion
    Function({
  Value<int> id,
  required String remoteId,
  required String nome,
  required String matricula,
  Value<String?> token,
  Value<String?> refreshToken,
  Value<DateTime?> ultimoLogin,
  Value<DateTime> createdAt,
});
typedef $$UsuarioTableTableUpdateCompanionBuilder = UsuarioTableCompanion
    Function({
  Value<int> id,
  Value<String> remoteId,
  Value<String> nome,
  Value<String> matricula,
  Value<String?> token,
  Value<String?> refreshToken,
  Value<DateTime?> ultimoLogin,
  Value<DateTime> createdAt,
});

class $$UsuarioTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsuarioTableTable> {
  $$UsuarioTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get ultimoLogin => $composableBuilder(
      column: $table.ultimoLogin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UsuarioTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuarioTableTable> {
  $$UsuarioTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get ultimoLogin => $composableBuilder(
      column: $table.ultimoLogin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsuarioTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuarioTableTable> {
  $$UsuarioTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get matricula =>
      $composableBuilder(column: $table.matricula, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => column);

  GeneratedColumn<DateTime> get ultimoLogin => $composableBuilder(
      column: $table.ultimoLogin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsuarioTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsuarioTableTable,
    UsuarioTableData,
    $$UsuarioTableTableFilterComposer,
    $$UsuarioTableTableOrderingComposer,
    $$UsuarioTableTableAnnotationComposer,
    $$UsuarioTableTableCreateCompanionBuilder,
    $$UsuarioTableTableUpdateCompanionBuilder,
    (
      UsuarioTableData,
      BaseReferences<_$AppDatabase, $UsuarioTableTable, UsuarioTableData>
    ),
    UsuarioTableData,
    PrefetchHooks Function()> {
  $$UsuarioTableTableTableManager(_$AppDatabase db, $UsuarioTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuarioTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuarioTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuarioTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> remoteId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> matricula = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<String?> refreshToken = const Value.absent(),
            Value<DateTime?> ultimoLogin = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsuarioTableCompanion(
            id: id,
            remoteId: remoteId,
            nome: nome,
            matricula: matricula,
            token: token,
            refreshToken: refreshToken,
            ultimoLogin: ultimoLogin,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String remoteId,
            required String nome,
            required String matricula,
            Value<String?> token = const Value.absent(),
            Value<String?> refreshToken = const Value.absent(),
            Value<DateTime?> ultimoLogin = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsuarioTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            nome: nome,
            matricula: matricula,
            token: token,
            refreshToken: refreshToken,
            ultimoLogin: ultimoLogin,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsuarioTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsuarioTableTable,
    UsuarioTableData,
    $$UsuarioTableTableFilterComposer,
    $$UsuarioTableTableOrderingComposer,
    $$UsuarioTableTableAnnotationComposer,
    $$UsuarioTableTableCreateCompanionBuilder,
    $$UsuarioTableTableUpdateCompanionBuilder,
    (
      UsuarioTableData,
      BaseReferences<_$AppDatabase, $UsuarioTableTable, UsuarioTableData>
    ),
    UsuarioTableData,
    PrefetchHooks Function()>;
typedef $$TipoVeiculoTableTableCreateCompanionBuilder
    = TipoVeiculoTableCompanion Function({
  Value<int> id,
  required String remoteId,
  required String nome,
  Value<String?> descricao,
});
typedef $$TipoVeiculoTableTableUpdateCompanionBuilder
    = TipoVeiculoTableCompanion Function({
  Value<int> id,
  Value<String> remoteId,
  Value<String> nome,
  Value<String?> descricao,
});

class $$TipoVeiculoTableTableFilterComposer
    extends Composer<_$AppDatabase, $TipoVeiculoTableTable> {
  $$TipoVeiculoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnFilters(column));
}

class $$TipoVeiculoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TipoVeiculoTableTable> {
  $$TipoVeiculoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnOrderings(column));
}

class $$TipoVeiculoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TipoVeiculoTableTable> {
  $$TipoVeiculoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);
}

class $$TipoVeiculoTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TipoVeiculoTableTable,
    TipoVeiculoTableData,
    $$TipoVeiculoTableTableFilterComposer,
    $$TipoVeiculoTableTableOrderingComposer,
    $$TipoVeiculoTableTableAnnotationComposer,
    $$TipoVeiculoTableTableCreateCompanionBuilder,
    $$TipoVeiculoTableTableUpdateCompanionBuilder,
    (
      TipoVeiculoTableData,
      BaseReferences<_$AppDatabase, $TipoVeiculoTableTable,
          TipoVeiculoTableData>
    ),
    TipoVeiculoTableData,
    PrefetchHooks Function()> {
  $$TipoVeiculoTableTableTableManager(
      _$AppDatabase db, $TipoVeiculoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TipoVeiculoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TipoVeiculoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TipoVeiculoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> remoteId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> descricao = const Value.absent(),
          }) =>
              TipoVeiculoTableCompanion(
            id: id,
            remoteId: remoteId,
            nome: nome,
            descricao: descricao,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String remoteId,
            required String nome,
            Value<String?> descricao = const Value.absent(),
          }) =>
              TipoVeiculoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            nome: nome,
            descricao: descricao,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TipoVeiculoTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TipoVeiculoTableTable,
    TipoVeiculoTableData,
    $$TipoVeiculoTableTableFilterComposer,
    $$TipoVeiculoTableTableOrderingComposer,
    $$TipoVeiculoTableTableAnnotationComposer,
    $$TipoVeiculoTableTableCreateCompanionBuilder,
    $$TipoVeiculoTableTableUpdateCompanionBuilder,
    (
      TipoVeiculoTableData,
      BaseReferences<_$AppDatabase, $TipoVeiculoTableTable,
          TipoVeiculoTableData>
    ),
    TipoVeiculoTableData,
    PrefetchHooks Function()>;
typedef $$VeiculoTableTableCreateCompanionBuilder = VeiculoTableCompanion
    Function({
  Value<int> id,
  required String remoteId,
  required String placa,
  required String modelo,
  required int ano,
  required int tipoVeiculoId,
  Value<DateTime> createdAt,
  Value<String?> createdBy,
  Value<DateTime?> updatedAt,
  Value<String?> updatedBy,
  Value<DateTime?> deletedAt,
  Value<String?> deletedBy,
});
typedef $$VeiculoTableTableUpdateCompanionBuilder = VeiculoTableCompanion
    Function({
  Value<int> id,
  Value<String> remoteId,
  Value<String> placa,
  Value<String> modelo,
  Value<int> ano,
  Value<int> tipoVeiculoId,
  Value<DateTime> createdAt,
  Value<String?> createdBy,
  Value<DateTime?> updatedAt,
  Value<String?> updatedBy,
  Value<DateTime?> deletedAt,
  Value<String?> deletedBy,
});

class $$VeiculoTableTableFilterComposer
    extends Composer<_$AppDatabase, $VeiculoTableTable> {
  $$VeiculoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placa => $composableBuilder(
      column: $table.placa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ano => $composableBuilder(
      column: $table.ano, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $$VeiculoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VeiculoTableTable> {
  $$VeiculoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placa => $composableBuilder(
      column: $table.placa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ano => $composableBuilder(
      column: $table.ano, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $$VeiculoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VeiculoTableTable> {
  $$VeiculoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get placa =>
      $composableBuilder(column: $table.placa, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<int> get ano =>
      $composableBuilder(column: $table.ano, builder: (column) => column);

  GeneratedColumn<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $$VeiculoTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VeiculoTableTable,
    VeiculoTableData,
    $$VeiculoTableTableFilterComposer,
    $$VeiculoTableTableOrderingComposer,
    $$VeiculoTableTableAnnotationComposer,
    $$VeiculoTableTableCreateCompanionBuilder,
    $$VeiculoTableTableUpdateCompanionBuilder,
    (
      VeiculoTableData,
      BaseReferences<_$AppDatabase, $VeiculoTableTable, VeiculoTableData>
    ),
    VeiculoTableData,
    PrefetchHooks Function()> {
  $$VeiculoTableTableTableManager(_$AppDatabase db, $VeiculoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VeiculoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VeiculoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VeiculoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> remoteId = const Value.absent(),
            Value<String> placa = const Value.absent(),
            Value<String> modelo = const Value.absent(),
            Value<int> ano = const Value.absent(),
            Value<int> tipoVeiculoId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String?> deletedBy = const Value.absent(),
          }) =>
              VeiculoTableCompanion(
            id: id,
            remoteId: remoteId,
            placa: placa,
            modelo: modelo,
            ano: ano,
            tipoVeiculoId: tipoVeiculoId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String remoteId,
            required String placa,
            required String modelo,
            required int ano,
            required int tipoVeiculoId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String?> deletedBy = const Value.absent(),
          }) =>
              VeiculoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            placa: placa,
            modelo: modelo,
            ano: ano,
            tipoVeiculoId: tipoVeiculoId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VeiculoTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VeiculoTableTable,
    VeiculoTableData,
    $$VeiculoTableTableFilterComposer,
    $$VeiculoTableTableOrderingComposer,
    $$VeiculoTableTableAnnotationComposer,
    $$VeiculoTableTableCreateCompanionBuilder,
    $$VeiculoTableTableUpdateCompanionBuilder,
    (
      VeiculoTableData,
      BaseReferences<_$AppDatabase, $VeiculoTableTable, VeiculoTableData>
    ),
    VeiculoTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuarioTableTableTableManager get usuarioTable =>
      $$UsuarioTableTableTableManager(_db, _db.usuarioTable);
  $$TipoVeiculoTableTableTableManager get tipoVeiculoTable =>
      $$TipoVeiculoTableTableTableManager(_db, _db.tipoVeiculoTable);
  $$VeiculoTableTableTableManager get veiculoTable =>
      $$VeiculoTableTableTableManager(_db, _db.veiculoTable);
}
