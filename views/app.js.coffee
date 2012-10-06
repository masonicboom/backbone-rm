Animal = Backbone.Model.extend {},
  dbName: 'demo'
  tableName: 'animals'
  schema:
    id: 'INTEGER'
    name: 'VARCHAR(20)'

Animal.createTable()

new Animal({ id: 1, name: 'Lion' }).insert()
new Animal({ id: 2, name: 'Tiger' }).insert()
new Animal({ id: 3, name: 'Steve Ballmer' }).insert()

Animal.where('id = 2', (models) -> console.log(models))
