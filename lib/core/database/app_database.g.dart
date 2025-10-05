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
  static const VerificationMeta _tipoVeiculoIdMeta =
      const VerificationMeta('tipoVeiculoId');
  @override
  late final GeneratedColumn<int> tipoVeiculoId = GeneratedColumn<int>(
      'tipo_veiculo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, remoteId, placa, tipoVeiculoId];
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
    if (data.containsKey('tipo_veiculo_id')) {
      context.handle(
          _tipoVeiculoIdMeta,
          tipoVeiculoId.isAcceptableOrUnknown(
              data['tipo_veiculo_id']!, _tipoVeiculoIdMeta));
    } else if (isInserting) {
      context.missing(_tipoVeiculoIdMeta);
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
      tipoVeiculoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo_veiculo_id'])!,
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
  final int tipoVeiculoId;
  const VeiculoTableData(
      {required this.id,
      required this.remoteId,
      required this.placa,
      required this.tipoVeiculoId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['placa'] = Variable<String>(placa);
    map['tipo_veiculo_id'] = Variable<int>(tipoVeiculoId);
    return map;
  }

  VeiculoTableCompanion toCompanion(bool nullToAbsent) {
    return VeiculoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      placa: Value(placa),
      tipoVeiculoId: Value(tipoVeiculoId),
    );
  }

  factory VeiculoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VeiculoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      placa: serializer.fromJson<String>(json['placa']),
      tipoVeiculoId: serializer.fromJson<int>(json['tipoVeiculoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'placa': serializer.toJson<String>(placa),
      'tipoVeiculoId': serializer.toJson<int>(tipoVeiculoId),
    };
  }

  VeiculoTableData copyWith(
          {int? id, String? remoteId, String? placa, int? tipoVeiculoId}) =>
      VeiculoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        placa: placa ?? this.placa,
        tipoVeiculoId: tipoVeiculoId ?? this.tipoVeiculoId,
      );
  VeiculoTableData copyWithCompanion(VeiculoTableCompanion data) {
    return VeiculoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      placa: data.placa.present ? data.placa.value : this.placa,
      tipoVeiculoId: data.tipoVeiculoId.present
          ? data.tipoVeiculoId.value
          : this.tipoVeiculoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VeiculoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('placa: $placa, ')
          ..write('tipoVeiculoId: $tipoVeiculoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, placa, tipoVeiculoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VeiculoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.placa == this.placa &&
          other.tipoVeiculoId == this.tipoVeiculoId);
}

class VeiculoTableCompanion extends UpdateCompanion<VeiculoTableData> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> placa;
  final Value<int> tipoVeiculoId;
  const VeiculoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.placa = const Value.absent(),
    this.tipoVeiculoId = const Value.absent(),
  });
  VeiculoTableCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String placa,
    required int tipoVeiculoId,
  })  : remoteId = Value(remoteId),
        placa = Value(placa),
        tipoVeiculoId = Value(tipoVeiculoId);
  static Insertable<VeiculoTableData> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? placa,
    Expression<int>? tipoVeiculoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (placa != null) 'placa': placa,
      if (tipoVeiculoId != null) 'tipo_veiculo_id': tipoVeiculoId,
    });
  }

  VeiculoTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? remoteId,
      Value<String>? placa,
      Value<int>? tipoVeiculoId}) {
    return VeiculoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      placa: placa ?? this.placa,
      tipoVeiculoId: tipoVeiculoId ?? this.tipoVeiculoId,
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
    if (tipoVeiculoId.present) {
      map['tipo_veiculo_id'] = Variable<int>(tipoVeiculoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VeiculoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('placa: $placa, ')
          ..write('tipoVeiculoId: $tipoVeiculoId')
          ..write(')'))
        .toString();
  }
}

class $TipoEquipeTableTable extends TipoEquipeTable
    with TableInfo<$TipoEquipeTableTable, TipoEquipeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TipoEquipeTableTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sincronizadoMeta =
      const VerificationMeta('sincronizado');
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
      'sincronizado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sincronizado" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, remoteId, createdAt, updatedAt, sincronizado, nome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipo_equipe_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TipoEquipeTableData> instance,
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
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
          _sincronizadoMeta,
          sincronizado.isAcceptableOrUnknown(
              data['sincronizado']!, _sincronizadoMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TipoEquipeTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TipoEquipeTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      sincronizado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sincronizado'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
    );
  }

  @override
  $TipoEquipeTableTable createAlias(String alias) {
    return $TipoEquipeTableTable(attachedDatabase, alias);
  }
}

class TipoEquipeTableData extends DataClass
    implements Insertable<TipoEquipeTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String nome;
  const TipoEquipeTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.nome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['nome'] = Variable<String>(nome);
    return map;
  }

  TipoEquipeTableCompanion toCompanion(bool nullToAbsent) {
    return TipoEquipeTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      nome: Value(nome),
    );
  }

  factory TipoEquipeTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TipoEquipeTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      nome: serializer.fromJson<String>(json['nome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int>(remoteId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sincronizado': serializer.toJson<bool>(sincronizado),
      'nome': serializer.toJson<String>(nome),
    };
  }

  TipoEquipeTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? nome}) =>
      TipoEquipeTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        nome: nome ?? this.nome,
      );
  TipoEquipeTableData copyWithCompanion(TipoEquipeTableCompanion data) {
    return TipoEquipeTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      nome: data.nome.present ? data.nome.value : this.nome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TipoEquipeTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, remoteId, createdAt, updatedAt, sincronizado, nome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TipoEquipeTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.nome == this.nome);
}

class TipoEquipeTableCompanion extends UpdateCompanion<TipoEquipeTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> nome;
  const TipoEquipeTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.nome = const Value.absent(),
  });
  TipoEquipeTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required String nome,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        nome = Value(nome);
  static Insertable<TipoEquipeTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<String>? nome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (nome != null) 'nome': nome,
    });
  }

  TipoEquipeTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? nome}) {
    return TipoEquipeTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      nome: nome ?? this.nome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TipoEquipeTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }
}

class $EquipeTableTable extends EquipeTable
    with TableInfo<$EquipeTableTable, EquipeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipeTableTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sincronizadoMeta =
      const VerificationMeta('sincronizado');
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
      'sincronizado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sincronizado" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  static const VerificationMeta _tipoEquipeIdMeta =
      const VerificationMeta('tipoEquipeId');
  @override
  late final GeneratedColumn<int> tipoEquipeId = GeneratedColumn<int>(
      'tipo_equipe_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        createdAt,
        updatedAt,
        sincronizado,
        nome,
        descricao,
        tipoEquipeId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipe_table';
  @override
  VerificationContext validateIntegrity(Insertable<EquipeTableData> instance,
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
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
          _sincronizadoMeta,
          sincronizado.isAcceptableOrUnknown(
              data['sincronizado']!, _sincronizadoMeta));
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
    if (data.containsKey('tipo_equipe_id')) {
      context.handle(
          _tipoEquipeIdMeta,
          tipoEquipeId.isAcceptableOrUnknown(
              data['tipo_equipe_id']!, _tipoEquipeIdMeta));
    } else if (isInserting) {
      context.missing(_tipoEquipeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipeTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipeTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      sincronizado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sincronizado'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      descricao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descricao']),
      tipoEquipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo_equipe_id'])!,
    );
  }

  @override
  $EquipeTableTable createAlias(String alias) {
    return $EquipeTableTable(attachedDatabase, alias);
  }
}

class EquipeTableData extends DataClass implements Insertable<EquipeTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String nome;
  final String? descricao;
  final int tipoEquipeId;
  const EquipeTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.nome,
      this.descricao,
      required this.tipoEquipeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    map['tipo_equipe_id'] = Variable<int>(tipoEquipeId);
    return map;
  }

  EquipeTableCompanion toCompanion(bool nullToAbsent) {
    return EquipeTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      nome: Value(nome),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      tipoEquipeId: Value(tipoEquipeId),
    );
  }

  factory EquipeTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipeTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      tipoEquipeId: serializer.fromJson<int>(json['tipoEquipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int>(remoteId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sincronizado': serializer.toJson<bool>(sincronizado),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String?>(descricao),
      'tipoEquipeId': serializer.toJson<int>(tipoEquipeId),
    };
  }

  EquipeTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? nome,
          Value<String?> descricao = const Value.absent(),
          int? tipoEquipeId}) =>
      EquipeTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        nome: nome ?? this.nome,
        descricao: descricao.present ? descricao.value : this.descricao,
        tipoEquipeId: tipoEquipeId ?? this.tipoEquipeId,
      );
  EquipeTableData copyWithCompanion(EquipeTableCompanion data) {
    return EquipeTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      tipoEquipeId: data.tipoEquipeId.present
          ? data.tipoEquipeId.value
          : this.tipoEquipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipeTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipoEquipeId: $tipoEquipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, createdAt, updatedAt,
      sincronizado, nome, descricao, tipoEquipeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipeTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.tipoEquipeId == this.tipoEquipeId);
}

class EquipeTableCompanion extends UpdateCompanion<EquipeTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> nome;
  final Value<String?> descricao;
  final Value<int> tipoEquipeId;
  const EquipeTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
    this.tipoEquipeId = const Value.absent(),
  });
  EquipeTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required String nome,
    this.descricao = const Value.absent(),
    required int tipoEquipeId,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        nome = Value(nome),
        tipoEquipeId = Value(tipoEquipeId);
  static Insertable<EquipeTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<String>? nome,
    Expression<String>? descricao,
    Expression<int>? tipoEquipeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
      if (tipoEquipeId != null) 'tipo_equipe_id': tipoEquipeId,
    });
  }

  EquipeTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? nome,
      Value<String?>? descricao,
      Value<int>? tipoEquipeId}) {
    return EquipeTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipoEquipeId: tipoEquipeId ?? this.tipoEquipeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (tipoEquipeId.present) {
      map['tipo_equipe_id'] = Variable<int>(tipoEquipeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipeTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipoEquipeId: $tipoEquipeId')
          ..write(')'))
        .toString();
  }
}

class $EletricistaTableTable extends EletricistaTable
    with TableInfo<$EletricistaTableTable, EletricistaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EletricistaTableTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sincronizadoMeta =
      const VerificationMeta('sincronizado');
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
      'sincronizado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sincronizado" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, remoteId, createdAt, updatedAt, sincronizado, nome, matricula];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'eletricista_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EletricistaTableData> instance,
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
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
          _sincronizadoMeta,
          sincronizado.isAcceptableOrUnknown(
              data['sincronizado']!, _sincronizadoMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EletricistaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EletricistaTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      sincronizado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sincronizado'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      matricula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}matricula'])!,
    );
  }

  @override
  $EletricistaTableTable createAlias(String alias) {
    return $EletricistaTableTable(attachedDatabase, alias);
  }
}

class EletricistaTableData extends DataClass
    implements Insertable<EletricistaTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String nome;
  final String matricula;
  const EletricistaTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.nome,
      required this.matricula});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['nome'] = Variable<String>(nome);
    map['matricula'] = Variable<String>(matricula);
    return map;
  }

  EletricistaTableCompanion toCompanion(bool nullToAbsent) {
    return EletricistaTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      nome: Value(nome),
      matricula: Value(matricula),
    );
  }

  factory EletricistaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EletricistaTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      nome: serializer.fromJson<String>(json['nome']),
      matricula: serializer.fromJson<String>(json['matricula']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int>(remoteId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sincronizado': serializer.toJson<bool>(sincronizado),
      'nome': serializer.toJson<String>(nome),
      'matricula': serializer.toJson<String>(matricula),
    };
  }

  EletricistaTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? nome,
          String? matricula}) =>
      EletricistaTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        nome: nome ?? this.nome,
        matricula: matricula ?? this.matricula,
      );
  EletricistaTableData copyWithCompanion(EletricistaTableCompanion data) {
    return EletricistaTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      nome: data.nome.present ? data.nome.value : this.nome,
      matricula: data.matricula.present ? data.matricula.value : this.matricula,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EletricistaTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('matricula: $matricula')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, remoteId, createdAt, updatedAt, sincronizado, nome, matricula);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EletricistaTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.nome == this.nome &&
          other.matricula == this.matricula);
}

class EletricistaTableCompanion extends UpdateCompanion<EletricistaTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> nome;
  final Value<String> matricula;
  const EletricistaTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.nome = const Value.absent(),
    this.matricula = const Value.absent(),
  });
  EletricistaTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required String nome,
    required String matricula,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        nome = Value(nome),
        matricula = Value(matricula);
  static Insertable<EletricistaTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<String>? nome,
    Expression<String>? matricula,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (nome != null) 'nome': nome,
      if (matricula != null) 'matricula': matricula,
    });
  }

  EletricistaTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? nome,
      Value<String>? matricula}) {
    return EletricistaTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      nome: nome ?? this.nome,
      matricula: matricula ?? this.matricula,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (matricula.present) {
      map['matricula'] = Variable<String>(matricula.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EletricistaTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('matricula: $matricula')
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
  late final $TipoEquipeTableTable tipoEquipeTable =
      $TipoEquipeTableTable(this);
  late final $EquipeTableTable equipeTable = $EquipeTableTable(this);
  late final $EletricistaTableTable eletricistaTable =
      $EletricistaTableTable(this);
  late final UsuarioDao usuarioDao = UsuarioDao(this as AppDatabase);
  late final TipoVeiculoDao tipoVeiculoDao =
      TipoVeiculoDao(this as AppDatabase);
  late final VeiculoDao veiculoDao = VeiculoDao(this as AppDatabase);
  late final TipoEquipeDao tipoEquipeDao = TipoEquipeDao(this as AppDatabase);
  late final EquipeDao equipeDao = EquipeDao(this as AppDatabase);
  late final EletricistaDao eletricistaDao =
      EletricistaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        usuarioTable,
        tipoVeiculoTable,
        veiculoTable,
        tipoEquipeTable,
        equipeTable,
        eletricistaTable
      ];
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
  required int tipoVeiculoId,
});
typedef $$VeiculoTableTableUpdateCompanionBuilder = VeiculoTableCompanion
    Function({
  Value<int> id,
  Value<String> remoteId,
  Value<String> placa,
  Value<int> tipoVeiculoId,
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

  ColumnFilters<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId,
      builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId, builder: (column) => column);
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
            Value<int> tipoVeiculoId = const Value.absent(),
          }) =>
              VeiculoTableCompanion(
            id: id,
            remoteId: remoteId,
            placa: placa,
            tipoVeiculoId: tipoVeiculoId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String remoteId,
            required String placa,
            required int tipoVeiculoId,
          }) =>
              VeiculoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            placa: placa,
            tipoVeiculoId: tipoVeiculoId,
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
typedef $$TipoEquipeTableTableCreateCompanionBuilder = TipoEquipeTableCompanion
    Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String nome,
});
typedef $$TipoEquipeTableTableUpdateCompanionBuilder = TipoEquipeTableCompanion
    Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<String> nome,
});

class $$TipoEquipeTableTableFilterComposer
    extends Composer<_$AppDatabase, $TipoEquipeTableTable> {
  $$TipoEquipeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));
}

class $$TipoEquipeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TipoEquipeTableTable> {
  $$TipoEquipeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));
}

class $$TipoEquipeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TipoEquipeTableTable> {
  $$TipoEquipeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);
}

class $$TipoEquipeTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TipoEquipeTableTable,
    TipoEquipeTableData,
    $$TipoEquipeTableTableFilterComposer,
    $$TipoEquipeTableTableOrderingComposer,
    $$TipoEquipeTableTableAnnotationComposer,
    $$TipoEquipeTableTableCreateCompanionBuilder,
    $$TipoEquipeTableTableUpdateCompanionBuilder,
    (
      TipoEquipeTableData,
      BaseReferences<_$AppDatabase, $TipoEquipeTableTable, TipoEquipeTableData>
    ),
    TipoEquipeTableData,
    PrefetchHooks Function()> {
  $$TipoEquipeTableTableTableManager(
      _$AppDatabase db, $TipoEquipeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TipoEquipeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TipoEquipeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TipoEquipeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> nome = const Value.absent(),
          }) =>
              TipoEquipeTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required String nome,
          }) =>
              TipoEquipeTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TipoEquipeTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TipoEquipeTableTable,
    TipoEquipeTableData,
    $$TipoEquipeTableTableFilterComposer,
    $$TipoEquipeTableTableOrderingComposer,
    $$TipoEquipeTableTableAnnotationComposer,
    $$TipoEquipeTableTableCreateCompanionBuilder,
    $$TipoEquipeTableTableUpdateCompanionBuilder,
    (
      TipoEquipeTableData,
      BaseReferences<_$AppDatabase, $TipoEquipeTableTable, TipoEquipeTableData>
    ),
    TipoEquipeTableData,
    PrefetchHooks Function()>;
typedef $$EquipeTableTableCreateCompanionBuilder = EquipeTableCompanion
    Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String nome,
  Value<String?> descricao,
  required int tipoEquipeId,
});
typedef $$EquipeTableTableUpdateCompanionBuilder = EquipeTableCompanion
    Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<String> nome,
  Value<String?> descricao,
  Value<int> tipoEquipeId,
});

class $$EquipeTableTableFilterComposer
    extends Composer<_$AppDatabase, $EquipeTableTable> {
  $$EquipeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tipoEquipeId => $composableBuilder(
      column: $table.tipoEquipeId, builder: (column) => ColumnFilters(column));
}

class $$EquipeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipeTableTable> {
  $$EquipeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tipoEquipeId => $composableBuilder(
      column: $table.tipoEquipeId,
      builder: (column) => ColumnOrderings(column));
}

class $$EquipeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipeTableTable> {
  $$EquipeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<int> get tipoEquipeId => $composableBuilder(
      column: $table.tipoEquipeId, builder: (column) => column);
}

class $$EquipeTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EquipeTableTable,
    EquipeTableData,
    $$EquipeTableTableFilterComposer,
    $$EquipeTableTableOrderingComposer,
    $$EquipeTableTableAnnotationComposer,
    $$EquipeTableTableCreateCompanionBuilder,
    $$EquipeTableTableUpdateCompanionBuilder,
    (
      EquipeTableData,
      BaseReferences<_$AppDatabase, $EquipeTableTable, EquipeTableData>
    ),
    EquipeTableData,
    PrefetchHooks Function()> {
  $$EquipeTableTableTableManager(_$AppDatabase db, $EquipeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> descricao = const Value.absent(),
            Value<int> tipoEquipeId = const Value.absent(),
          }) =>
              EquipeTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            descricao: descricao,
            tipoEquipeId: tipoEquipeId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required String nome,
            Value<String?> descricao = const Value.absent(),
            required int tipoEquipeId,
          }) =>
              EquipeTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            descricao: descricao,
            tipoEquipeId: tipoEquipeId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EquipeTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EquipeTableTable,
    EquipeTableData,
    $$EquipeTableTableFilterComposer,
    $$EquipeTableTableOrderingComposer,
    $$EquipeTableTableAnnotationComposer,
    $$EquipeTableTableCreateCompanionBuilder,
    $$EquipeTableTableUpdateCompanionBuilder,
    (
      EquipeTableData,
      BaseReferences<_$AppDatabase, $EquipeTableTable, EquipeTableData>
    ),
    EquipeTableData,
    PrefetchHooks Function()>;
typedef $$EletricistaTableTableCreateCompanionBuilder
    = EletricistaTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String nome,
  required String matricula,
});
typedef $$EletricistaTableTableUpdateCompanionBuilder
    = EletricistaTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<String> nome,
  Value<String> matricula,
});

class $$EletricistaTableTableFilterComposer
    extends Composer<_$AppDatabase, $EletricistaTableTable> {
  $$EletricistaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnFilters(column));
}

class $$EletricistaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EletricistaTableTable> {
  $$EletricistaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnOrderings(column));
}

class $$EletricistaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EletricistaTableTable> {
  $$EletricistaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get matricula =>
      $composableBuilder(column: $table.matricula, builder: (column) => column);
}

class $$EletricistaTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EletricistaTableTable,
    EletricistaTableData,
    $$EletricistaTableTableFilterComposer,
    $$EletricistaTableTableOrderingComposer,
    $$EletricistaTableTableAnnotationComposer,
    $$EletricistaTableTableCreateCompanionBuilder,
    $$EletricistaTableTableUpdateCompanionBuilder,
    (
      EletricistaTableData,
      BaseReferences<_$AppDatabase, $EletricistaTableTable,
          EletricistaTableData>
    ),
    EletricistaTableData,
    PrefetchHooks Function()> {
  $$EletricistaTableTableTableManager(
      _$AppDatabase db, $EletricistaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EletricistaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EletricistaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EletricistaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> matricula = const Value.absent(),
          }) =>
              EletricistaTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            matricula: matricula,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required String nome,
            required String matricula,
          }) =>
              EletricistaTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            matricula: matricula,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EletricistaTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EletricistaTableTable,
    EletricistaTableData,
    $$EletricistaTableTableFilterComposer,
    $$EletricistaTableTableOrderingComposer,
    $$EletricistaTableTableAnnotationComposer,
    $$EletricistaTableTableCreateCompanionBuilder,
    $$EletricistaTableTableUpdateCompanionBuilder,
    (
      EletricistaTableData,
      BaseReferences<_$AppDatabase, $EletricistaTableTable,
          EletricistaTableData>
    ),
    EletricistaTableData,
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
  $$TipoEquipeTableTableTableManager get tipoEquipeTable =>
      $$TipoEquipeTableTableTableManager(_db, _db.tipoEquipeTable);
  $$EquipeTableTableTableManager get equipeTable =>
      $$EquipeTableTableTableManager(_db, _db.equipeTable);
  $$EletricistaTableTableTableManager get eletricistaTable =>
      $$EletricistaTableTableTableManager(_db, _db.eletricistaTable);
}
