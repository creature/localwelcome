module DatesHelper

  # Format a datestamp as "December 26, 2015 at 8:45 PM"
  def long_friendly_datetime(date)
    date.strftime("%B %e, %Y at %l:%M%p")
  end

  # Format a datestamp as "December 26, 2015"
  def long_friendly_date(date)
    date.strftime("%B %e, %Y")
  end

  # Format a datestamp as "Dec 26 - 20:45"
  def short_friendly_datetime(date)
    date.strftime("%b %e - %k:%M")
  end

  # Format a datestamp as "Dec 26"
  def short_friendly_date(date)
    date.strftime("%b %e")
  end

  def friendly_time(date)
    date.strftime("%l:%M%p")
  end
end
