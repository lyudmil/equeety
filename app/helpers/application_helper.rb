module ApplicationHelper
  
  def navigation_link text, path
    html_options = {:class => "selected"} if controller_name == text.downcase
    link_to content_tag(:span, text, html_options), path
  end
  
  def dollars amount
    number_to_currency(amount, :unit => "$", :precision => 0)
  end
  
end
