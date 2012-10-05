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


Animal = Backbone.Model.extend {},
  tableName: 'animals'
  schema:
    id: 'INTEGER'
    name: 'VARCHAR(20)'

BackboneRM.createTable(Animal)

BackboneRM.insert(new Animal({ id: 1, name: 'Lion' }))
BackboneRM.insert(new Animal({ id: 2, name: 'Tiger' }))
BackboneRM.insert(new Animal({ id: 3, name: 'Steve Ballmer' }))
