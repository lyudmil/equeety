module DashboardHelper
  def remaining_budget_percentage
    return 0 unless current_user.budget
    (current_user.remaining_budget / current_user.budget) * 100
  end
  
  def progress_bar_message
    return "You haven't set a budget yet. You can do so by changing your profile settings." unless current_user.budget
    remaining_budget_percentage.to_s + "% of " + number_to_currency(current_user.budget, :units => "$") + " remaining." 
  end
end
