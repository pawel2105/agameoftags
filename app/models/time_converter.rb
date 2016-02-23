class TimeConverter
  def initialize timestamp
    integer_time = timestamp.to_i
    @timestamp = Time.at(integer_time)
  end

  def get_slot_name
    prefix = weekday_name[@timestamp.wday]
    suffix = @timestamp.hour
    return "#{prefix}#{suffix}"
  end

  def weekday_name
    { 1 => "mon_", 2 => "tue_", 3 => "wed_", 4 => "thu_", 5 => "fri_", 6 => "sat_", 7 => "sun_" }
  end
end