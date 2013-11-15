class Cursor
  def initialize(array, start=0)
    @array = array
    @start = start
  end

  def ~
    if @start >= 0
      @array[@start]
    end
  end

  def remove!
    @array.delete_at(@start)
  end

  def next
    Cursor.new(@array, @start + 1)
  end

  def previous
    Cursor.new(@array, @start - 1)
  end
end
