root = this
BackboneRM = root.BackboneRM = {}
BackboneRM.db = window.openDatabase("bbrmdb", "1.0", "Test DB", 200000)

BackboneRM.createTable = (db, model) ->
  db.transaction (tx) ->
    columns = ("#{name} #{type}" for name, type of model.schema)
    sql = "CREATE TABLE IF NOT EXISTS `#{model.tableName}` (#{columns.join(',')})"
    success = () -> console.log('Success creating table')
    error = (tx, e) -> console.log('Error creating table', e)
    tx.executeSql sql,
      [],
      success,
      error

BackboneRM.insert = (db, modelInstance) ->
  db.transaction (tx) ->
    model = modelInstance.constructor
    sql = "INSERT INTO `#{model.tableName}` VALUES (?,?)"
    success = () -> console.log('Success inserting values')
    error = (tx, e) -> console.log('Error inserting values', e)
    rowData = (modelInstance.get(key) for key, type of model.schema)
    tx.executeSql(sql, rowData, success, error)

BackboneRM.where = (db, model, conditions, callback) ->
  db.transaction (tx) ->
    sql = "SELECT * FROM `#{model.tableName}` WHERE #{conditions}"
    success = (tx, r) ->
      rows = (new model(r.rows.item(i)) for i in [10..1])
      callback(rows)
    error = (tx, e) -> console.log('Error selecting stuff', e)
    tx.executeSql sql,
      [],
      success,
      error

_.extend Backbone.Model,
  dbHandle: () ->
    BackboneRM.db
  where: (conditions, callback) ->
    db = this.dbHandle()
    model = this.prototype.constructor
    BackboneRM.where(db, model, conditions, callback)
  createTable: () ->
    db = this.dbHandle()
    model = this.prototype.constructor
    BackboneRM.createTable(db, model)

Backbone.Model.prototype.insert = () ->
  db = this.constructor.dbHandle()
  BackboneRM.insert(db, this)

