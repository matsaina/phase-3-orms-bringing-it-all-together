class Dog
    attr_accessor :name, :breed, :id
  
  def initialize(attributes)
    #id: nil, name:, breed:
    attributes.each {|key, value| self.send(("#{key}="), value)}
    self.id ||= nil
  end

  
    def self.create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
          id INTEGER PRIMARY KEY,
          name TEXT,
          breed TEXT
        )
      SQL
  
      DB[:conn].execute(sql)
    end
  
    def self.drop_table
      sql = <<-SQL
        DROP TABLE dogs
      SQL
  
      DB[:conn].execute(sql)
    end
  
    def save
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
  
      DB[:conn].execute(sql, self.name, self.breed)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  
    def self.create(name:, breed:)
      song = new(name: name, breed: breed)
      song.save
    end
  
    def self.new_from_db(row)
      new(id: row[0], name: row[1], breed: row[2])
    end
  
    def self.all
      sql = <<-SQL
        SELECT *
        FROM dogs
      SQL
  
      DB[:conn].execute(sql).map { |row| new_from_db(row) }
    end
  
    def self.find_by_name(name)
      sql = <<-SQL
        SELECT *
        FROM dogs
        WHERE name = ?
        LIMIT 1
      SQL
  
      DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
    end

    def self.find(id)
        sql = <<-SQL
          SELECT *
          FROM dogs
          WHERE id = ?
          LIMIT 1
        SQL
    
        DB[:conn].execute(sql, id).map { |row| new_from_db(row) }.first
      end
  end
  