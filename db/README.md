## Active Record Query Interface


### Single Record
#### find
- throw error if not found
```ruby
item = Item.find(10)
clients = Client.find([1, 10]) # id is 1 or 10
``` 

#### find_by
- return nil if not found
```ruby
item = Item.find_by first_name: 'james'
item = Item.where(first_name: 'james').take # equivalent
```
- throw error if not found 
```ruby
item = Item.find_by! first_name: 'james'
Client.where(first_name: 'does not exist').take! # equivalent
```

#### where
```ruby
item = Item.where(first_name: 'james').take
```

#### take
- throw error if not found
```ruby
item = Item.take # randomly get 1 record
item = Item.take(2) # randomly get 2 record
```

#### first
- return nil if not found
```ruby
item = Item.first # get 1st ordered by id
item = Item.first(3) # get first 3 items ordered by id
```
- throw error if not found
```ruby
item = Item.first!
```

#### last
- return nil if not found
```ruby
item = Item.last # get last ordered by id
item = Item.last(3) # get last 3 items ordered by id
```
- throw error if not found
```ruby
item = Item.last!
```

#### order 
```ruby
items = Item.order(:first_name)
```

### Multiple

#### each
- will load all record to memory
- suitable for small amount of records
```ruby
Item.all.each |item|
    # do sth to each item
end
```

#### find_each
- will yield each record to memory
- suitable for large amoutn of records
```ruby
Item.find_each do |item|
    # do sth to each item
end

# data retrieve batch size
Item.find_each(batch_size: 5000) do |item|
  # do sth to each item
end


# start from 2000nd item ordered by id
Item.find_each(start: 2000) do |item|
  # do sth to each item
end


# ends at 10000nd item ordered by id
Item.find_each(finish: 10000) do |item|
  # do sth to each item
end
```

#### find_in_batches
- will yield a batch records to memory
```ruby
Item.find_in_batches do |items|
  # do sth to an array of items
end

# batch size of each retrieve
Item.find_in_batches(batch_size: 5000) do |items|
  # do sth to an array of items
end

# start pint
Item.find_in_batches(start: 2000) do |items|
  # do sth to an array of items
end

# end point
Item.find_in_batches(finish: 10000) do |items|
  # do sth to an array of items
end
```

### Conditions
#### where
- will retieve all records that meet the condition
```ruby
Item.where("order_count = '2'") # const

Item.where("order_count = ?", parmas[:order]) # variable
Item.where("order_count = ? and locked = ?", parmas[:order], false) # multiple variable

Item.where("order_count = :orderCount", {orderCount: params[:orders] }) # explicit hash way

Item.where(order_count: params[:orders]) # simple way
Item.where('order_count' => params[:orders]) # simple way


Item.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight) # between

Item.where(order_count: [1,2,3]) # in
Item.where(locked: true).or(Item.where(order_count: [1,2,3])) # or

Item.where.not(order_count: 1) # opposite
```
- unsafe operation: directly insert into SQL query
```ruby
# if :orders = 1  or 1 --'
# --' will add comments which ignore conditions after it
# always return true -> return all records
Item.where("order_count = #{params[:orders]}")
```

### Order
#### Order
```ruby
Item.order(:created_at) # default asc
Item.order(:created_at :desc)
Item.order(:created_at :asc)
Item.order(:created_at :desc, :order_count)
Item.order(:created_at :desc).order(:order_count)
```

### Select
- attributes
```ruby
Item.select(:order_count)
Item.select(:order_count, :locked)
Item.select("order_count, locked")
```
- distinct
```ruby
Item.select(:order_count).distinct
```


### Limit
```ruby
Item.limit(5)
Item.limita(5).offset(30)
```

### Group
```ruby
Item.select("sum(price) as total_price").group("date(created_at)")
```
```ruby
Item.group(:status).count
```

### Having
```ruby
Item.select("sum(price) as total_price").group("date(created_at)").having("sum(price) > ?", 10)
```

### Join
- inner join
```ruby
Item.joins(:box)
Item.joins(:box1, :box2) 
Item.joins(:box1: :box2)
Item.joins(:box1: [{comments: :guest}, :tags])
```
