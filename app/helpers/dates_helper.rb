module DatesHelper
  def long_friendly_date(date)
    date.strftime("%B %e, %Y at %l:%M%p")
  end

  def short_friendly_date(date)
    date.strftime("%b %e - %k:%M")
  end
end
