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
  @override
  List<GeneratedColumn> get $columns =>
      [id, remoteId, createdAt, updatedAt, sincronizado, nome, descricao];
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
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String nome;
  final String? descricao;
  const TipoVeiculoTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.nome,
      this.descricao});
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
    return map;
  }

  TipoVeiculoTableCompanion toCompanion(bool nullToAbsent) {
    return TipoVeiculoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
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
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String?>(json['descricao']),
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
    };
  }

  TipoVeiculoTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? nome,
          Value<String?> descricao = const Value.absent()}) =>
      TipoVeiculoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        nome: nome ?? this.nome,
        descricao: descricao.present ? descricao.value : this.descricao,
      );
  TipoVeiculoTableData copyWithCompanion(TipoVeiculoTableCompanion data) {
    return TipoVeiculoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TipoVeiculoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, remoteId, createdAt, updatedAt, sincronizado, nome, descricao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TipoVeiculoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.nome == this.nome &&
          other.descricao == this.descricao);
}

class TipoVeiculoTableCompanion extends UpdateCompanion<TipoVeiculoTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> nome;
  final Value<String?> descricao;
  const TipoVeiculoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
  });
  TipoVeiculoTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required String nome,
    this.descricao = const Value.absent(),
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        nome = Value(nome);
  static Insertable<TipoVeiculoTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<String>? nome,
    Expression<String>? descricao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
    });
  }

  TipoVeiculoTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? nome,
      Value<String?>? descricao}) {
    return TipoVeiculoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TipoVeiculoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
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
  List<GeneratedColumn> get $columns =>
      [id, remoteId, createdAt, updatedAt, sincronizado, placa, tipoVeiculoId];
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
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      sincronizado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sincronizado'])!,
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
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String placa;
  final int tipoVeiculoId;
  const VeiculoTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.placa,
      required this.tipoVeiculoId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['placa'] = Variable<String>(placa);
    map['tipo_veiculo_id'] = Variable<int>(tipoVeiculoId);
    return map;
  }

  VeiculoTableCompanion toCompanion(bool nullToAbsent) {
    return VeiculoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      placa: Value(placa),
      tipoVeiculoId: Value(tipoVeiculoId),
    );
  }

  factory VeiculoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VeiculoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      placa: serializer.fromJson<String>(json['placa']),
      tipoVeiculoId: serializer.fromJson<int>(json['tipoVeiculoId']),
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
      'placa': serializer.toJson<String>(placa),
      'tipoVeiculoId': serializer.toJson<int>(tipoVeiculoId),
    };
  }

  VeiculoTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? placa,
          int? tipoVeiculoId}) =>
      VeiculoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        placa: placa ?? this.placa,
        tipoVeiculoId: tipoVeiculoId ?? this.tipoVeiculoId,
      );
  VeiculoTableData copyWithCompanion(VeiculoTableCompanion data) {
    return VeiculoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('placa: $placa, ')
          ..write('tipoVeiculoId: $tipoVeiculoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, remoteId, createdAt, updatedAt, sincronizado, placa, tipoVeiculoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VeiculoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.placa == this.placa &&
          other.tipoVeiculoId == this.tipoVeiculoId);
}

class VeiculoTableCompanion extends UpdateCompanion<VeiculoTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> placa;
  final Value<int> tipoVeiculoId;
  const VeiculoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.placa = const Value.absent(),
    this.tipoVeiculoId = const Value.absent(),
  });
  VeiculoTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required String placa,
    required int tipoVeiculoId,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        placa = Value(placa),
        tipoVeiculoId = Value(tipoVeiculoId);
  static Insertable<VeiculoTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<String>? placa,
    Expression<int>? tipoVeiculoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (placa != null) 'placa': placa,
      if (tipoVeiculoId != null) 'tipo_veiculo_id': tipoVeiculoId,
    });
  }

  VeiculoTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? placa,
      Value<int>? tipoVeiculoId}) {
    return VeiculoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
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

class $TurnoTableTable extends TurnoTable
    with TableInfo<$TurnoTableTable, TurnoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TurnoTableTable(this.attachedDatabase, [this._alias]);
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
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _veiculoIdMeta =
      const VerificationMeta('veiculoId');
  @override
  late final GeneratedColumn<int> veiculoId = GeneratedColumn<int>(
      'veiculo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _equipeIdMeta =
      const VerificationMeta('equipeId');
  @override
  late final GeneratedColumn<int> equipeId = GeneratedColumn<int>(
      'equipe_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kmInicialMeta =
      const VerificationMeta('kmInicial');
  @override
  late final GeneratedColumn<int> kmInicial = GeneratedColumn<int>(
      'km_inicial', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kmFinalMeta =
      const VerificationMeta('kmFinal');
  @override
  late final GeneratedColumn<int> kmFinal = GeneratedColumn<int>(
      'km_final', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _horaInicioMeta =
      const VerificationMeta('horaInicio');
  @override
  late final GeneratedColumn<DateTime> horaInicio = GeneratedColumn<DateTime>(
      'hora_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _horaFimMeta =
      const VerificationMeta('horaFim');
  @override
  late final GeneratedColumn<DateTime> horaFim = GeneratedColumn<DateTime>(
      'hora_fim', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<String> latitude = GeneratedColumn<String>(
      'latitude', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<String> longitude = GeneratedColumn<String>(
      'longitude', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _situacaoTurnoMeta =
      const VerificationMeta('situacaoTurno');
  @override
  late final GeneratedColumnWithTypeConverter<SituacaoTurno, String>
      situacaoTurno = GeneratedColumn<String>(
              'situacao_turno', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SituacaoTurno>(
              $TurnoTableTable.$convertersituacaoTurno);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        veiculoId,
        equipeId,
        kmInicial,
        kmFinal,
        horaInicio,
        horaFim,
        latitude,
        longitude,
        situacaoTurno
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'turno_table';
  @override
  VerificationContext validateIntegrity(Insertable<TurnoTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('veiculo_id')) {
      context.handle(_veiculoIdMeta,
          veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta));
    } else if (isInserting) {
      context.missing(_veiculoIdMeta);
    }
    if (data.containsKey('equipe_id')) {
      context.handle(_equipeIdMeta,
          equipeId.isAcceptableOrUnknown(data['equipe_id']!, _equipeIdMeta));
    } else if (isInserting) {
      context.missing(_equipeIdMeta);
    }
    if (data.containsKey('km_inicial')) {
      context.handle(_kmInicialMeta,
          kmInicial.isAcceptableOrUnknown(data['km_inicial']!, _kmInicialMeta));
    } else if (isInserting) {
      context.missing(_kmInicialMeta);
    }
    if (data.containsKey('km_final')) {
      context.handle(_kmFinalMeta,
          kmFinal.isAcceptableOrUnknown(data['km_final']!, _kmFinalMeta));
    }
    if (data.containsKey('hora_inicio')) {
      context.handle(
          _horaInicioMeta,
          horaInicio.isAcceptableOrUnknown(
              data['hora_inicio']!, _horaInicioMeta));
    } else if (isInserting) {
      context.missing(_horaInicioMeta);
    }
    if (data.containsKey('hora_fim')) {
      context.handle(_horaFimMeta,
          horaFim.isAcceptableOrUnknown(data['hora_fim']!, _horaFimMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    context.handle(_situacaoTurnoMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TurnoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TurnoTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      veiculoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}veiculo_id'])!,
      equipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}equipe_id'])!,
      kmInicial: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}km_inicial'])!,
      kmFinal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}km_final']),
      horaInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}hora_inicio'])!,
      horaFim: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}hora_fim']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}longitude']),
      situacaoTurno: $TurnoTableTable.$convertersituacaoTurno.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}situacao_turno'])!),
    );
  }

  @override
  $TurnoTableTable createAlias(String alias) {
    return $TurnoTableTable(attachedDatabase, alias);
  }

  static TypeConverter<SituacaoTurno, String> $convertersituacaoTurno =
      const SituacaoTurnoConverter();
}

class TurnoTableData extends DataClass implements Insertable<TurnoTableData> {
  /// ID único local (chave primária).
  final int id;

  /// ID remoto do servidor (pode ser nulo se ainda não sincronizado).
  final int? remoteId;

  /// ID do veículo utilizado no turno.
  final int veiculoId;

  /// ID da equipe responsável pelo turno.
  final int equipeId;

  /// Quilometragem inicial do veículo.
  final int kmInicial;

  /// Quilometragem final do veículo (nula até o fechamento do turno).
  final int? kmFinal;

  /// Data e hora de início do turno.
  final DateTime horaInicio;

  /// Data e hora de fim do turno (nula até o fechamento).
  final DateTime? horaFim;

  /// Latitude da localização de início do turno.
  final String? latitude;

  /// Longitude da localização de início do turno.
  final String? longitude;

  /// Situação atual do turno (usando converter personalizado).
  final SituacaoTurno situacaoTurno;
  const TurnoTableData(
      {required this.id,
      this.remoteId,
      required this.veiculoId,
      required this.equipeId,
      required this.kmInicial,
      this.kmFinal,
      required this.horaInicio,
      this.horaFim,
      this.latitude,
      this.longitude,
      required this.situacaoTurno});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['veiculo_id'] = Variable<int>(veiculoId);
    map['equipe_id'] = Variable<int>(equipeId);
    map['km_inicial'] = Variable<int>(kmInicial);
    if (!nullToAbsent || kmFinal != null) {
      map['km_final'] = Variable<int>(kmFinal);
    }
    map['hora_inicio'] = Variable<DateTime>(horaInicio);
    if (!nullToAbsent || horaFim != null) {
      map['hora_fim'] = Variable<DateTime>(horaFim);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<String>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<String>(longitude);
    }
    {
      map['situacao_turno'] = Variable<String>(
          $TurnoTableTable.$convertersituacaoTurno.toSql(situacaoTurno));
    }
    return map;
  }

  TurnoTableCompanion toCompanion(bool nullToAbsent) {
    return TurnoTableCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      veiculoId: Value(veiculoId),
      equipeId: Value(equipeId),
      kmInicial: Value(kmInicial),
      kmFinal: kmFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(kmFinal),
      horaInicio: Value(horaInicio),
      horaFim: horaFim == null && nullToAbsent
          ? const Value.absent()
          : Value(horaFim),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      situacaoTurno: Value(situacaoTurno),
    );
  }

  factory TurnoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TurnoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      veiculoId: serializer.fromJson<int>(json['veiculoId']),
      equipeId: serializer.fromJson<int>(json['equipeId']),
      kmInicial: serializer.fromJson<int>(json['kmInicial']),
      kmFinal: serializer.fromJson<int?>(json['kmFinal']),
      horaInicio: serializer.fromJson<DateTime>(json['horaInicio']),
      horaFim: serializer.fromJson<DateTime?>(json['horaFim']),
      latitude: serializer.fromJson<String?>(json['latitude']),
      longitude: serializer.fromJson<String?>(json['longitude']),
      situacaoTurno: serializer.fromJson<SituacaoTurno>(json['situacaoTurno']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int?>(remoteId),
      'veiculoId': serializer.toJson<int>(veiculoId),
      'equipeId': serializer.toJson<int>(equipeId),
      'kmInicial': serializer.toJson<int>(kmInicial),
      'kmFinal': serializer.toJson<int?>(kmFinal),
      'horaInicio': serializer.toJson<DateTime>(horaInicio),
      'horaFim': serializer.toJson<DateTime?>(horaFim),
      'latitude': serializer.toJson<String?>(latitude),
      'longitude': serializer.toJson<String?>(longitude),
      'situacaoTurno': serializer.toJson<SituacaoTurno>(situacaoTurno),
    };
  }

  TurnoTableData copyWith(
          {int? id,
          Value<int?> remoteId = const Value.absent(),
          int? veiculoId,
          int? equipeId,
          int? kmInicial,
          Value<int?> kmFinal = const Value.absent(),
          DateTime? horaInicio,
          Value<DateTime?> horaFim = const Value.absent(),
          Value<String?> latitude = const Value.absent(),
          Value<String?> longitude = const Value.absent(),
          SituacaoTurno? situacaoTurno}) =>
      TurnoTableData(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        veiculoId: veiculoId ?? this.veiculoId,
        equipeId: equipeId ?? this.equipeId,
        kmInicial: kmInicial ?? this.kmInicial,
        kmFinal: kmFinal.present ? kmFinal.value : this.kmFinal,
        horaInicio: horaInicio ?? this.horaInicio,
        horaFim: horaFim.present ? horaFim.value : this.horaFim,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        situacaoTurno: situacaoTurno ?? this.situacaoTurno,
      );
  TurnoTableData copyWithCompanion(TurnoTableCompanion data) {
    return TurnoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      equipeId: data.equipeId.present ? data.equipeId.value : this.equipeId,
      kmInicial: data.kmInicial.present ? data.kmInicial.value : this.kmInicial,
      kmFinal: data.kmFinal.present ? data.kmFinal.value : this.kmFinal,
      horaInicio:
          data.horaInicio.present ? data.horaInicio.value : this.horaInicio,
      horaFim: data.horaFim.present ? data.horaFim.value : this.horaFim,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      situacaoTurno: data.situacaoTurno.present
          ? data.situacaoTurno.value
          : this.situacaoTurno,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TurnoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('equipeId: $equipeId, ')
          ..write('kmInicial: $kmInicial, ')
          ..write('kmFinal: $kmFinal, ')
          ..write('horaInicio: $horaInicio, ')
          ..write('horaFim: $horaFim, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('situacaoTurno: $situacaoTurno')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, veiculoId, equipeId, kmInicial,
      kmFinal, horaInicio, horaFim, latitude, longitude, situacaoTurno);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TurnoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.veiculoId == this.veiculoId &&
          other.equipeId == this.equipeId &&
          other.kmInicial == this.kmInicial &&
          other.kmFinal == this.kmFinal &&
          other.horaInicio == this.horaInicio &&
          other.horaFim == this.horaFim &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.situacaoTurno == this.situacaoTurno);
}

class TurnoTableCompanion extends UpdateCompanion<TurnoTableData> {
  final Value<int> id;
  final Value<int?> remoteId;
  final Value<int> veiculoId;
  final Value<int> equipeId;
  final Value<int> kmInicial;
  final Value<int?> kmFinal;
  final Value<DateTime> horaInicio;
  final Value<DateTime?> horaFim;
  final Value<String?> latitude;
  final Value<String?> longitude;
  final Value<SituacaoTurno> situacaoTurno;
  const TurnoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.equipeId = const Value.absent(),
    this.kmInicial = const Value.absent(),
    this.kmFinal = const Value.absent(),
    this.horaInicio = const Value.absent(),
    this.horaFim = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.situacaoTurno = const Value.absent(),
  });
  TurnoTableCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required int veiculoId,
    required int equipeId,
    required int kmInicial,
    this.kmFinal = const Value.absent(),
    required DateTime horaInicio,
    this.horaFim = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required SituacaoTurno situacaoTurno,
  })  : veiculoId = Value(veiculoId),
        equipeId = Value(equipeId),
        kmInicial = Value(kmInicial),
        horaInicio = Value(horaInicio),
        situacaoTurno = Value(situacaoTurno);
  static Insertable<TurnoTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<int>? veiculoId,
    Expression<int>? equipeId,
    Expression<int>? kmInicial,
    Expression<int>? kmFinal,
    Expression<DateTime>? horaInicio,
    Expression<DateTime>? horaFim,
    Expression<String>? latitude,
    Expression<String>? longitude,
    Expression<String>? situacaoTurno,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (equipeId != null) 'equipe_id': equipeId,
      if (kmInicial != null) 'km_inicial': kmInicial,
      if (kmFinal != null) 'km_final': kmFinal,
      if (horaInicio != null) 'hora_inicio': horaInicio,
      if (horaFim != null) 'hora_fim': horaFim,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (situacaoTurno != null) 'situacao_turno': situacaoTurno,
    });
  }

  TurnoTableCompanion copyWith(
      {Value<int>? id,
      Value<int?>? remoteId,
      Value<int>? veiculoId,
      Value<int>? equipeId,
      Value<int>? kmInicial,
      Value<int?>? kmFinal,
      Value<DateTime>? horaInicio,
      Value<DateTime?>? horaFim,
      Value<String?>? latitude,
      Value<String?>? longitude,
      Value<SituacaoTurno>? situacaoTurno}) {
    return TurnoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      veiculoId: veiculoId ?? this.veiculoId,
      equipeId: equipeId ?? this.equipeId,
      kmInicial: kmInicial ?? this.kmInicial,
      kmFinal: kmFinal ?? this.kmFinal,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFim: horaFim ?? this.horaFim,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      situacaoTurno: situacaoTurno ?? this.situacaoTurno,
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
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<int>(veiculoId.value);
    }
    if (equipeId.present) {
      map['equipe_id'] = Variable<int>(equipeId.value);
    }
    if (kmInicial.present) {
      map['km_inicial'] = Variable<int>(kmInicial.value);
    }
    if (kmFinal.present) {
      map['km_final'] = Variable<int>(kmFinal.value);
    }
    if (horaInicio.present) {
      map['hora_inicio'] = Variable<DateTime>(horaInicio.value);
    }
    if (horaFim.present) {
      map['hora_fim'] = Variable<DateTime>(horaFim.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<String>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<String>(longitude.value);
    }
    if (situacaoTurno.present) {
      map['situacao_turno'] = Variable<String>(
          $TurnoTableTable.$convertersituacaoTurno.toSql(situacaoTurno.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TurnoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('equipeId: $equipeId, ')
          ..write('kmInicial: $kmInicial, ')
          ..write('kmFinal: $kmFinal, ')
          ..write('horaInicio: $horaInicio, ')
          ..write('horaFim: $horaFim, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('situacaoTurno: $situacaoTurno')
          ..write(')'))
        .toString();
  }
}

class $TurnoEletricistasTableTable extends TurnoEletricistasTable
    with TableInfo<$TurnoEletricistasTableTable, TurnoEletricistasTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TurnoEletricistasTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _turnoIdMeta =
      const VerificationMeta('turnoId');
  @override
  late final GeneratedColumn<int> turnoId = GeneratedColumn<int>(
      'turno_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _eletricistaIdMeta =
      const VerificationMeta('eletricistaId');
  @override
  late final GeneratedColumn<int> eletricistaId = GeneratedColumn<int>(
      'eletricista_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _motoristaMeta =
      const VerificationMeta('motorista');
  @override
  late final GeneratedColumn<bool> motorista = GeneratedColumn<bool>(
      'motorista', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("motorista" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, turnoId, eletricistaId, motorista];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'turno_eletricistas_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TurnoEletricistasTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('turno_id')) {
      context.handle(_turnoIdMeta,
          turnoId.isAcceptableOrUnknown(data['turno_id']!, _turnoIdMeta));
    } else if (isInserting) {
      context.missing(_turnoIdMeta);
    }
    if (data.containsKey('eletricista_id')) {
      context.handle(
          _eletricistaIdMeta,
          eletricistaId.isAcceptableOrUnknown(
              data['eletricista_id']!, _eletricistaIdMeta));
    } else if (isInserting) {
      context.missing(_eletricistaIdMeta);
    }
    if (data.containsKey('motorista')) {
      context.handle(_motoristaMeta,
          motorista.isAcceptableOrUnknown(data['motorista']!, _motoristaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TurnoEletricistasTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TurnoEletricistasTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      turnoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}turno_id'])!,
      eletricistaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}eletricista_id'])!,
      motorista: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}motorista'])!,
    );
  }

  @override
  $TurnoEletricistasTableTable createAlias(String alias) {
    return $TurnoEletricistasTableTable(attachedDatabase, alias);
  }
}

class TurnoEletricistasTableData extends DataClass
    implements Insertable<TurnoEletricistasTableData> {
  final int id;
  final int turnoId;
  final int eletricistaId;
  final bool motorista;
  const TurnoEletricistasTableData(
      {required this.id,
      required this.turnoId,
      required this.eletricistaId,
      required this.motorista});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['turno_id'] = Variable<int>(turnoId);
    map['eletricista_id'] = Variable<int>(eletricistaId);
    map['motorista'] = Variable<bool>(motorista);
    return map;
  }

  TurnoEletricistasTableCompanion toCompanion(bool nullToAbsent) {
    return TurnoEletricistasTableCompanion(
      id: Value(id),
      turnoId: Value(turnoId),
      eletricistaId: Value(eletricistaId),
      motorista: Value(motorista),
    );
  }

  factory TurnoEletricistasTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TurnoEletricistasTableData(
      id: serializer.fromJson<int>(json['id']),
      turnoId: serializer.fromJson<int>(json['turnoId']),
      eletricistaId: serializer.fromJson<int>(json['eletricistaId']),
      motorista: serializer.fromJson<bool>(json['motorista']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'turnoId': serializer.toJson<int>(turnoId),
      'eletricistaId': serializer.toJson<int>(eletricistaId),
      'motorista': serializer.toJson<bool>(motorista),
    };
  }

  TurnoEletricistasTableData copyWith(
          {int? id, int? turnoId, int? eletricistaId, bool? motorista}) =>
      TurnoEletricistasTableData(
        id: id ?? this.id,
        turnoId: turnoId ?? this.turnoId,
        eletricistaId: eletricistaId ?? this.eletricistaId,
        motorista: motorista ?? this.motorista,
      );
  TurnoEletricistasTableData copyWithCompanion(
      TurnoEletricistasTableCompanion data) {
    return TurnoEletricistasTableData(
      id: data.id.present ? data.id.value : this.id,
      turnoId: data.turnoId.present ? data.turnoId.value : this.turnoId,
      eletricistaId: data.eletricistaId.present
          ? data.eletricistaId.value
          : this.eletricistaId,
      motorista: data.motorista.present ? data.motorista.value : this.motorista,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TurnoEletricistasTableData(')
          ..write('id: $id, ')
          ..write('turnoId: $turnoId, ')
          ..write('eletricistaId: $eletricistaId, ')
          ..write('motorista: $motorista')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, turnoId, eletricistaId, motorista);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TurnoEletricistasTableData &&
          other.id == this.id &&
          other.turnoId == this.turnoId &&
          other.eletricistaId == this.eletricistaId &&
          other.motorista == this.motorista);
}

class TurnoEletricistasTableCompanion
    extends UpdateCompanion<TurnoEletricistasTableData> {
  final Value<int> id;
  final Value<int> turnoId;
  final Value<int> eletricistaId;
  final Value<bool> motorista;
  const TurnoEletricistasTableCompanion({
    this.id = const Value.absent(),
    this.turnoId = const Value.absent(),
    this.eletricistaId = const Value.absent(),
    this.motorista = const Value.absent(),
  });
  TurnoEletricistasTableCompanion.insert({
    this.id = const Value.absent(),
    required int turnoId,
    required int eletricistaId,
    this.motorista = const Value.absent(),
  })  : turnoId = Value(turnoId),
        eletricistaId = Value(eletricistaId);
  static Insertable<TurnoEletricistasTableData> custom({
    Expression<int>? id,
    Expression<int>? turnoId,
    Expression<int>? eletricistaId,
    Expression<bool>? motorista,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (turnoId != null) 'turno_id': turnoId,
      if (eletricistaId != null) 'eletricista_id': eletricistaId,
      if (motorista != null) 'motorista': motorista,
    });
  }

  TurnoEletricistasTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? turnoId,
      Value<int>? eletricistaId,
      Value<bool>? motorista}) {
    return TurnoEletricistasTableCompanion(
      id: id ?? this.id,
      turnoId: turnoId ?? this.turnoId,
      eletricistaId: eletricistaId ?? this.eletricistaId,
      motorista: motorista ?? this.motorista,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (turnoId.present) {
      map['turno_id'] = Variable<int>(turnoId.value);
    }
    if (eletricistaId.present) {
      map['eletricista_id'] = Variable<int>(eletricistaId.value);
    }
    if (motorista.present) {
      map['motorista'] = Variable<bool>(motorista.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TurnoEletricistasTableCompanion(')
          ..write('id: $id, ')
          ..write('turnoId: $turnoId, ')
          ..write('eletricistaId: $eletricistaId, ')
          ..write('motorista: $motorista')
          ..write(')'))
        .toString();
  }
}

class $ChecklistModeloTableTable extends ChecklistModeloTable
    with TableInfo<$ChecklistModeloTableTable, ChecklistModeloTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistModeloTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tipoChecklistIdMeta =
      const VerificationMeta('tipoChecklistId');
  @override
  late final GeneratedColumn<int> tipoChecklistId = GeneratedColumn<int>(
      'tipo_checklist_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, remoteId, createdAt, updatedAt, sincronizado, nome, tipoChecklistId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_modelo_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistModeloTableData> instance,
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
    if (data.containsKey('tipo_checklist_id')) {
      context.handle(
          _tipoChecklistIdMeta,
          tipoChecklistId.isAcceptableOrUnknown(
              data['tipo_checklist_id']!, _tipoChecklistIdMeta));
    } else if (isInserting) {
      context.missing(_tipoChecklistIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistModeloTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistModeloTableData(
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
      tipoChecklistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo_checklist_id'])!,
    );
  }

  @override
  $ChecklistModeloTableTable createAlias(String alias) {
    return $ChecklistModeloTableTable(attachedDatabase, alias);
  }
}

class ChecklistModeloTableData extends DataClass
    implements Insertable<ChecklistModeloTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String nome;
  final int tipoChecklistId;
  const ChecklistModeloTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.nome,
      required this.tipoChecklistId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['nome'] = Variable<String>(nome);
    map['tipo_checklist_id'] = Variable<int>(tipoChecklistId);
    return map;
  }

  ChecklistModeloTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistModeloTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      nome: Value(nome),
      tipoChecklistId: Value(tipoChecklistId),
    );
  }

  factory ChecklistModeloTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistModeloTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      nome: serializer.fromJson<String>(json['nome']),
      tipoChecklistId: serializer.fromJson<int>(json['tipoChecklistId']),
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
      'tipoChecklistId': serializer.toJson<int>(tipoChecklistId),
    };
  }

  ChecklistModeloTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? nome,
          int? tipoChecklistId}) =>
      ChecklistModeloTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        nome: nome ?? this.nome,
        tipoChecklistId: tipoChecklistId ?? this.tipoChecklistId,
      );
  ChecklistModeloTableData copyWithCompanion(
      ChecklistModeloTableCompanion data) {
    return ChecklistModeloTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      nome: data.nome.present ? data.nome.value : this.nome,
      tipoChecklistId: data.tipoChecklistId.present
          ? data.tipoChecklistId.value
          : this.tipoChecklistId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistModeloTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('tipoChecklistId: $tipoChecklistId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, remoteId, createdAt, updatedAt, sincronizado, nome, tipoChecklistId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistModeloTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.nome == this.nome &&
          other.tipoChecklistId == this.tipoChecklistId);
}

class ChecklistModeloTableCompanion
    extends UpdateCompanion<ChecklistModeloTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> nome;
  final Value<int> tipoChecklistId;
  const ChecklistModeloTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.nome = const Value.absent(),
    this.tipoChecklistId = const Value.absent(),
  });
  ChecklistModeloTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required String nome,
    required int tipoChecklistId,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        nome = Value(nome),
        tipoChecklistId = Value(tipoChecklistId);
  static Insertable<ChecklistModeloTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<String>? nome,
    Expression<int>? tipoChecklistId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (nome != null) 'nome': nome,
      if (tipoChecklistId != null) 'tipo_checklist_id': tipoChecklistId,
    });
  }

  ChecklistModeloTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? nome,
      Value<int>? tipoChecklistId}) {
    return ChecklistModeloTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      nome: nome ?? this.nome,
      tipoChecklistId: tipoChecklistId ?? this.tipoChecklistId,
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
    if (tipoChecklistId.present) {
      map['tipo_checklist_id'] = Variable<int>(tipoChecklistId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistModeloTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('tipoChecklistId: $tipoChecklistId')
          ..write(')'))
        .toString();
  }
}

class $ChecklistPerguntaTableTable extends ChecklistPerguntaTable
    with TableInfo<$ChecklistPerguntaTableTable, ChecklistPerguntaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistPerguntaTableTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'checklist_pergunta_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistPerguntaTableData> instance,
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
  ChecklistPerguntaTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistPerguntaTableData(
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
  $ChecklistPerguntaTableTable createAlias(String alias) {
    return $ChecklistPerguntaTableTable(attachedDatabase, alias);
  }
}

class ChecklistPerguntaTableData extends DataClass
    implements Insertable<ChecklistPerguntaTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String nome;
  const ChecklistPerguntaTableData(
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

  ChecklistPerguntaTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistPerguntaTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      nome: Value(nome),
    );
  }

  factory ChecklistPerguntaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistPerguntaTableData(
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

  ChecklistPerguntaTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? nome}) =>
      ChecklistPerguntaTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        nome: nome ?? this.nome,
      );
  ChecklistPerguntaTableData copyWithCompanion(
      ChecklistPerguntaTableCompanion data) {
    return ChecklistPerguntaTableData(
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
    return (StringBuffer('ChecklistPerguntaTableData(')
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
      (other is ChecklistPerguntaTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.nome == this.nome);
}

class ChecklistPerguntaTableCompanion
    extends UpdateCompanion<ChecklistPerguntaTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> nome;
  const ChecklistPerguntaTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.nome = const Value.absent(),
  });
  ChecklistPerguntaTableCompanion.insert({
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
  static Insertable<ChecklistPerguntaTableData> custom({
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

  ChecklistPerguntaTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? nome}) {
    return ChecklistPerguntaTableCompanion(
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
    return (StringBuffer('ChecklistPerguntaTableCompanion(')
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

class $ChecklistOpcaoRespostaTableTable extends ChecklistOpcaoRespostaTable
    with
        TableInfo<$ChecklistOpcaoRespostaTableTable,
            ChecklistOpcaoRespostaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistOpcaoRespostaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _geraPendenciaMeta =
      const VerificationMeta('geraPendencia');
  @override
  late final GeneratedColumn<bool> geraPendencia = GeneratedColumn<bool>(
      'gera_pendencia', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("gera_pendencia" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, remoteId, createdAt, updatedAt, sincronizado, nome, geraPendencia];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_opcao_resposta_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistOpcaoRespostaTableData> instance,
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
    if (data.containsKey('gera_pendencia')) {
      context.handle(
          _geraPendenciaMeta,
          geraPendencia.isAcceptableOrUnknown(
              data['gera_pendencia']!, _geraPendenciaMeta));
    } else if (isInserting) {
      context.missing(_geraPendenciaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistOpcaoRespostaTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistOpcaoRespostaTableData(
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
      geraPendencia: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}gera_pendencia'])!,
    );
  }

  @override
  $ChecklistOpcaoRespostaTableTable createAlias(String alias) {
    return $ChecklistOpcaoRespostaTableTable(attachedDatabase, alias);
  }
}

class ChecklistOpcaoRespostaTableData extends DataClass
    implements Insertable<ChecklistOpcaoRespostaTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final String nome;
  final bool geraPendencia;
  const ChecklistOpcaoRespostaTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.nome,
      required this.geraPendencia});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['nome'] = Variable<String>(nome);
    map['gera_pendencia'] = Variable<bool>(geraPendencia);
    return map;
  }

  ChecklistOpcaoRespostaTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistOpcaoRespostaTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      nome: Value(nome),
      geraPendencia: Value(geraPendencia),
    );
  }

  factory ChecklistOpcaoRespostaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistOpcaoRespostaTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      nome: serializer.fromJson<String>(json['nome']),
      geraPendencia: serializer.fromJson<bool>(json['geraPendencia']),
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
      'geraPendencia': serializer.toJson<bool>(geraPendencia),
    };
  }

  ChecklistOpcaoRespostaTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          String? nome,
          bool? geraPendencia}) =>
      ChecklistOpcaoRespostaTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        nome: nome ?? this.nome,
        geraPendencia: geraPendencia ?? this.geraPendencia,
      );
  ChecklistOpcaoRespostaTableData copyWithCompanion(
      ChecklistOpcaoRespostaTableCompanion data) {
    return ChecklistOpcaoRespostaTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      nome: data.nome.present ? data.nome.value : this.nome,
      geraPendencia: data.geraPendencia.present
          ? data.geraPendencia.value
          : this.geraPendencia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistOpcaoRespostaTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('geraPendencia: $geraPendencia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, remoteId, createdAt, updatedAt, sincronizado, nome, geraPendencia);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistOpcaoRespostaTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.nome == this.nome &&
          other.geraPendencia == this.geraPendencia);
}

class ChecklistOpcaoRespostaTableCompanion
    extends UpdateCompanion<ChecklistOpcaoRespostaTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<String> nome;
  final Value<bool> geraPendencia;
  const ChecklistOpcaoRespostaTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.nome = const Value.absent(),
    this.geraPendencia = const Value.absent(),
  });
  ChecklistOpcaoRespostaTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required String nome,
    required bool geraPendencia,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        nome = Value(nome),
        geraPendencia = Value(geraPendencia);
  static Insertable<ChecklistOpcaoRespostaTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<String>? nome,
    Expression<bool>? geraPendencia,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (nome != null) 'nome': nome,
      if (geraPendencia != null) 'gera_pendencia': geraPendencia,
    });
  }

  ChecklistOpcaoRespostaTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<String>? nome,
      Value<bool>? geraPendencia}) {
    return ChecklistOpcaoRespostaTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      nome: nome ?? this.nome,
      geraPendencia: geraPendencia ?? this.geraPendencia,
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
    if (geraPendencia.present) {
      map['gera_pendencia'] = Variable<bool>(geraPendencia.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistOpcaoRespostaTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('nome: $nome, ')
          ..write('geraPendencia: $geraPendencia')
          ..write(')'))
        .toString();
  }
}

class $ChecklistOpcaoRespostaRelacaoTableTable
    extends ChecklistOpcaoRespostaRelacaoTable
    with
        TableInfo<$ChecklistOpcaoRespostaRelacaoTableTable,
            ChecklistOpcaoRespostaRelacaoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistOpcaoRespostaRelacaoTableTable(this.attachedDatabase,
      [this._alias]);
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
  static const VerificationMeta _checklistOpcaoRespostaIdMeta =
      const VerificationMeta('checklistOpcaoRespostaId');
  @override
  late final GeneratedColumn<int> checklistOpcaoRespostaId =
      GeneratedColumn<int>('checklist_opcao_resposta_id', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checklistModeloIdMeta =
      const VerificationMeta('checklistModeloId');
  @override
  late final GeneratedColumn<int> checklistModeloId = GeneratedColumn<int>(
      'checklist_modelo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        createdAt,
        updatedAt,
        sincronizado,
        checklistOpcaoRespostaId,
        checklistModeloId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_opcao_resposta_relacao_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistOpcaoRespostaRelacaoTableData> instance,
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
    if (data.containsKey('checklist_opcao_resposta_id')) {
      context.handle(
          _checklistOpcaoRespostaIdMeta,
          checklistOpcaoRespostaId.isAcceptableOrUnknown(
              data['checklist_opcao_resposta_id']!,
              _checklistOpcaoRespostaIdMeta));
    } else if (isInserting) {
      context.missing(_checklistOpcaoRespostaIdMeta);
    }
    if (data.containsKey('checklist_modelo_id')) {
      context.handle(
          _checklistModeloIdMeta,
          checklistModeloId.isAcceptableOrUnknown(
              data['checklist_modelo_id']!, _checklistModeloIdMeta));
    } else if (isInserting) {
      context.missing(_checklistModeloIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistOpcaoRespostaRelacaoTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistOpcaoRespostaRelacaoTableData(
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
      checklistOpcaoRespostaId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}checklist_opcao_resposta_id'])!,
      checklistModeloId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}checklist_modelo_id'])!,
    );
  }

  @override
  $ChecklistOpcaoRespostaRelacaoTableTable createAlias(String alias) {
    return $ChecklistOpcaoRespostaRelacaoTableTable(attachedDatabase, alias);
  }
}

class ChecklistOpcaoRespostaRelacaoTableData extends DataClass
    implements Insertable<ChecklistOpcaoRespostaRelacaoTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final int checklistOpcaoRespostaId;
  final int checklistModeloId;
  const ChecklistOpcaoRespostaRelacaoTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.checklistOpcaoRespostaId,
      required this.checklistModeloId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['checklist_opcao_resposta_id'] =
        Variable<int>(checklistOpcaoRespostaId);
    map['checklist_modelo_id'] = Variable<int>(checklistModeloId);
    return map;
  }

  ChecklistOpcaoRespostaRelacaoTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistOpcaoRespostaRelacaoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      checklistOpcaoRespostaId: Value(checklistOpcaoRespostaId),
      checklistModeloId: Value(checklistModeloId),
    );
  }

  factory ChecklistOpcaoRespostaRelacaoTableData.fromJson(
      Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistOpcaoRespostaRelacaoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      checklistOpcaoRespostaId:
          serializer.fromJson<int>(json['checklistOpcaoRespostaId']),
      checklistModeloId: serializer.fromJson<int>(json['checklistModeloId']),
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
      'checklistOpcaoRespostaId':
          serializer.toJson<int>(checklistOpcaoRespostaId),
      'checklistModeloId': serializer.toJson<int>(checklistModeloId),
    };
  }

  ChecklistOpcaoRespostaRelacaoTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          int? checklistOpcaoRespostaId,
          int? checklistModeloId}) =>
      ChecklistOpcaoRespostaRelacaoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        checklistOpcaoRespostaId:
            checklistOpcaoRespostaId ?? this.checklistOpcaoRespostaId,
        checklistModeloId: checklistModeloId ?? this.checklistModeloId,
      );
  ChecklistOpcaoRespostaRelacaoTableData copyWithCompanion(
      ChecklistOpcaoRespostaRelacaoTableCompanion data) {
    return ChecklistOpcaoRespostaRelacaoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      checklistOpcaoRespostaId: data.checklistOpcaoRespostaId.present
          ? data.checklistOpcaoRespostaId.value
          : this.checklistOpcaoRespostaId,
      checklistModeloId: data.checklistModeloId.present
          ? data.checklistModeloId.value
          : this.checklistModeloId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistOpcaoRespostaRelacaoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistOpcaoRespostaId: $checklistOpcaoRespostaId, ')
          ..write('checklistModeloId: $checklistModeloId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, createdAt, updatedAt,
      sincronizado, checklistOpcaoRespostaId, checklistModeloId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistOpcaoRespostaRelacaoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.checklistOpcaoRespostaId == this.checklistOpcaoRespostaId &&
          other.checklistModeloId == this.checklistModeloId);
}

class ChecklistOpcaoRespostaRelacaoTableCompanion
    extends UpdateCompanion<ChecklistOpcaoRespostaRelacaoTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<int> checklistOpcaoRespostaId;
  final Value<int> checklistModeloId;
  const ChecklistOpcaoRespostaRelacaoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.checklistOpcaoRespostaId = const Value.absent(),
    this.checklistModeloId = const Value.absent(),
  });
  ChecklistOpcaoRespostaRelacaoTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required int checklistOpcaoRespostaId,
    required int checklistModeloId,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        checklistOpcaoRespostaId = Value(checklistOpcaoRespostaId),
        checklistModeloId = Value(checklistModeloId);
  static Insertable<ChecklistOpcaoRespostaRelacaoTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<int>? checklistOpcaoRespostaId,
    Expression<int>? checklistModeloId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (checklistOpcaoRespostaId != null)
        'checklist_opcao_resposta_id': checklistOpcaoRespostaId,
      if (checklistModeloId != null) 'checklist_modelo_id': checklistModeloId,
    });
  }

  ChecklistOpcaoRespostaRelacaoTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<int>? checklistOpcaoRespostaId,
      Value<int>? checklistModeloId}) {
    return ChecklistOpcaoRespostaRelacaoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      checklistOpcaoRespostaId:
          checklistOpcaoRespostaId ?? this.checklistOpcaoRespostaId,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
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
    if (checklistOpcaoRespostaId.present) {
      map['checklist_opcao_resposta_id'] =
          Variable<int>(checklistOpcaoRespostaId.value);
    }
    if (checklistModeloId.present) {
      map['checklist_modelo_id'] = Variable<int>(checklistModeloId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistOpcaoRespostaRelacaoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistOpcaoRespostaId: $checklistOpcaoRespostaId, ')
          ..write('checklistModeloId: $checklistModeloId')
          ..write(')'))
        .toString();
  }
}

class $ChecklistPerguntaRelacaoTableTable extends ChecklistPerguntaRelacaoTable
    with
        TableInfo<$ChecklistPerguntaRelacaoTableTable,
            ChecklistPerguntaRelacaoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistPerguntaRelacaoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _checklistModeloIdMeta =
      const VerificationMeta('checklistModeloId');
  @override
  late final GeneratedColumn<int> checklistModeloId = GeneratedColumn<int>(
      'checklist_modelo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checklistPerguntaIdMeta =
      const VerificationMeta('checklistPerguntaId');
  @override
  late final GeneratedColumn<int> checklistPerguntaId = GeneratedColumn<int>(
      'checklist_pergunta_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        createdAt,
        updatedAt,
        sincronizado,
        checklistModeloId,
        checklistPerguntaId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_pergunta_relacao_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistPerguntaRelacaoTableData> instance,
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
    if (data.containsKey('checklist_modelo_id')) {
      context.handle(
          _checklistModeloIdMeta,
          checklistModeloId.isAcceptableOrUnknown(
              data['checklist_modelo_id']!, _checklistModeloIdMeta));
    } else if (isInserting) {
      context.missing(_checklistModeloIdMeta);
    }
    if (data.containsKey('checklist_pergunta_id')) {
      context.handle(
          _checklistPerguntaIdMeta,
          checklistPerguntaId.isAcceptableOrUnknown(
              data['checklist_pergunta_id']!, _checklistPerguntaIdMeta));
    } else if (isInserting) {
      context.missing(_checklistPerguntaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistPerguntaRelacaoTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistPerguntaRelacaoTableData(
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
      checklistModeloId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}checklist_modelo_id'])!,
      checklistPerguntaId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}checklist_pergunta_id'])!,
    );
  }

  @override
  $ChecklistPerguntaRelacaoTableTable createAlias(String alias) {
    return $ChecklistPerguntaRelacaoTableTable(attachedDatabase, alias);
  }
}

class ChecklistPerguntaRelacaoTableData extends DataClass
    implements Insertable<ChecklistPerguntaRelacaoTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final int checklistModeloId;
  final int checklistPerguntaId;
  const ChecklistPerguntaRelacaoTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.checklistModeloId,
      required this.checklistPerguntaId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['checklist_modelo_id'] = Variable<int>(checklistModeloId);
    map['checklist_pergunta_id'] = Variable<int>(checklistPerguntaId);
    return map;
  }

  ChecklistPerguntaRelacaoTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistPerguntaRelacaoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      checklistModeloId: Value(checklistModeloId),
      checklistPerguntaId: Value(checklistPerguntaId),
    );
  }

  factory ChecklistPerguntaRelacaoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistPerguntaRelacaoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      checklistModeloId: serializer.fromJson<int>(json['checklistModeloId']),
      checklistPerguntaId:
          serializer.fromJson<int>(json['checklistPerguntaId']),
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
      'checklistModeloId': serializer.toJson<int>(checklistModeloId),
      'checklistPerguntaId': serializer.toJson<int>(checklistPerguntaId),
    };
  }

  ChecklistPerguntaRelacaoTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          int? checklistModeloId,
          int? checklistPerguntaId}) =>
      ChecklistPerguntaRelacaoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        checklistModeloId: checklistModeloId ?? this.checklistModeloId,
        checklistPerguntaId: checklistPerguntaId ?? this.checklistPerguntaId,
      );
  ChecklistPerguntaRelacaoTableData copyWithCompanion(
      ChecklistPerguntaRelacaoTableCompanion data) {
    return ChecklistPerguntaRelacaoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      checklistModeloId: data.checklistModeloId.present
          ? data.checklistModeloId.value
          : this.checklistModeloId,
      checklistPerguntaId: data.checklistPerguntaId.present
          ? data.checklistPerguntaId.value
          : this.checklistPerguntaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistPerguntaRelacaoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('checklistPerguntaId: $checklistPerguntaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, createdAt, updatedAt,
      sincronizado, checklistModeloId, checklistPerguntaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistPerguntaRelacaoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.checklistModeloId == this.checklistModeloId &&
          other.checklistPerguntaId == this.checklistPerguntaId);
}

class ChecklistPerguntaRelacaoTableCompanion
    extends UpdateCompanion<ChecklistPerguntaRelacaoTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<int> checklistModeloId;
  final Value<int> checklistPerguntaId;
  const ChecklistPerguntaRelacaoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.checklistModeloId = const Value.absent(),
    this.checklistPerguntaId = const Value.absent(),
  });
  ChecklistPerguntaRelacaoTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required int checklistModeloId,
    required int checklistPerguntaId,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        checklistModeloId = Value(checklistModeloId),
        checklistPerguntaId = Value(checklistPerguntaId);
  static Insertable<ChecklistPerguntaRelacaoTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<int>? checklistModeloId,
    Expression<int>? checklistPerguntaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (checklistModeloId != null) 'checklist_modelo_id': checklistModeloId,
      if (checklistPerguntaId != null)
        'checklist_pergunta_id': checklistPerguntaId,
    });
  }

  ChecklistPerguntaRelacaoTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<int>? checklistModeloId,
      Value<int>? checklistPerguntaId}) {
    return ChecklistPerguntaRelacaoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
      checklistPerguntaId: checklistPerguntaId ?? this.checklistPerguntaId,
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
    if (checklistModeloId.present) {
      map['checklist_modelo_id'] = Variable<int>(checklistModeloId.value);
    }
    if (checklistPerguntaId.present) {
      map['checklist_pergunta_id'] = Variable<int>(checklistPerguntaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistPerguntaRelacaoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('checklistPerguntaId: $checklistPerguntaId')
          ..write(')'))
        .toString();
  }
}

class $ChecklistTipoEquipeRelacaoTableTable
    extends ChecklistTipoEquipeRelacaoTable
    with
        TableInfo<$ChecklistTipoEquipeRelacaoTableTable,
            ChecklistTipoEquipeRelacaoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistTipoEquipeRelacaoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _checklistModeloIdMeta =
      const VerificationMeta('checklistModeloId');
  @override
  late final GeneratedColumn<int> checklistModeloId = GeneratedColumn<int>(
      'checklist_modelo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
        checklistModeloId,
        tipoEquipeId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_tipo_equipe_relacao_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistTipoEquipeRelacaoTableData> instance,
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
    if (data.containsKey('checklist_modelo_id')) {
      context.handle(
          _checklistModeloIdMeta,
          checklistModeloId.isAcceptableOrUnknown(
              data['checklist_modelo_id']!, _checklistModeloIdMeta));
    } else if (isInserting) {
      context.missing(_checklistModeloIdMeta);
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
  ChecklistTipoEquipeRelacaoTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistTipoEquipeRelacaoTableData(
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
      checklistModeloId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}checklist_modelo_id'])!,
      tipoEquipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo_equipe_id'])!,
    );
  }

  @override
  $ChecklistTipoEquipeRelacaoTableTable createAlias(String alias) {
    return $ChecklistTipoEquipeRelacaoTableTable(attachedDatabase, alias);
  }
}

class ChecklistTipoEquipeRelacaoTableData extends DataClass
    implements Insertable<ChecklistTipoEquipeRelacaoTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final int checklistModeloId;
  final int tipoEquipeId;
  const ChecklistTipoEquipeRelacaoTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.checklistModeloId,
      required this.tipoEquipeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['checklist_modelo_id'] = Variable<int>(checklistModeloId);
    map['tipo_equipe_id'] = Variable<int>(tipoEquipeId);
    return map;
  }

  ChecklistTipoEquipeRelacaoTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistTipoEquipeRelacaoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      checklistModeloId: Value(checklistModeloId),
      tipoEquipeId: Value(tipoEquipeId),
    );
  }

  factory ChecklistTipoEquipeRelacaoTableData.fromJson(
      Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistTipoEquipeRelacaoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      checklistModeloId: serializer.fromJson<int>(json['checklistModeloId']),
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
      'checklistModeloId': serializer.toJson<int>(checklistModeloId),
      'tipoEquipeId': serializer.toJson<int>(tipoEquipeId),
    };
  }

  ChecklistTipoEquipeRelacaoTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          int? checklistModeloId,
          int? tipoEquipeId}) =>
      ChecklistTipoEquipeRelacaoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        checklistModeloId: checklistModeloId ?? this.checklistModeloId,
        tipoEquipeId: tipoEquipeId ?? this.tipoEquipeId,
      );
  ChecklistTipoEquipeRelacaoTableData copyWithCompanion(
      ChecklistTipoEquipeRelacaoTableCompanion data) {
    return ChecklistTipoEquipeRelacaoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      checklistModeloId: data.checklistModeloId.present
          ? data.checklistModeloId.value
          : this.checklistModeloId,
      tipoEquipeId: data.tipoEquipeId.present
          ? data.tipoEquipeId.value
          : this.tipoEquipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistTipoEquipeRelacaoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('tipoEquipeId: $tipoEquipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, createdAt, updatedAt,
      sincronizado, checklistModeloId, tipoEquipeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistTipoEquipeRelacaoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.checklistModeloId == this.checklistModeloId &&
          other.tipoEquipeId == this.tipoEquipeId);
}

class ChecklistTipoEquipeRelacaoTableCompanion
    extends UpdateCompanion<ChecklistTipoEquipeRelacaoTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<int> checklistModeloId;
  final Value<int> tipoEquipeId;
  const ChecklistTipoEquipeRelacaoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.checklistModeloId = const Value.absent(),
    this.tipoEquipeId = const Value.absent(),
  });
  ChecklistTipoEquipeRelacaoTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required int checklistModeloId,
    required int tipoEquipeId,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        checklistModeloId = Value(checklistModeloId),
        tipoEquipeId = Value(tipoEquipeId);
  static Insertable<ChecklistTipoEquipeRelacaoTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<int>? checklistModeloId,
    Expression<int>? tipoEquipeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (checklistModeloId != null) 'checklist_modelo_id': checklistModeloId,
      if (tipoEquipeId != null) 'tipo_equipe_id': tipoEquipeId,
    });
  }

  ChecklistTipoEquipeRelacaoTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<int>? checklistModeloId,
      Value<int>? tipoEquipeId}) {
    return ChecklistTipoEquipeRelacaoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
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
    if (checklistModeloId.present) {
      map['checklist_modelo_id'] = Variable<int>(checklistModeloId.value);
    }
    if (tipoEquipeId.present) {
      map['tipo_equipe_id'] = Variable<int>(tipoEquipeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistTipoEquipeRelacaoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('tipoEquipeId: $tipoEquipeId')
          ..write(')'))
        .toString();
  }
}

class $ChecklistTipoVeiculoRelacaoTableTable
    extends ChecklistTipoVeiculoRelacaoTable
    with
        TableInfo<$ChecklistTipoVeiculoRelacaoTableTable,
            ChecklistTipoVeiculoRelacaoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistTipoVeiculoRelacaoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _checklistModeloIdMeta =
      const VerificationMeta('checklistModeloId');
  @override
  late final GeneratedColumn<int> checklistModeloId = GeneratedColumn<int>(
      'checklist_modelo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tipoVeiculoIdMeta =
      const VerificationMeta('tipoVeiculoId');
  @override
  late final GeneratedColumn<int> tipoVeiculoId = GeneratedColumn<int>(
      'tipo_veiculo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        createdAt,
        updatedAt,
        sincronizado,
        checklistModeloId,
        tipoVeiculoId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_tipo_veiculo_relacao_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistTipoVeiculoRelacaoTableData> instance,
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
    if (data.containsKey('checklist_modelo_id')) {
      context.handle(
          _checklistModeloIdMeta,
          checklistModeloId.isAcceptableOrUnknown(
              data['checklist_modelo_id']!, _checklistModeloIdMeta));
    } else if (isInserting) {
      context.missing(_checklistModeloIdMeta);
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
  ChecklistTipoVeiculoRelacaoTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistTipoVeiculoRelacaoTableData(
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
      checklistModeloId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}checklist_modelo_id'])!,
      tipoVeiculoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo_veiculo_id'])!,
    );
  }

  @override
  $ChecklistTipoVeiculoRelacaoTableTable createAlias(String alias) {
    return $ChecklistTipoVeiculoRelacaoTableTable(attachedDatabase, alias);
  }
}

class ChecklistTipoVeiculoRelacaoTableData extends DataClass
    implements Insertable<ChecklistTipoVeiculoRelacaoTableData> {
  final int id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;
  final int checklistModeloId;
  final int tipoVeiculoId;
  const ChecklistTipoVeiculoRelacaoTableData(
      {required this.id,
      required this.remoteId,
      required this.createdAt,
      required this.updatedAt,
      required this.sincronizado,
      required this.checklistModeloId,
      required this.tipoVeiculoId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<int>(remoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['checklist_modelo_id'] = Variable<int>(checklistModeloId);
    map['tipo_veiculo_id'] = Variable<int>(tipoVeiculoId);
    return map;
  }

  ChecklistTipoVeiculoRelacaoTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistTipoVeiculoRelacaoTableCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
      checklistModeloId: Value(checklistModeloId),
      tipoVeiculoId: Value(tipoVeiculoId),
    );
  }

  factory ChecklistTipoVeiculoRelacaoTableData.fromJson(
      Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistTipoVeiculoRelacaoTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      checklistModeloId: serializer.fromJson<int>(json['checklistModeloId']),
      tipoVeiculoId: serializer.fromJson<int>(json['tipoVeiculoId']),
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
      'checklistModeloId': serializer.toJson<int>(checklistModeloId),
      'tipoVeiculoId': serializer.toJson<int>(tipoVeiculoId),
    };
  }

  ChecklistTipoVeiculoRelacaoTableData copyWith(
          {int? id,
          int? remoteId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? sincronizado,
          int? checklistModeloId,
          int? tipoVeiculoId}) =>
      ChecklistTipoVeiculoRelacaoTableData(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sincronizado: sincronizado ?? this.sincronizado,
        checklistModeloId: checklistModeloId ?? this.checklistModeloId,
        tipoVeiculoId: tipoVeiculoId ?? this.tipoVeiculoId,
      );
  ChecklistTipoVeiculoRelacaoTableData copyWithCompanion(
      ChecklistTipoVeiculoRelacaoTableCompanion data) {
    return ChecklistTipoVeiculoRelacaoTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      checklistModeloId: data.checklistModeloId.present
          ? data.checklistModeloId.value
          : this.checklistModeloId,
      tipoVeiculoId: data.tipoVeiculoId.present
          ? data.tipoVeiculoId.value
          : this.tipoVeiculoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistTipoVeiculoRelacaoTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('tipoVeiculoId: $tipoVeiculoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, createdAt, updatedAt,
      sincronizado, checklistModeloId, tipoVeiculoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistTipoVeiculoRelacaoTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sincronizado == this.sincronizado &&
          other.checklistModeloId == this.checklistModeloId &&
          other.tipoVeiculoId == this.tipoVeiculoId);
}

class ChecklistTipoVeiculoRelacaoTableCompanion
    extends UpdateCompanion<ChecklistTipoVeiculoRelacaoTableData> {
  final Value<int> id;
  final Value<int> remoteId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> sincronizado;
  final Value<int> checklistModeloId;
  final Value<int> tipoVeiculoId;
  const ChecklistTipoVeiculoRelacaoTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.checklistModeloId = const Value.absent(),
    this.tipoVeiculoId = const Value.absent(),
  });
  ChecklistTipoVeiculoRelacaoTableCompanion.insert({
    this.id = const Value.absent(),
    required int remoteId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sincronizado = const Value.absent(),
    required int checklistModeloId,
    required int tipoVeiculoId,
  })  : remoteId = Value(remoteId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        checklistModeloId = Value(checklistModeloId),
        tipoVeiculoId = Value(tipoVeiculoId);
  static Insertable<ChecklistTipoVeiculoRelacaoTableData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? sincronizado,
    Expression<int>? checklistModeloId,
    Expression<int>? tipoVeiculoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (checklistModeloId != null) 'checklist_modelo_id': checklistModeloId,
      if (tipoVeiculoId != null) 'tipo_veiculo_id': tipoVeiculoId,
    });
  }

  ChecklistTipoVeiculoRelacaoTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? remoteId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? sincronizado,
      Value<int>? checklistModeloId,
      Value<int>? tipoVeiculoId}) {
    return ChecklistTipoVeiculoRelacaoTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
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
    if (checklistModeloId.present) {
      map['checklist_modelo_id'] = Variable<int>(checklistModeloId.value);
    }
    if (tipoVeiculoId.present) {
      map['tipo_veiculo_id'] = Variable<int>(tipoVeiculoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistTipoVeiculoRelacaoTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('tipoVeiculoId: $tipoVeiculoId')
          ..write(')'))
        .toString();
  }
}

class $ChecklistPreenchidoTableTable extends ChecklistPreenchidoTable
    with
        TableInfo<$ChecklistPreenchidoTableTable,
            ChecklistPreenchidoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistPreenchidoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _turnoIdMeta =
      const VerificationMeta('turnoId');
  @override
  late final GeneratedColumn<int> turnoId = GeneratedColumn<int>(
      'turno_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checklistModeloIdMeta =
      const VerificationMeta('checklistModeloId');
  @override
  late final GeneratedColumn<int> checklistModeloId = GeneratedColumn<int>(
      'checklist_modelo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dataPreenchimentoMeta =
      const VerificationMeta('dataPreenchimento');
  @override
  late final GeneratedColumn<DateTime> dataPreenchimento =
      GeneratedColumn<DateTime>('data_preenchimento', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, turnoId, checklistModeloId, latitude, longitude, dataPreenchimento];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_preenchido_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistPreenchidoTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('turno_id')) {
      context.handle(_turnoIdMeta,
          turnoId.isAcceptableOrUnknown(data['turno_id']!, _turnoIdMeta));
    } else if (isInserting) {
      context.missing(_turnoIdMeta);
    }
    if (data.containsKey('checklist_modelo_id')) {
      context.handle(
          _checklistModeloIdMeta,
          checklistModeloId.isAcceptableOrUnknown(
              data['checklist_modelo_id']!, _checklistModeloIdMeta));
    } else if (isInserting) {
      context.missing(_checklistModeloIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('data_preenchimento')) {
      context.handle(
          _dataPreenchimentoMeta,
          dataPreenchimento.isAcceptableOrUnknown(
              data['data_preenchimento']!, _dataPreenchimentoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistPreenchidoTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistPreenchidoTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      turnoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}turno_id'])!,
      checklistModeloId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}checklist_modelo_id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      dataPreenchimento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_preenchimento'])!,
    );
  }

  @override
  $ChecklistPreenchidoTableTable createAlias(String alias) {
    return $ChecklistPreenchidoTableTable(attachedDatabase, alias);
  }
}

class ChecklistPreenchidoTableData extends DataClass
    implements Insertable<ChecklistPreenchidoTableData> {
  /// ID local (autoincrement)
  final int id;

  /// ID local do turno
  final int turnoId;

  /// ID remoto do modelo de checklist
  final int checklistModeloId;

  /// Latitude do preenchimento (opcional)
  final double? latitude;

  /// Longitude do preenchimento (opcional)
  final double? longitude;

  /// Data e hora do preenchimento
  final DateTime dataPreenchimento;
  const ChecklistPreenchidoTableData(
      {required this.id,
      required this.turnoId,
      required this.checklistModeloId,
      this.latitude,
      this.longitude,
      required this.dataPreenchimento});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['turno_id'] = Variable<int>(turnoId);
    map['checklist_modelo_id'] = Variable<int>(checklistModeloId);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['data_preenchimento'] = Variable<DateTime>(dataPreenchimento);
    return map;
  }

  ChecklistPreenchidoTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistPreenchidoTableCompanion(
      id: Value(id),
      turnoId: Value(turnoId),
      checklistModeloId: Value(checklistModeloId),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      dataPreenchimento: Value(dataPreenchimento),
    );
  }

  factory ChecklistPreenchidoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistPreenchidoTableData(
      id: serializer.fromJson<int>(json['id']),
      turnoId: serializer.fromJson<int>(json['turnoId']),
      checklistModeloId: serializer.fromJson<int>(json['checklistModeloId']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      dataPreenchimento:
          serializer.fromJson<DateTime>(json['dataPreenchimento']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'turnoId': serializer.toJson<int>(turnoId),
      'checklistModeloId': serializer.toJson<int>(checklistModeloId),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'dataPreenchimento': serializer.toJson<DateTime>(dataPreenchimento),
    };
  }

  ChecklistPreenchidoTableData copyWith(
          {int? id,
          int? turnoId,
          int? checklistModeloId,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          DateTime? dataPreenchimento}) =>
      ChecklistPreenchidoTableData(
        id: id ?? this.id,
        turnoId: turnoId ?? this.turnoId,
        checklistModeloId: checklistModeloId ?? this.checklistModeloId,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        dataPreenchimento: dataPreenchimento ?? this.dataPreenchimento,
      );
  ChecklistPreenchidoTableData copyWithCompanion(
      ChecklistPreenchidoTableCompanion data) {
    return ChecklistPreenchidoTableData(
      id: data.id.present ? data.id.value : this.id,
      turnoId: data.turnoId.present ? data.turnoId.value : this.turnoId,
      checklistModeloId: data.checklistModeloId.present
          ? data.checklistModeloId.value
          : this.checklistModeloId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      dataPreenchimento: data.dataPreenchimento.present
          ? data.dataPreenchimento.value
          : this.dataPreenchimento,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistPreenchidoTableData(')
          ..write('id: $id, ')
          ..write('turnoId: $turnoId, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('dataPreenchimento: $dataPreenchimento')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, turnoId, checklistModeloId, latitude, longitude, dataPreenchimento);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistPreenchidoTableData &&
          other.id == this.id &&
          other.turnoId == this.turnoId &&
          other.checklistModeloId == this.checklistModeloId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.dataPreenchimento == this.dataPreenchimento);
}

class ChecklistPreenchidoTableCompanion
    extends UpdateCompanion<ChecklistPreenchidoTableData> {
  final Value<int> id;
  final Value<int> turnoId;
  final Value<int> checklistModeloId;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<DateTime> dataPreenchimento;
  const ChecklistPreenchidoTableCompanion({
    this.id = const Value.absent(),
    this.turnoId = const Value.absent(),
    this.checklistModeloId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.dataPreenchimento = const Value.absent(),
  });
  ChecklistPreenchidoTableCompanion.insert({
    this.id = const Value.absent(),
    required int turnoId,
    required int checklistModeloId,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.dataPreenchimento = const Value.absent(),
  })  : turnoId = Value(turnoId),
        checklistModeloId = Value(checklistModeloId);
  static Insertable<ChecklistPreenchidoTableData> custom({
    Expression<int>? id,
    Expression<int>? turnoId,
    Expression<int>? checklistModeloId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? dataPreenchimento,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (turnoId != null) 'turno_id': turnoId,
      if (checklistModeloId != null) 'checklist_modelo_id': checklistModeloId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (dataPreenchimento != null) 'data_preenchimento': dataPreenchimento,
    });
  }

  ChecklistPreenchidoTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? turnoId,
      Value<int>? checklistModeloId,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<DateTime>? dataPreenchimento}) {
    return ChecklistPreenchidoTableCompanion(
      id: id ?? this.id,
      turnoId: turnoId ?? this.turnoId,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dataPreenchimento: dataPreenchimento ?? this.dataPreenchimento,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (turnoId.present) {
      map['turno_id'] = Variable<int>(turnoId.value);
    }
    if (checklistModeloId.present) {
      map['checklist_modelo_id'] = Variable<int>(checklistModeloId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (dataPreenchimento.present) {
      map['data_preenchimento'] = Variable<DateTime>(dataPreenchimento.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistPreenchidoTableCompanion(')
          ..write('id: $id, ')
          ..write('turnoId: $turnoId, ')
          ..write('checklistModeloId: $checklistModeloId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('dataPreenchimento: $dataPreenchimento')
          ..write(')'))
        .toString();
  }
}

class $ChecklistRespostaTableTable extends ChecklistRespostaTable
    with TableInfo<$ChecklistRespostaTableTable, ChecklistRespostaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistRespostaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _checklistPreenchidoIdMeta =
      const VerificationMeta('checklistPreenchidoId');
  @override
  late final GeneratedColumn<int> checklistPreenchidoId = GeneratedColumn<int>(
      'checklist_preenchido_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _perguntaIdMeta =
      const VerificationMeta('perguntaId');
  @override
  late final GeneratedColumn<int> perguntaId = GeneratedColumn<int>(
      'pergunta_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _opcaoRespostaIdMeta =
      const VerificationMeta('opcaoRespostaId');
  @override
  late final GeneratedColumn<int> opcaoRespostaId = GeneratedColumn<int>(
      'opcao_resposta_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dataRespostaMeta =
      const VerificationMeta('dataResposta');
  @override
  late final GeneratedColumn<DateTime> dataResposta = GeneratedColumn<DateTime>(
      'data_resposta', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, checklistPreenchidoId, perguntaId, opcaoRespostaId, dataResposta];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_resposta_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistRespostaTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('checklist_preenchido_id')) {
      context.handle(
          _checklistPreenchidoIdMeta,
          checklistPreenchidoId.isAcceptableOrUnknown(
              data['checklist_preenchido_id']!, _checklistPreenchidoIdMeta));
    } else if (isInserting) {
      context.missing(_checklistPreenchidoIdMeta);
    }
    if (data.containsKey('pergunta_id')) {
      context.handle(
          _perguntaIdMeta,
          perguntaId.isAcceptableOrUnknown(
              data['pergunta_id']!, _perguntaIdMeta));
    } else if (isInserting) {
      context.missing(_perguntaIdMeta);
    }
    if (data.containsKey('opcao_resposta_id')) {
      context.handle(
          _opcaoRespostaIdMeta,
          opcaoRespostaId.isAcceptableOrUnknown(
              data['opcao_resposta_id']!, _opcaoRespostaIdMeta));
    } else if (isInserting) {
      context.missing(_opcaoRespostaIdMeta);
    }
    if (data.containsKey('data_resposta')) {
      context.handle(
          _dataRespostaMeta,
          dataResposta.isAcceptableOrUnknown(
              data['data_resposta']!, _dataRespostaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistRespostaTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistRespostaTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      checklistPreenchidoId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}checklist_preenchido_id'])!,
      perguntaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pergunta_id'])!,
      opcaoRespostaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}opcao_resposta_id'])!,
      dataResposta: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_resposta'])!,
    );
  }

  @override
  $ChecklistRespostaTableTable createAlias(String alias) {
    return $ChecklistRespostaTableTable(attachedDatabase, alias);
  }
}

class ChecklistRespostaTableData extends DataClass
    implements Insertable<ChecklistRespostaTableData> {
  /// ID local (autoincrement)
  final int id;

  /// ID do checklist preenchido (FK)
  final int checklistPreenchidoId;

  /// ID remoto da pergunta
  final int perguntaId;

  /// ID remoto da opção de resposta escolhida
  final int opcaoRespostaId;

  /// Data e hora da resposta
  final DateTime dataResposta;
  const ChecklistRespostaTableData(
      {required this.id,
      required this.checklistPreenchidoId,
      required this.perguntaId,
      required this.opcaoRespostaId,
      required this.dataResposta});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['checklist_preenchido_id'] = Variable<int>(checklistPreenchidoId);
    map['pergunta_id'] = Variable<int>(perguntaId);
    map['opcao_resposta_id'] = Variable<int>(opcaoRespostaId);
    map['data_resposta'] = Variable<DateTime>(dataResposta);
    return map;
  }

  ChecklistRespostaTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistRespostaTableCompanion(
      id: Value(id),
      checklistPreenchidoId: Value(checklistPreenchidoId),
      perguntaId: Value(perguntaId),
      opcaoRespostaId: Value(opcaoRespostaId),
      dataResposta: Value(dataResposta),
    );
  }

  factory ChecklistRespostaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistRespostaTableData(
      id: serializer.fromJson<int>(json['id']),
      checklistPreenchidoId:
          serializer.fromJson<int>(json['checklistPreenchidoId']),
      perguntaId: serializer.fromJson<int>(json['perguntaId']),
      opcaoRespostaId: serializer.fromJson<int>(json['opcaoRespostaId']),
      dataResposta: serializer.fromJson<DateTime>(json['dataResposta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'checklistPreenchidoId': serializer.toJson<int>(checklistPreenchidoId),
      'perguntaId': serializer.toJson<int>(perguntaId),
      'opcaoRespostaId': serializer.toJson<int>(opcaoRespostaId),
      'dataResposta': serializer.toJson<DateTime>(dataResposta),
    };
  }

  ChecklistRespostaTableData copyWith(
          {int? id,
          int? checklistPreenchidoId,
          int? perguntaId,
          int? opcaoRespostaId,
          DateTime? dataResposta}) =>
      ChecklistRespostaTableData(
        id: id ?? this.id,
        checklistPreenchidoId:
            checklistPreenchidoId ?? this.checklistPreenchidoId,
        perguntaId: perguntaId ?? this.perguntaId,
        opcaoRespostaId: opcaoRespostaId ?? this.opcaoRespostaId,
        dataResposta: dataResposta ?? this.dataResposta,
      );
  ChecklistRespostaTableData copyWithCompanion(
      ChecklistRespostaTableCompanion data) {
    return ChecklistRespostaTableData(
      id: data.id.present ? data.id.value : this.id,
      checklistPreenchidoId: data.checklistPreenchidoId.present
          ? data.checklistPreenchidoId.value
          : this.checklistPreenchidoId,
      perguntaId:
          data.perguntaId.present ? data.perguntaId.value : this.perguntaId,
      opcaoRespostaId: data.opcaoRespostaId.present
          ? data.opcaoRespostaId.value
          : this.opcaoRespostaId,
      dataResposta: data.dataResposta.present
          ? data.dataResposta.value
          : this.dataResposta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistRespostaTableData(')
          ..write('id: $id, ')
          ..write('checklistPreenchidoId: $checklistPreenchidoId, ')
          ..write('perguntaId: $perguntaId, ')
          ..write('opcaoRespostaId: $opcaoRespostaId, ')
          ..write('dataResposta: $dataResposta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, checklistPreenchidoId, perguntaId, opcaoRespostaId, dataResposta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistRespostaTableData &&
          other.id == this.id &&
          other.checklistPreenchidoId == this.checklistPreenchidoId &&
          other.perguntaId == this.perguntaId &&
          other.opcaoRespostaId == this.opcaoRespostaId &&
          other.dataResposta == this.dataResposta);
}

class ChecklistRespostaTableCompanion
    extends UpdateCompanion<ChecklistRespostaTableData> {
  final Value<int> id;
  final Value<int> checklistPreenchidoId;
  final Value<int> perguntaId;
  final Value<int> opcaoRespostaId;
  final Value<DateTime> dataResposta;
  const ChecklistRespostaTableCompanion({
    this.id = const Value.absent(),
    this.checklistPreenchidoId = const Value.absent(),
    this.perguntaId = const Value.absent(),
    this.opcaoRespostaId = const Value.absent(),
    this.dataResposta = const Value.absent(),
  });
  ChecklistRespostaTableCompanion.insert({
    this.id = const Value.absent(),
    required int checklistPreenchidoId,
    required int perguntaId,
    required int opcaoRespostaId,
    this.dataResposta = const Value.absent(),
  })  : checklistPreenchidoId = Value(checklistPreenchidoId),
        perguntaId = Value(perguntaId),
        opcaoRespostaId = Value(opcaoRespostaId);
  static Insertable<ChecklistRespostaTableData> custom({
    Expression<int>? id,
    Expression<int>? checklistPreenchidoId,
    Expression<int>? perguntaId,
    Expression<int>? opcaoRespostaId,
    Expression<DateTime>? dataResposta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checklistPreenchidoId != null)
        'checklist_preenchido_id': checklistPreenchidoId,
      if (perguntaId != null) 'pergunta_id': perguntaId,
      if (opcaoRespostaId != null) 'opcao_resposta_id': opcaoRespostaId,
      if (dataResposta != null) 'data_resposta': dataResposta,
    });
  }

  ChecklistRespostaTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? checklistPreenchidoId,
      Value<int>? perguntaId,
      Value<int>? opcaoRespostaId,
      Value<DateTime>? dataResposta}) {
    return ChecklistRespostaTableCompanion(
      id: id ?? this.id,
      checklistPreenchidoId:
          checklistPreenchidoId ?? this.checklistPreenchidoId,
      perguntaId: perguntaId ?? this.perguntaId,
      opcaoRespostaId: opcaoRespostaId ?? this.opcaoRespostaId,
      dataResposta: dataResposta ?? this.dataResposta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (checklistPreenchidoId.present) {
      map['checklist_preenchido_id'] =
          Variable<int>(checklistPreenchidoId.value);
    }
    if (perguntaId.present) {
      map['pergunta_id'] = Variable<int>(perguntaId.value);
    }
    if (opcaoRespostaId.present) {
      map['opcao_resposta_id'] = Variable<int>(opcaoRespostaId.value);
    }
    if (dataResposta.present) {
      map['data_resposta'] = Variable<DateTime>(dataResposta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistRespostaTableCompanion(')
          ..write('id: $id, ')
          ..write('checklistPreenchidoId: $checklistPreenchidoId, ')
          ..write('perguntaId: $perguntaId, ')
          ..write('opcaoRespostaId: $opcaoRespostaId, ')
          ..write('dataResposta: $dataResposta')
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
  late final $TurnoTableTable turnoTable = $TurnoTableTable(this);
  late final $TurnoEletricistasTableTable turnoEletricistasTable =
      $TurnoEletricistasTableTable(this);
  late final $ChecklistModeloTableTable checklistModeloTable =
      $ChecklistModeloTableTable(this);
  late final $ChecklistPerguntaTableTable checklistPerguntaTable =
      $ChecklistPerguntaTableTable(this);
  late final $ChecklistOpcaoRespostaTableTable checklistOpcaoRespostaTable =
      $ChecklistOpcaoRespostaTableTable(this);
  late final $ChecklistOpcaoRespostaRelacaoTableTable
      checklistOpcaoRespostaRelacaoTable =
      $ChecklistOpcaoRespostaRelacaoTableTable(this);
  late final $ChecklistPerguntaRelacaoTableTable checklistPerguntaRelacaoTable =
      $ChecklistPerguntaRelacaoTableTable(this);
  late final $ChecklistTipoEquipeRelacaoTableTable
      checklistTipoEquipeRelacaoTable =
      $ChecklistTipoEquipeRelacaoTableTable(this);
  late final $ChecklistTipoVeiculoRelacaoTableTable
      checklistTipoVeiculoRelacaoTable =
      $ChecklistTipoVeiculoRelacaoTableTable(this);
  late final $ChecklistPreenchidoTableTable checklistPreenchidoTable =
      $ChecklistPreenchidoTableTable(this);
  late final $ChecklistRespostaTableTable checklistRespostaTable =
      $ChecklistRespostaTableTable(this);
  late final UsuarioDao usuarioDao = UsuarioDao(this as AppDatabase);
  late final TipoVeiculoDao tipoVeiculoDao =
      TipoVeiculoDao(this as AppDatabase);
  late final VeiculoDao veiculoDao = VeiculoDao(this as AppDatabase);
  late final TipoEquipeDao tipoEquipeDao = TipoEquipeDao(this as AppDatabase);
  late final EquipeDao equipeDao = EquipeDao(this as AppDatabase);
  late final EletricistaDao eletricistaDao =
      EletricistaDao(this as AppDatabase);
  late final TurnoDao turnoDao = TurnoDao(this as AppDatabase);
  late final TurnoEletricistasDao turnoEletricistasDao =
      TurnoEletricistasDao(this as AppDatabase);
  late final ChecklistModeloDao checklistModeloDao =
      ChecklistModeloDao(this as AppDatabase);
  late final ChecklistPerguntaDao checklistPerguntaDao =
      ChecklistPerguntaDao(this as AppDatabase);
  late final ChecklistOpcaoRespostaDao checklistOpcaoRespostaDao =
      ChecklistOpcaoRespostaDao(this as AppDatabase);
  late final ChecklistPerguntaRelacaoDao checklistPerguntaRelacaoDao =
      ChecklistPerguntaRelacaoDao(this as AppDatabase);
  late final ChecklistOpcaoRespostaRelacaoDao checklistOpcaoRespostaRelacaoDao =
      ChecklistOpcaoRespostaRelacaoDao(this as AppDatabase);
  late final ChecklistTipoEquipeRelacaoDao checklistTipoEquipeRelacaoDao =
      ChecklistTipoEquipeRelacaoDao(this as AppDatabase);
  late final ChecklistTipoVeiculoRelacaoDao checklistTipoVeiculoRelacaoDao =
      ChecklistTipoVeiculoRelacaoDao(this as AppDatabase);
  late final ChecklistPreenchidoDao checklistPreenchidoDao =
      ChecklistPreenchidoDao(this as AppDatabase);
  late final ChecklistRespostaDao checklistRespostaDao =
      ChecklistRespostaDao(this as AppDatabase);
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
        eletricistaTable,
        turnoTable,
        turnoEletricistasTable,
        checklistModeloTable,
        checklistPerguntaTable,
        checklistOpcaoRespostaTable,
        checklistOpcaoRespostaRelacaoTable,
        checklistPerguntaRelacaoTable,
        checklistTipoEquipeRelacaoTable,
        checklistTipoVeiculoRelacaoTable,
        checklistPreenchidoTable,
        checklistRespostaTable
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
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String nome,
  Value<String?> descricao,
});
typedef $$TipoVeiculoTableTableUpdateCompanionBuilder
    = TipoVeiculoTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
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
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> descricao = const Value.absent(),
          }) =>
              TipoVeiculoTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            descricao: descricao,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required String nome,
            Value<String?> descricao = const Value.absent(),
          }) =>
              TipoVeiculoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
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
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String placa,
  required int tipoVeiculoId,
});
typedef $$VeiculoTableTableUpdateCompanionBuilder = VeiculoTableCompanion
    Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
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

  ColumnFilters<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado,
      builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<int> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => column);

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
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> placa = const Value.absent(),
            Value<int> tipoVeiculoId = const Value.absent(),
          }) =>
              VeiculoTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            placa: placa,
            tipoVeiculoId: tipoVeiculoId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required String placa,
            required int tipoVeiculoId,
          }) =>
              VeiculoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
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
typedef $$TurnoTableTableCreateCompanionBuilder = TurnoTableCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  required int veiculoId,
  required int equipeId,
  required int kmInicial,
  Value<int?> kmFinal,
  required DateTime horaInicio,
  Value<DateTime?> horaFim,
  Value<String?> latitude,
  Value<String?> longitude,
  required SituacaoTurno situacaoTurno,
});
typedef $$TurnoTableTableUpdateCompanionBuilder = TurnoTableCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  Value<int> veiculoId,
  Value<int> equipeId,
  Value<int> kmInicial,
  Value<int?> kmFinal,
  Value<DateTime> horaInicio,
  Value<DateTime?> horaFim,
  Value<String?> latitude,
  Value<String?> longitude,
  Value<SituacaoTurno> situacaoTurno,
});

class $$TurnoTableTableFilterComposer
    extends Composer<_$AppDatabase, $TurnoTableTable> {
  $$TurnoTableTableFilterComposer({
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

  ColumnFilters<int> get veiculoId => $composableBuilder(
      column: $table.veiculoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get equipeId => $composableBuilder(
      column: $table.equipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kmInicial => $composableBuilder(
      column: $table.kmInicial, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kmFinal => $composableBuilder(
      column: $table.kmFinal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get horaInicio => $composableBuilder(
      column: $table.horaInicio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get horaFim => $composableBuilder(
      column: $table.horaFim, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SituacaoTurno, SituacaoTurno, String>
      get situacaoTurno => $composableBuilder(
          column: $table.situacaoTurno,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$TurnoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TurnoTableTable> {
  $$TurnoTableTableOrderingComposer({
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

  ColumnOrderings<int> get veiculoId => $composableBuilder(
      column: $table.veiculoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get equipeId => $composableBuilder(
      column: $table.equipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kmInicial => $composableBuilder(
      column: $table.kmInicial, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kmFinal => $composableBuilder(
      column: $table.kmFinal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get horaInicio => $composableBuilder(
      column: $table.horaInicio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get horaFim => $composableBuilder(
      column: $table.horaFim, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get situacaoTurno => $composableBuilder(
      column: $table.situacaoTurno,
      builder: (column) => ColumnOrderings(column));
}

class $$TurnoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TurnoTableTable> {
  $$TurnoTableTableAnnotationComposer({
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

  GeneratedColumn<int> get veiculoId =>
      $composableBuilder(column: $table.veiculoId, builder: (column) => column);

  GeneratedColumn<int> get equipeId =>
      $composableBuilder(column: $table.equipeId, builder: (column) => column);

  GeneratedColumn<int> get kmInicial =>
      $composableBuilder(column: $table.kmInicial, builder: (column) => column);

  GeneratedColumn<int> get kmFinal =>
      $composableBuilder(column: $table.kmFinal, builder: (column) => column);

  GeneratedColumn<DateTime> get horaInicio => $composableBuilder(
      column: $table.horaInicio, builder: (column) => column);

  GeneratedColumn<DateTime> get horaFim =>
      $composableBuilder(column: $table.horaFim, builder: (column) => column);

  GeneratedColumn<String> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<String> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SituacaoTurno, String> get situacaoTurno =>
      $composableBuilder(
          column: $table.situacaoTurno, builder: (column) => column);
}

class $$TurnoTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TurnoTableTable,
    TurnoTableData,
    $$TurnoTableTableFilterComposer,
    $$TurnoTableTableOrderingComposer,
    $$TurnoTableTableAnnotationComposer,
    $$TurnoTableTableCreateCompanionBuilder,
    $$TurnoTableTableUpdateCompanionBuilder,
    (
      TurnoTableData,
      BaseReferences<_$AppDatabase, $TurnoTableTable, TurnoTableData>
    ),
    TurnoTableData,
    PrefetchHooks Function()> {
  $$TurnoTableTableTableManager(_$AppDatabase db, $TurnoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TurnoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TurnoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TurnoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<int> veiculoId = const Value.absent(),
            Value<int> equipeId = const Value.absent(),
            Value<int> kmInicial = const Value.absent(),
            Value<int?> kmFinal = const Value.absent(),
            Value<DateTime> horaInicio = const Value.absent(),
            Value<DateTime?> horaFim = const Value.absent(),
            Value<String?> latitude = const Value.absent(),
            Value<String?> longitude = const Value.absent(),
            Value<SituacaoTurno> situacaoTurno = const Value.absent(),
          }) =>
              TurnoTableCompanion(
            id: id,
            remoteId: remoteId,
            veiculoId: veiculoId,
            equipeId: equipeId,
            kmInicial: kmInicial,
            kmFinal: kmFinal,
            horaInicio: horaInicio,
            horaFim: horaFim,
            latitude: latitude,
            longitude: longitude,
            situacaoTurno: situacaoTurno,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            required int veiculoId,
            required int equipeId,
            required int kmInicial,
            Value<int?> kmFinal = const Value.absent(),
            required DateTime horaInicio,
            Value<DateTime?> horaFim = const Value.absent(),
            Value<String?> latitude = const Value.absent(),
            Value<String?> longitude = const Value.absent(),
            required SituacaoTurno situacaoTurno,
          }) =>
              TurnoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            veiculoId: veiculoId,
            equipeId: equipeId,
            kmInicial: kmInicial,
            kmFinal: kmFinal,
            horaInicio: horaInicio,
            horaFim: horaFim,
            latitude: latitude,
            longitude: longitude,
            situacaoTurno: situacaoTurno,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TurnoTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TurnoTableTable,
    TurnoTableData,
    $$TurnoTableTableFilterComposer,
    $$TurnoTableTableOrderingComposer,
    $$TurnoTableTableAnnotationComposer,
    $$TurnoTableTableCreateCompanionBuilder,
    $$TurnoTableTableUpdateCompanionBuilder,
    (
      TurnoTableData,
      BaseReferences<_$AppDatabase, $TurnoTableTable, TurnoTableData>
    ),
    TurnoTableData,
    PrefetchHooks Function()>;
typedef $$TurnoEletricistasTableTableCreateCompanionBuilder
    = TurnoEletricistasTableCompanion Function({
  Value<int> id,
  required int turnoId,
  required int eletricistaId,
  Value<bool> motorista,
});
typedef $$TurnoEletricistasTableTableUpdateCompanionBuilder
    = TurnoEletricistasTableCompanion Function({
  Value<int> id,
  Value<int> turnoId,
  Value<int> eletricistaId,
  Value<bool> motorista,
});

class $$TurnoEletricistasTableTableFilterComposer
    extends Composer<_$AppDatabase, $TurnoEletricistasTableTable> {
  $$TurnoEletricistasTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get turnoId => $composableBuilder(
      column: $table.turnoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eletricistaId => $composableBuilder(
      column: $table.eletricistaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get motorista => $composableBuilder(
      column: $table.motorista, builder: (column) => ColumnFilters(column));
}

class $$TurnoEletricistasTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TurnoEletricistasTableTable> {
  $$TurnoEletricistasTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get turnoId => $composableBuilder(
      column: $table.turnoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eletricistaId => $composableBuilder(
      column: $table.eletricistaId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get motorista => $composableBuilder(
      column: $table.motorista, builder: (column) => ColumnOrderings(column));
}

class $$TurnoEletricistasTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TurnoEletricistasTableTable> {
  $$TurnoEletricistasTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get turnoId =>
      $composableBuilder(column: $table.turnoId, builder: (column) => column);

  GeneratedColumn<int> get eletricistaId => $composableBuilder(
      column: $table.eletricistaId, builder: (column) => column);

  GeneratedColumn<bool> get motorista =>
      $composableBuilder(column: $table.motorista, builder: (column) => column);
}

class $$TurnoEletricistasTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TurnoEletricistasTableTable,
    TurnoEletricistasTableData,
    $$TurnoEletricistasTableTableFilterComposer,
    $$TurnoEletricistasTableTableOrderingComposer,
    $$TurnoEletricistasTableTableAnnotationComposer,
    $$TurnoEletricistasTableTableCreateCompanionBuilder,
    $$TurnoEletricistasTableTableUpdateCompanionBuilder,
    (
      TurnoEletricistasTableData,
      BaseReferences<_$AppDatabase, $TurnoEletricistasTableTable,
          TurnoEletricistasTableData>
    ),
    TurnoEletricistasTableData,
    PrefetchHooks Function()> {
  $$TurnoEletricistasTableTableTableManager(
      _$AppDatabase db, $TurnoEletricistasTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TurnoEletricistasTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TurnoEletricistasTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TurnoEletricistasTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> turnoId = const Value.absent(),
            Value<int> eletricistaId = const Value.absent(),
            Value<bool> motorista = const Value.absent(),
          }) =>
              TurnoEletricistasTableCompanion(
            id: id,
            turnoId: turnoId,
            eletricistaId: eletricistaId,
            motorista: motorista,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int turnoId,
            required int eletricistaId,
            Value<bool> motorista = const Value.absent(),
          }) =>
              TurnoEletricistasTableCompanion.insert(
            id: id,
            turnoId: turnoId,
            eletricistaId: eletricistaId,
            motorista: motorista,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TurnoEletricistasTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TurnoEletricistasTableTable,
        TurnoEletricistasTableData,
        $$TurnoEletricistasTableTableFilterComposer,
        $$TurnoEletricistasTableTableOrderingComposer,
        $$TurnoEletricistasTableTableAnnotationComposer,
        $$TurnoEletricistasTableTableCreateCompanionBuilder,
        $$TurnoEletricistasTableTableUpdateCompanionBuilder,
        (
          TurnoEletricistasTableData,
          BaseReferences<_$AppDatabase, $TurnoEletricistasTableTable,
              TurnoEletricistasTableData>
        ),
        TurnoEletricistasTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistModeloTableTableCreateCompanionBuilder
    = ChecklistModeloTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String nome,
  required int tipoChecklistId,
});
typedef $$ChecklistModeloTableTableUpdateCompanionBuilder
    = ChecklistModeloTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<String> nome,
  Value<int> tipoChecklistId,
});

class $$ChecklistModeloTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistModeloTableTable> {
  $$ChecklistModeloTableTableFilterComposer({
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

  ColumnFilters<int> get tipoChecklistId => $composableBuilder(
      column: $table.tipoChecklistId,
      builder: (column) => ColumnFilters(column));
}

class $$ChecklistModeloTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistModeloTableTable> {
  $$ChecklistModeloTableTableOrderingComposer({
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

  ColumnOrderings<int> get tipoChecklistId => $composableBuilder(
      column: $table.tipoChecklistId,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistModeloTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistModeloTableTable> {
  $$ChecklistModeloTableTableAnnotationComposer({
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

  GeneratedColumn<int> get tipoChecklistId => $composableBuilder(
      column: $table.tipoChecklistId, builder: (column) => column);
}

class $$ChecklistModeloTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistModeloTableTable,
    ChecklistModeloTableData,
    $$ChecklistModeloTableTableFilterComposer,
    $$ChecklistModeloTableTableOrderingComposer,
    $$ChecklistModeloTableTableAnnotationComposer,
    $$ChecklistModeloTableTableCreateCompanionBuilder,
    $$ChecklistModeloTableTableUpdateCompanionBuilder,
    (
      ChecklistModeloTableData,
      BaseReferences<_$AppDatabase, $ChecklistModeloTableTable,
          ChecklistModeloTableData>
    ),
    ChecklistModeloTableData,
    PrefetchHooks Function()> {
  $$ChecklistModeloTableTableTableManager(
      _$AppDatabase db, $ChecklistModeloTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistModeloTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistModeloTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistModeloTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<int> tipoChecklistId = const Value.absent(),
          }) =>
              ChecklistModeloTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            tipoChecklistId: tipoChecklistId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required String nome,
            required int tipoChecklistId,
          }) =>
              ChecklistModeloTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            tipoChecklistId: tipoChecklistId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistModeloTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistModeloTableTable,
        ChecklistModeloTableData,
        $$ChecklistModeloTableTableFilterComposer,
        $$ChecklistModeloTableTableOrderingComposer,
        $$ChecklistModeloTableTableAnnotationComposer,
        $$ChecklistModeloTableTableCreateCompanionBuilder,
        $$ChecklistModeloTableTableUpdateCompanionBuilder,
        (
          ChecklistModeloTableData,
          BaseReferences<_$AppDatabase, $ChecklistModeloTableTable,
              ChecklistModeloTableData>
        ),
        ChecklistModeloTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistPerguntaTableTableCreateCompanionBuilder
    = ChecklistPerguntaTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String nome,
});
typedef $$ChecklistPerguntaTableTableUpdateCompanionBuilder
    = ChecklistPerguntaTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<String> nome,
});

class $$ChecklistPerguntaTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistPerguntaTableTable> {
  $$ChecklistPerguntaTableTableFilterComposer({
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

class $$ChecklistPerguntaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistPerguntaTableTable> {
  $$ChecklistPerguntaTableTableOrderingComposer({
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

class $$ChecklistPerguntaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistPerguntaTableTable> {
  $$ChecklistPerguntaTableTableAnnotationComposer({
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

class $$ChecklistPerguntaTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistPerguntaTableTable,
    ChecklistPerguntaTableData,
    $$ChecklistPerguntaTableTableFilterComposer,
    $$ChecklistPerguntaTableTableOrderingComposer,
    $$ChecklistPerguntaTableTableAnnotationComposer,
    $$ChecklistPerguntaTableTableCreateCompanionBuilder,
    $$ChecklistPerguntaTableTableUpdateCompanionBuilder,
    (
      ChecklistPerguntaTableData,
      BaseReferences<_$AppDatabase, $ChecklistPerguntaTableTable,
          ChecklistPerguntaTableData>
    ),
    ChecklistPerguntaTableData,
    PrefetchHooks Function()> {
  $$ChecklistPerguntaTableTableTableManager(
      _$AppDatabase db, $ChecklistPerguntaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistPerguntaTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistPerguntaTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistPerguntaTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> nome = const Value.absent(),
          }) =>
              ChecklistPerguntaTableCompanion(
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
              ChecklistPerguntaTableCompanion.insert(
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

typedef $$ChecklistPerguntaTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistPerguntaTableTable,
        ChecklistPerguntaTableData,
        $$ChecklistPerguntaTableTableFilterComposer,
        $$ChecklistPerguntaTableTableOrderingComposer,
        $$ChecklistPerguntaTableTableAnnotationComposer,
        $$ChecklistPerguntaTableTableCreateCompanionBuilder,
        $$ChecklistPerguntaTableTableUpdateCompanionBuilder,
        (
          ChecklistPerguntaTableData,
          BaseReferences<_$AppDatabase, $ChecklistPerguntaTableTable,
              ChecklistPerguntaTableData>
        ),
        ChecklistPerguntaTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistOpcaoRespostaTableTableCreateCompanionBuilder
    = ChecklistOpcaoRespostaTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required String nome,
  required bool geraPendencia,
});
typedef $$ChecklistOpcaoRespostaTableTableUpdateCompanionBuilder
    = ChecklistOpcaoRespostaTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<String> nome,
  Value<bool> geraPendencia,
});

class $$ChecklistOpcaoRespostaTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistOpcaoRespostaTableTable> {
  $$ChecklistOpcaoRespostaTableTableFilterComposer({
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

  ColumnFilters<bool> get geraPendencia => $composableBuilder(
      column: $table.geraPendencia, builder: (column) => ColumnFilters(column));
}

class $$ChecklistOpcaoRespostaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistOpcaoRespostaTableTable> {
  $$ChecklistOpcaoRespostaTableTableOrderingComposer({
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

  ColumnOrderings<bool> get geraPendencia => $composableBuilder(
      column: $table.geraPendencia,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistOpcaoRespostaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistOpcaoRespostaTableTable> {
  $$ChecklistOpcaoRespostaTableTableAnnotationComposer({
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

  GeneratedColumn<bool> get geraPendencia => $composableBuilder(
      column: $table.geraPendencia, builder: (column) => column);
}

class $$ChecklistOpcaoRespostaTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistOpcaoRespostaTableTable,
    ChecklistOpcaoRespostaTableData,
    $$ChecklistOpcaoRespostaTableTableFilterComposer,
    $$ChecklistOpcaoRespostaTableTableOrderingComposer,
    $$ChecklistOpcaoRespostaTableTableAnnotationComposer,
    $$ChecklistOpcaoRespostaTableTableCreateCompanionBuilder,
    $$ChecklistOpcaoRespostaTableTableUpdateCompanionBuilder,
    (
      ChecklistOpcaoRespostaTableData,
      BaseReferences<_$AppDatabase, $ChecklistOpcaoRespostaTableTable,
          ChecklistOpcaoRespostaTableData>
    ),
    ChecklistOpcaoRespostaTableData,
    PrefetchHooks Function()> {
  $$ChecklistOpcaoRespostaTableTableTableManager(
      _$AppDatabase db, $ChecklistOpcaoRespostaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistOpcaoRespostaTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistOpcaoRespostaTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistOpcaoRespostaTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<bool> geraPendencia = const Value.absent(),
          }) =>
              ChecklistOpcaoRespostaTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            geraPendencia: geraPendencia,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required String nome,
            required bool geraPendencia,
          }) =>
              ChecklistOpcaoRespostaTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            nome: nome,
            geraPendencia: geraPendencia,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistOpcaoRespostaTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistOpcaoRespostaTableTable,
        ChecklistOpcaoRespostaTableData,
        $$ChecklistOpcaoRespostaTableTableFilterComposer,
        $$ChecklistOpcaoRespostaTableTableOrderingComposer,
        $$ChecklistOpcaoRespostaTableTableAnnotationComposer,
        $$ChecklistOpcaoRespostaTableTableCreateCompanionBuilder,
        $$ChecklistOpcaoRespostaTableTableUpdateCompanionBuilder,
        (
          ChecklistOpcaoRespostaTableData,
          BaseReferences<_$AppDatabase, $ChecklistOpcaoRespostaTableTable,
              ChecklistOpcaoRespostaTableData>
        ),
        ChecklistOpcaoRespostaTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistOpcaoRespostaRelacaoTableTableCreateCompanionBuilder
    = ChecklistOpcaoRespostaRelacaoTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required int checklistOpcaoRespostaId,
  required int checklistModeloId,
});
typedef $$ChecklistOpcaoRespostaRelacaoTableTableUpdateCompanionBuilder
    = ChecklistOpcaoRespostaRelacaoTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<int> checklistOpcaoRespostaId,
  Value<int> checklistModeloId,
});

class $$ChecklistOpcaoRespostaRelacaoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistOpcaoRespostaRelacaoTableTable> {
  $$ChecklistOpcaoRespostaRelacaoTableTableFilterComposer({
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

  ColumnFilters<int> get checklistOpcaoRespostaId => $composableBuilder(
      column: $table.checklistOpcaoRespostaId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnFilters(column));
}

class $$ChecklistOpcaoRespostaRelacaoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistOpcaoRespostaRelacaoTableTable> {
  $$ChecklistOpcaoRespostaRelacaoTableTableOrderingComposer({
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

  ColumnOrderings<int> get checklistOpcaoRespostaId => $composableBuilder(
      column: $table.checklistOpcaoRespostaId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistOpcaoRespostaRelacaoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistOpcaoRespostaRelacaoTableTable> {
  $$ChecklistOpcaoRespostaRelacaoTableTableAnnotationComposer({
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

  GeneratedColumn<int> get checklistOpcaoRespostaId => $composableBuilder(
      column: $table.checklistOpcaoRespostaId, builder: (column) => column);

  GeneratedColumn<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId, builder: (column) => column);
}

class $$ChecklistOpcaoRespostaRelacaoTableTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $ChecklistOpcaoRespostaRelacaoTableTable,
        ChecklistOpcaoRespostaRelacaoTableData,
        $$ChecklistOpcaoRespostaRelacaoTableTableFilterComposer,
        $$ChecklistOpcaoRespostaRelacaoTableTableOrderingComposer,
        $$ChecklistOpcaoRespostaRelacaoTableTableAnnotationComposer,
        $$ChecklistOpcaoRespostaRelacaoTableTableCreateCompanionBuilder,
        $$ChecklistOpcaoRespostaRelacaoTableTableUpdateCompanionBuilder,
        (
          ChecklistOpcaoRespostaRelacaoTableData,
          BaseReferences<
              _$AppDatabase,
              $ChecklistOpcaoRespostaRelacaoTableTable,
              ChecklistOpcaoRespostaRelacaoTableData>
        ),
        ChecklistOpcaoRespostaRelacaoTableData,
        PrefetchHooks Function()> {
  $$ChecklistOpcaoRespostaRelacaoTableTableTableManager(
      _$AppDatabase db, $ChecklistOpcaoRespostaRelacaoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistOpcaoRespostaRelacaoTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistOpcaoRespostaRelacaoTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistOpcaoRespostaRelacaoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<int> checklistOpcaoRespostaId = const Value.absent(),
            Value<int> checklistModeloId = const Value.absent(),
          }) =>
              ChecklistOpcaoRespostaRelacaoTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistOpcaoRespostaId: checklistOpcaoRespostaId,
            checklistModeloId: checklistModeloId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required int checklistOpcaoRespostaId,
            required int checklistModeloId,
          }) =>
              ChecklistOpcaoRespostaRelacaoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistOpcaoRespostaId: checklistOpcaoRespostaId,
            checklistModeloId: checklistModeloId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistOpcaoRespostaRelacaoTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistOpcaoRespostaRelacaoTableTable,
        ChecklistOpcaoRespostaRelacaoTableData,
        $$ChecklistOpcaoRespostaRelacaoTableTableFilterComposer,
        $$ChecklistOpcaoRespostaRelacaoTableTableOrderingComposer,
        $$ChecklistOpcaoRespostaRelacaoTableTableAnnotationComposer,
        $$ChecklistOpcaoRespostaRelacaoTableTableCreateCompanionBuilder,
        $$ChecklistOpcaoRespostaRelacaoTableTableUpdateCompanionBuilder,
        (
          ChecklistOpcaoRespostaRelacaoTableData,
          BaseReferences<
              _$AppDatabase,
              $ChecklistOpcaoRespostaRelacaoTableTable,
              ChecklistOpcaoRespostaRelacaoTableData>
        ),
        ChecklistOpcaoRespostaRelacaoTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistPerguntaRelacaoTableTableCreateCompanionBuilder
    = ChecklistPerguntaRelacaoTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required int checklistModeloId,
  required int checklistPerguntaId,
});
typedef $$ChecklistPerguntaRelacaoTableTableUpdateCompanionBuilder
    = ChecklistPerguntaRelacaoTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<int> checklistModeloId,
  Value<int> checklistPerguntaId,
});

class $$ChecklistPerguntaRelacaoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistPerguntaRelacaoTableTable> {
  $$ChecklistPerguntaRelacaoTableTableFilterComposer({
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

  ColumnFilters<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checklistPerguntaId => $composableBuilder(
      column: $table.checklistPerguntaId,
      builder: (column) => ColumnFilters(column));
}

class $$ChecklistPerguntaRelacaoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistPerguntaRelacaoTableTable> {
  $$ChecklistPerguntaRelacaoTableTableOrderingComposer({
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

  ColumnOrderings<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checklistPerguntaId => $composableBuilder(
      column: $table.checklistPerguntaId,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistPerguntaRelacaoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistPerguntaRelacaoTableTable> {
  $$ChecklistPerguntaRelacaoTableTableAnnotationComposer({
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

  GeneratedColumn<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId, builder: (column) => column);

  GeneratedColumn<int> get checklistPerguntaId => $composableBuilder(
      column: $table.checklistPerguntaId, builder: (column) => column);
}

class $$ChecklistPerguntaRelacaoTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistPerguntaRelacaoTableTable,
    ChecklistPerguntaRelacaoTableData,
    $$ChecklistPerguntaRelacaoTableTableFilterComposer,
    $$ChecklistPerguntaRelacaoTableTableOrderingComposer,
    $$ChecklistPerguntaRelacaoTableTableAnnotationComposer,
    $$ChecklistPerguntaRelacaoTableTableCreateCompanionBuilder,
    $$ChecklistPerguntaRelacaoTableTableUpdateCompanionBuilder,
    (
      ChecklistPerguntaRelacaoTableData,
      BaseReferences<_$AppDatabase, $ChecklistPerguntaRelacaoTableTable,
          ChecklistPerguntaRelacaoTableData>
    ),
    ChecklistPerguntaRelacaoTableData,
    PrefetchHooks Function()> {
  $$ChecklistPerguntaRelacaoTableTableTableManager(
      _$AppDatabase db, $ChecklistPerguntaRelacaoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistPerguntaRelacaoTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistPerguntaRelacaoTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistPerguntaRelacaoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<int> checklistModeloId = const Value.absent(),
            Value<int> checklistPerguntaId = const Value.absent(),
          }) =>
              ChecklistPerguntaRelacaoTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistModeloId: checklistModeloId,
            checklistPerguntaId: checklistPerguntaId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required int checklistModeloId,
            required int checklistPerguntaId,
          }) =>
              ChecklistPerguntaRelacaoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistModeloId: checklistModeloId,
            checklistPerguntaId: checklistPerguntaId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistPerguntaRelacaoTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistPerguntaRelacaoTableTable,
        ChecklistPerguntaRelacaoTableData,
        $$ChecklistPerguntaRelacaoTableTableFilterComposer,
        $$ChecklistPerguntaRelacaoTableTableOrderingComposer,
        $$ChecklistPerguntaRelacaoTableTableAnnotationComposer,
        $$ChecklistPerguntaRelacaoTableTableCreateCompanionBuilder,
        $$ChecklistPerguntaRelacaoTableTableUpdateCompanionBuilder,
        (
          ChecklistPerguntaRelacaoTableData,
          BaseReferences<_$AppDatabase, $ChecklistPerguntaRelacaoTableTable,
              ChecklistPerguntaRelacaoTableData>
        ),
        ChecklistPerguntaRelacaoTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistTipoEquipeRelacaoTableTableCreateCompanionBuilder
    = ChecklistTipoEquipeRelacaoTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required int checklistModeloId,
  required int tipoEquipeId,
});
typedef $$ChecklistTipoEquipeRelacaoTableTableUpdateCompanionBuilder
    = ChecklistTipoEquipeRelacaoTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<int> checklistModeloId,
  Value<int> tipoEquipeId,
});

class $$ChecklistTipoEquipeRelacaoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistTipoEquipeRelacaoTableTable> {
  $$ChecklistTipoEquipeRelacaoTableTableFilterComposer({
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

  ColumnFilters<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tipoEquipeId => $composableBuilder(
      column: $table.tipoEquipeId, builder: (column) => ColumnFilters(column));
}

class $$ChecklistTipoEquipeRelacaoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistTipoEquipeRelacaoTableTable> {
  $$ChecklistTipoEquipeRelacaoTableTableOrderingComposer({
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

  ColumnOrderings<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tipoEquipeId => $composableBuilder(
      column: $table.tipoEquipeId,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistTipoEquipeRelacaoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistTipoEquipeRelacaoTableTable> {
  $$ChecklistTipoEquipeRelacaoTableTableAnnotationComposer({
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

  GeneratedColumn<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId, builder: (column) => column);

  GeneratedColumn<int> get tipoEquipeId => $composableBuilder(
      column: $table.tipoEquipeId, builder: (column) => column);
}

class $$ChecklistTipoEquipeRelacaoTableTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $ChecklistTipoEquipeRelacaoTableTable,
        ChecklistTipoEquipeRelacaoTableData,
        $$ChecklistTipoEquipeRelacaoTableTableFilterComposer,
        $$ChecklistTipoEquipeRelacaoTableTableOrderingComposer,
        $$ChecklistTipoEquipeRelacaoTableTableAnnotationComposer,
        $$ChecklistTipoEquipeRelacaoTableTableCreateCompanionBuilder,
        $$ChecklistTipoEquipeRelacaoTableTableUpdateCompanionBuilder,
        (
          ChecklistTipoEquipeRelacaoTableData,
          BaseReferences<_$AppDatabase, $ChecklistTipoEquipeRelacaoTableTable,
              ChecklistTipoEquipeRelacaoTableData>
        ),
        ChecklistTipoEquipeRelacaoTableData,
        PrefetchHooks Function()> {
  $$ChecklistTipoEquipeRelacaoTableTableTableManager(
      _$AppDatabase db, $ChecklistTipoEquipeRelacaoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistTipoEquipeRelacaoTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistTipoEquipeRelacaoTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistTipoEquipeRelacaoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<int> checklistModeloId = const Value.absent(),
            Value<int> tipoEquipeId = const Value.absent(),
          }) =>
              ChecklistTipoEquipeRelacaoTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistModeloId: checklistModeloId,
            tipoEquipeId: tipoEquipeId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required int checklistModeloId,
            required int tipoEquipeId,
          }) =>
              ChecklistTipoEquipeRelacaoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistModeloId: checklistModeloId,
            tipoEquipeId: tipoEquipeId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistTipoEquipeRelacaoTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistTipoEquipeRelacaoTableTable,
        ChecklistTipoEquipeRelacaoTableData,
        $$ChecklistTipoEquipeRelacaoTableTableFilterComposer,
        $$ChecklistTipoEquipeRelacaoTableTableOrderingComposer,
        $$ChecklistTipoEquipeRelacaoTableTableAnnotationComposer,
        $$ChecklistTipoEquipeRelacaoTableTableCreateCompanionBuilder,
        $$ChecklistTipoEquipeRelacaoTableTableUpdateCompanionBuilder,
        (
          ChecklistTipoEquipeRelacaoTableData,
          BaseReferences<_$AppDatabase, $ChecklistTipoEquipeRelacaoTableTable,
              ChecklistTipoEquipeRelacaoTableData>
        ),
        ChecklistTipoEquipeRelacaoTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistTipoVeiculoRelacaoTableTableCreateCompanionBuilder
    = ChecklistTipoVeiculoRelacaoTableCompanion Function({
  Value<int> id,
  required int remoteId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> sincronizado,
  required int checklistModeloId,
  required int tipoVeiculoId,
});
typedef $$ChecklistTipoVeiculoRelacaoTableTableUpdateCompanionBuilder
    = ChecklistTipoVeiculoRelacaoTableCompanion Function({
  Value<int> id,
  Value<int> remoteId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> sincronizado,
  Value<int> checklistModeloId,
  Value<int> tipoVeiculoId,
});

class $$ChecklistTipoVeiculoRelacaoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistTipoVeiculoRelacaoTableTable> {
  $$ChecklistTipoVeiculoRelacaoTableTableFilterComposer({
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

  ColumnFilters<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId, builder: (column) => ColumnFilters(column));
}

class $$ChecklistTipoVeiculoRelacaoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistTipoVeiculoRelacaoTableTable> {
  $$ChecklistTipoVeiculoRelacaoTableTableOrderingComposer({
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

  ColumnOrderings<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistTipoVeiculoRelacaoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistTipoVeiculoRelacaoTableTable> {
  $$ChecklistTipoVeiculoRelacaoTableTableAnnotationComposer({
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

  GeneratedColumn<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId, builder: (column) => column);

  GeneratedColumn<int> get tipoVeiculoId => $composableBuilder(
      column: $table.tipoVeiculoId, builder: (column) => column);
}

class $$ChecklistTipoVeiculoRelacaoTableTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $ChecklistTipoVeiculoRelacaoTableTable,
        ChecklistTipoVeiculoRelacaoTableData,
        $$ChecklistTipoVeiculoRelacaoTableTableFilterComposer,
        $$ChecklistTipoVeiculoRelacaoTableTableOrderingComposer,
        $$ChecklistTipoVeiculoRelacaoTableTableAnnotationComposer,
        $$ChecklistTipoVeiculoRelacaoTableTableCreateCompanionBuilder,
        $$ChecklistTipoVeiculoRelacaoTableTableUpdateCompanionBuilder,
        (
          ChecklistTipoVeiculoRelacaoTableData,
          BaseReferences<_$AppDatabase, $ChecklistTipoVeiculoRelacaoTableTable,
              ChecklistTipoVeiculoRelacaoTableData>
        ),
        ChecklistTipoVeiculoRelacaoTableData,
        PrefetchHooks Function()> {
  $$ChecklistTipoVeiculoRelacaoTableTableTableManager(
      _$AppDatabase db, $ChecklistTipoVeiculoRelacaoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistTipoVeiculoRelacaoTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistTipoVeiculoRelacaoTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistTipoVeiculoRelacaoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> sincronizado = const Value.absent(),
            Value<int> checklistModeloId = const Value.absent(),
            Value<int> tipoVeiculoId = const Value.absent(),
          }) =>
              ChecklistTipoVeiculoRelacaoTableCompanion(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistModeloId: checklistModeloId,
            tipoVeiculoId: tipoVeiculoId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int remoteId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> sincronizado = const Value.absent(),
            required int checklistModeloId,
            required int tipoVeiculoId,
          }) =>
              ChecklistTipoVeiculoRelacaoTableCompanion.insert(
            id: id,
            remoteId: remoteId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sincronizado: sincronizado,
            checklistModeloId: checklistModeloId,
            tipoVeiculoId: tipoVeiculoId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistTipoVeiculoRelacaoTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistTipoVeiculoRelacaoTableTable,
        ChecklistTipoVeiculoRelacaoTableData,
        $$ChecklistTipoVeiculoRelacaoTableTableFilterComposer,
        $$ChecklistTipoVeiculoRelacaoTableTableOrderingComposer,
        $$ChecklistTipoVeiculoRelacaoTableTableAnnotationComposer,
        $$ChecklistTipoVeiculoRelacaoTableTableCreateCompanionBuilder,
        $$ChecklistTipoVeiculoRelacaoTableTableUpdateCompanionBuilder,
        (
          ChecklistTipoVeiculoRelacaoTableData,
          BaseReferences<_$AppDatabase, $ChecklistTipoVeiculoRelacaoTableTable,
              ChecklistTipoVeiculoRelacaoTableData>
        ),
        ChecklistTipoVeiculoRelacaoTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistPreenchidoTableTableCreateCompanionBuilder
    = ChecklistPreenchidoTableCompanion Function({
  Value<int> id,
  required int turnoId,
  required int checklistModeloId,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<DateTime> dataPreenchimento,
});
typedef $$ChecklistPreenchidoTableTableUpdateCompanionBuilder
    = ChecklistPreenchidoTableCompanion Function({
  Value<int> id,
  Value<int> turnoId,
  Value<int> checklistModeloId,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<DateTime> dataPreenchimento,
});

class $$ChecklistPreenchidoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistPreenchidoTableTable> {
  $$ChecklistPreenchidoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get turnoId => $composableBuilder(
      column: $table.turnoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataPreenchimento => $composableBuilder(
      column: $table.dataPreenchimento,
      builder: (column) => ColumnFilters(column));
}

class $$ChecklistPreenchidoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistPreenchidoTableTable> {
  $$ChecklistPreenchidoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get turnoId => $composableBuilder(
      column: $table.turnoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataPreenchimento => $composableBuilder(
      column: $table.dataPreenchimento,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistPreenchidoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistPreenchidoTableTable> {
  $$ChecklistPreenchidoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get turnoId =>
      $composableBuilder(column: $table.turnoId, builder: (column) => column);

  GeneratedColumn<int> get checklistModeloId => $composableBuilder(
      column: $table.checklistModeloId, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get dataPreenchimento => $composableBuilder(
      column: $table.dataPreenchimento, builder: (column) => column);
}

class $$ChecklistPreenchidoTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistPreenchidoTableTable,
    ChecklistPreenchidoTableData,
    $$ChecklistPreenchidoTableTableFilterComposer,
    $$ChecklistPreenchidoTableTableOrderingComposer,
    $$ChecklistPreenchidoTableTableAnnotationComposer,
    $$ChecklistPreenchidoTableTableCreateCompanionBuilder,
    $$ChecklistPreenchidoTableTableUpdateCompanionBuilder,
    (
      ChecklistPreenchidoTableData,
      BaseReferences<_$AppDatabase, $ChecklistPreenchidoTableTable,
          ChecklistPreenchidoTableData>
    ),
    ChecklistPreenchidoTableData,
    PrefetchHooks Function()> {
  $$ChecklistPreenchidoTableTableTableManager(
      _$AppDatabase db, $ChecklistPreenchidoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistPreenchidoTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistPreenchidoTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistPreenchidoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> turnoId = const Value.absent(),
            Value<int> checklistModeloId = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<DateTime> dataPreenchimento = const Value.absent(),
          }) =>
              ChecklistPreenchidoTableCompanion(
            id: id,
            turnoId: turnoId,
            checklistModeloId: checklistModeloId,
            latitude: latitude,
            longitude: longitude,
            dataPreenchimento: dataPreenchimento,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int turnoId,
            required int checklistModeloId,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<DateTime> dataPreenchimento = const Value.absent(),
          }) =>
              ChecklistPreenchidoTableCompanion.insert(
            id: id,
            turnoId: turnoId,
            checklistModeloId: checklistModeloId,
            latitude: latitude,
            longitude: longitude,
            dataPreenchimento: dataPreenchimento,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistPreenchidoTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistPreenchidoTableTable,
        ChecklistPreenchidoTableData,
        $$ChecklistPreenchidoTableTableFilterComposer,
        $$ChecklistPreenchidoTableTableOrderingComposer,
        $$ChecklistPreenchidoTableTableAnnotationComposer,
        $$ChecklistPreenchidoTableTableCreateCompanionBuilder,
        $$ChecklistPreenchidoTableTableUpdateCompanionBuilder,
        (
          ChecklistPreenchidoTableData,
          BaseReferences<_$AppDatabase, $ChecklistPreenchidoTableTable,
              ChecklistPreenchidoTableData>
        ),
        ChecklistPreenchidoTableData,
        PrefetchHooks Function()>;
typedef $$ChecklistRespostaTableTableCreateCompanionBuilder
    = ChecklistRespostaTableCompanion Function({
  Value<int> id,
  required int checklistPreenchidoId,
  required int perguntaId,
  required int opcaoRespostaId,
  Value<DateTime> dataResposta,
});
typedef $$ChecklistRespostaTableTableUpdateCompanionBuilder
    = ChecklistRespostaTableCompanion Function({
  Value<int> id,
  Value<int> checklistPreenchidoId,
  Value<int> perguntaId,
  Value<int> opcaoRespostaId,
  Value<DateTime> dataResposta,
});

class $$ChecklistRespostaTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistRespostaTableTable> {
  $$ChecklistRespostaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checklistPreenchidoId => $composableBuilder(
      column: $table.checklistPreenchidoId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get perguntaId => $composableBuilder(
      column: $table.perguntaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get opcaoRespostaId => $composableBuilder(
      column: $table.opcaoRespostaId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataResposta => $composableBuilder(
      column: $table.dataResposta, builder: (column) => ColumnFilters(column));
}

class $$ChecklistRespostaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistRespostaTableTable> {
  $$ChecklistRespostaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checklistPreenchidoId => $composableBuilder(
      column: $table.checklistPreenchidoId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get perguntaId => $composableBuilder(
      column: $table.perguntaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get opcaoRespostaId => $composableBuilder(
      column: $table.opcaoRespostaId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataResposta => $composableBuilder(
      column: $table.dataResposta,
      builder: (column) => ColumnOrderings(column));
}

class $$ChecklistRespostaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistRespostaTableTable> {
  $$ChecklistRespostaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get checklistPreenchidoId => $composableBuilder(
      column: $table.checklistPreenchidoId, builder: (column) => column);

  GeneratedColumn<int> get perguntaId => $composableBuilder(
      column: $table.perguntaId, builder: (column) => column);

  GeneratedColumn<int> get opcaoRespostaId => $composableBuilder(
      column: $table.opcaoRespostaId, builder: (column) => column);

  GeneratedColumn<DateTime> get dataResposta => $composableBuilder(
      column: $table.dataResposta, builder: (column) => column);
}

class $$ChecklistRespostaTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistRespostaTableTable,
    ChecklistRespostaTableData,
    $$ChecklistRespostaTableTableFilterComposer,
    $$ChecklistRespostaTableTableOrderingComposer,
    $$ChecklistRespostaTableTableAnnotationComposer,
    $$ChecklistRespostaTableTableCreateCompanionBuilder,
    $$ChecklistRespostaTableTableUpdateCompanionBuilder,
    (
      ChecklistRespostaTableData,
      BaseReferences<_$AppDatabase, $ChecklistRespostaTableTable,
          ChecklistRespostaTableData>
    ),
    ChecklistRespostaTableData,
    PrefetchHooks Function()> {
  $$ChecklistRespostaTableTableTableManager(
      _$AppDatabase db, $ChecklistRespostaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistRespostaTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistRespostaTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistRespostaTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> checklistPreenchidoId = const Value.absent(),
            Value<int> perguntaId = const Value.absent(),
            Value<int> opcaoRespostaId = const Value.absent(),
            Value<DateTime> dataResposta = const Value.absent(),
          }) =>
              ChecklistRespostaTableCompanion(
            id: id,
            checklistPreenchidoId: checklistPreenchidoId,
            perguntaId: perguntaId,
            opcaoRespostaId: opcaoRespostaId,
            dataResposta: dataResposta,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int checklistPreenchidoId,
            required int perguntaId,
            required int opcaoRespostaId,
            Value<DateTime> dataResposta = const Value.absent(),
          }) =>
              ChecklistRespostaTableCompanion.insert(
            id: id,
            checklistPreenchidoId: checklistPreenchidoId,
            perguntaId: perguntaId,
            opcaoRespostaId: opcaoRespostaId,
            dataResposta: dataResposta,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistRespostaTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistRespostaTableTable,
        ChecklistRespostaTableData,
        $$ChecklistRespostaTableTableFilterComposer,
        $$ChecklistRespostaTableTableOrderingComposer,
        $$ChecklistRespostaTableTableAnnotationComposer,
        $$ChecklistRespostaTableTableCreateCompanionBuilder,
        $$ChecklistRespostaTableTableUpdateCompanionBuilder,
        (
          ChecklistRespostaTableData,
          BaseReferences<_$AppDatabase, $ChecklistRespostaTableTable,
              ChecklistRespostaTableData>
        ),
        ChecklistRespostaTableData,
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
  $$TurnoTableTableTableManager get turnoTable =>
      $$TurnoTableTableTableManager(_db, _db.turnoTable);
  $$TurnoEletricistasTableTableTableManager get turnoEletricistasTable =>
      $$TurnoEletricistasTableTableTableManager(
          _db, _db.turnoEletricistasTable);
  $$ChecklistModeloTableTableTableManager get checklistModeloTable =>
      $$ChecklistModeloTableTableTableManager(_db, _db.checklistModeloTable);
  $$ChecklistPerguntaTableTableTableManager get checklistPerguntaTable =>
      $$ChecklistPerguntaTableTableTableManager(
          _db, _db.checklistPerguntaTable);
  $$ChecklistOpcaoRespostaTableTableTableManager
      get checklistOpcaoRespostaTable =>
          $$ChecklistOpcaoRespostaTableTableTableManager(
              _db, _db.checklistOpcaoRespostaTable);
  $$ChecklistOpcaoRespostaRelacaoTableTableTableManager
      get checklistOpcaoRespostaRelacaoTable =>
          $$ChecklistOpcaoRespostaRelacaoTableTableTableManager(
              _db, _db.checklistOpcaoRespostaRelacaoTable);
  $$ChecklistPerguntaRelacaoTableTableTableManager
      get checklistPerguntaRelacaoTable =>
          $$ChecklistPerguntaRelacaoTableTableTableManager(
              _db, _db.checklistPerguntaRelacaoTable);
  $$ChecklistTipoEquipeRelacaoTableTableTableManager
      get checklistTipoEquipeRelacaoTable =>
          $$ChecklistTipoEquipeRelacaoTableTableTableManager(
              _db, _db.checklistTipoEquipeRelacaoTable);
  $$ChecklistTipoVeiculoRelacaoTableTableTableManager
      get checklistTipoVeiculoRelacaoTable =>
          $$ChecklistTipoVeiculoRelacaoTableTableTableManager(
              _db, _db.checklistTipoVeiculoRelacaoTable);
  $$ChecklistPreenchidoTableTableTableManager get checklistPreenchidoTable =>
      $$ChecklistPreenchidoTableTableTableManager(
          _db, _db.checklistPreenchidoTable);
  $$ChecklistRespostaTableTableTableManager get checklistRespostaTable =>
      $$ChecklistRespostaTableTableTableManager(
          _db, _db.checklistRespostaTable);
}
