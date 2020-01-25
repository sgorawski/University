class Node
  attr_accessor :prev, :next
  attr_reader :value

  def initialize(value)
    @value = value
  end
end


class SortedCollection
  def initialize
    @head = nil
    @tail = nil
  end

  def put(element)
    # empty list case
    if @head.nil?
      @head = Node.new(element)
      @tail = @head
      return
    end

    # new head case
    if @head.value > element
      new_head = Node.new(element)
      new_head.next = @head
      @head.prev = new_head
      @head = new_head
      return
    end

    # new tail case
    if @tail.value < element
      new_tail = Node.new(element)
      new_tail.prev = @tail
      @tail.next = new_tail
      @tail = new_tail
      return
    end

    # somewhere in the list case
    current = @head
    while current.value < element
      current = current.next
    end
    before_current = current.prev
    new_current = Node.new(element)
    before_current.next = new_current
    current.prev = new_current
    new_current.prev = before_current
    new_current.next = current
  end

  def [](index)
    current = @head
    begin
      (1..index).each {current = current.next}
    rescue NoMethodError
      raise IndexError.new('Index out of bounds')
    end
    current.value
  end

  def length
    len = 0
    current = @head
    until current.nil?
      len += 1
      current = current.next
    end
    len
  end

  def to_a
    res = []
    current = @head
    until current.nil?
      res.push(current.value)
      current = current.next
    end
    res
  end
end
