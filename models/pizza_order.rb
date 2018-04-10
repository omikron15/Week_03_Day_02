require"pg"

class PizzaOrder

    attr_reader :id
    attr_accessor :first_name, :last_name, :topping, :quantity

  def initialize(options)
      @id = options["id"].to_i
      @first_name = options["first_name"]
      @last_name = options["last_name"]
      @topping = options["topping"]
      @quantity = options["quantity"].to_i

  end  #End of initialize method

  def save()
    #Create db connection
    db = PG.connect({dbname: "pizza_shop", host: "localhost"})

    #Create sql statment with placeholders for variables
    sql = "INSERT INTO pizza_orders
    (first_name, last_name, topping, quantity)
    VALUES
    ($1, $2, $3, $4) RETURNING id;"

    #Create array to store values to be added to SQL statment
    values = [@first_name, @last_name, @topping, @quantity]

    #Creates prepared DB stament called "Save" ready to be executed
    db.prepare("Save",sql)

    #Executes db statement called "Save" which is combined with values array to get string
    result = db.exec_prepared("Save", values)

    #Close DB connection
    db.close()

    @id = result[0]["id"].to_i
  end #End of save method

  def delete()

    db = PG.connect({dbname: "pizza_shop", host: "localhost"})
    sql = "DELETE FROM pizza_orders WHERE id = $1"
    values = [@id]
    db.prepare("Delete", sql)
    db.exec_prepared("Delete", values)
    db.close

  end

  def update()

    db = PG.connect({dbname: "pizza_shop", host: "localhost"})

    sql = "UPDATE pizza_orders SET
    (first_name, last_name, topping, quantity) =
    ($1, $2, $3, $4) WHERE id = $5"

    values = [@first_name, @last_name, @topping, @quantity, @id]

    db.prepare("Update", sql)
    db.exec_prepared("Update", values)
    db.close()

  end

  def self.all()

    db = PG.connect({dbname: "pizza_shop", host: "localhost"})

    sql = "SELECT * FROM pizza_orders"

    db.prepare("All", sql)

    orders = db.exec_prepared("All")

    db.close()

    return orders.map {|order| PizzaOrder.new (order)}

  end


  def self.delete_all()
    db = PG.connect({dbname: "pizza_shop", host: "localhost"})
    sql = "DELETE FROM pizza_orders"
    db.prepare("Delete_all", sql)
    db.exec_prepared("Delete_all")
    db.close
  end

end #End of class
