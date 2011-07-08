module ApplicationHelper
  
  def navigation_link text, path
    html_options = {:class => "selected"} if controller_name == text.downcase
    link_to content_tag(:span, text, html_options), path
  end
  
  def dollars amount
    number_to_currency(amount, :unit => "$", :precision => 0)
  end
  
  def percentage number
    number_to_percentage(number, :precision => 0)
  end
  
  def date date
    date.strftime("%B %d, %Y")
  end
  
end
