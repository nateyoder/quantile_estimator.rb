class Cursor
  def initialize(array, start=0)
    @array = array
    @start = start
  end

  def ~
      @array[@start]
  end

  def remove!
    @array.delete_at(@start)
  end

  def next
    Cursor.new(@array, @start + 1)
  end
end
