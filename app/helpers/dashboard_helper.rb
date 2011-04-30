module DashboardHelper
  def remaining_budget_percentage
    (current_user.remaining_budget / current_user.budget) * 100
  end
end
