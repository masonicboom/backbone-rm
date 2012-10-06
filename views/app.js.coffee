root = this
BackboneRM = root.BackboneRM = {}
BackboneRM.db = window.openDatabase("bbrmdb", "1.0", "Test DB", 200000)

BackboneRM.createTable = (model) ->
  BackboneRM.db.transaction (tx) ->
    columns = ("#{name} #{type}" for name, type of model.schema)
    sql = "CREATE TABLE IF NOT EXISTS `#{model.tableName}` (#{columns.join(',')})"
    success = () -> console.log('Success creating table')
    error = (tx, e) -> console.log('Error creating table', e)
    tx.executeSql sql,
      [],
      success,
      error

BackboneRM.insert = (modelInstance) ->
  BackboneRM.db.transaction (tx) ->
    model = modelInstance.constructor
    sql = "INSERT INTO `#{model.tableName}` VALUES (?,?)"
    success = () -> console.log('Success inserting values')
    error = (tx, e) -> console.log('Error inserting values', e)
    rowData = (modelInstance.get(key) for key, type of model.schema)
    tx.executeSql(sql, rowData, success, error)

BackboneRM.where = (model, conditions, callback) ->
  BackboneRM.db.transaction (tx) ->
    sql = "SELECT * FROM `#{model.tableName}` WHERE #{conditions}"
    success = (tx, r) ->
      rows = (new model(r.rows.item(i)) for i in [10..1])
      callback(rows)
    error = (tx, e) -> console.log('Error selecting stuff', e)
    tx.executeSql sql,
      [],
      success,
      error

Backbone.Model.prototype.insert = () -> BackboneRM.insert(this)
_.extend Backbone.Model,
  where: (conditions, callback) ->
    model = this.prototype.constructor
    BackboneRM.where(model, conditions, callback)
  createTable: () ->
    model = this.prototype.constructor
    BackboneRM.createTable(model)

Animal = Backbone.Model.extend {},
  tableName: 'animals'
  schema:
    id: 'INTEGER'
    name: 'VARCHAR(20)'

Animal.createTable()

new Animal({ id: 1, name: 'Lion' }).insert()
new Animal({ id: 2, name: 'Tiger' }).insert()
new Animal({ id: 3, name: 'Steve Ballmer' }).insert()

Animal.where('id = 2', (models) -> console.log(models))
