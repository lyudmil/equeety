class UserBudgetValidator < ActiveModel::Validator  
  def validate commitment
    @commitment = commitment
    unless bad_request?
      if updating?
        add_error if no_budget_to_update?
      else
        add_error if no_budget_to_add?
      end
    end
  end
  
  private
  
  def add_error
    @commitment.errors[:base] << "You can't exceed your budget."
  end
  
  def no_budget_to_update?
    @commitment.user.remaining_budget < budget_increment
  end
  
  def budget_increment
    old_commitment = @commitment.user.commitments.find(@commitment.id)
    budget_increment = @commitment.amount - old_commitment.amount
    budget_increment
  end
  
  def no_budget_to_add?
    @commitment.user.remaining_budget < @commitment.amount
  end
  
  def updating?
    @commitment.user.commitments.include? @commitment
  end
  
  def bad_request?
    not(@commitment.user and @commitment.amount)
  end
end
