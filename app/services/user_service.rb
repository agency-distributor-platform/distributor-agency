class UserService

  attr_reader :user_record

  def initialize(user_record)
    @user_record = user_record
  end

  def is_distributor?
    user_record.employer_type == "Distributor"
  end

  def is_agency?
    user_record.employer_type == "Agency"
  end

  def is_salesperson?
    user_record.employer_type == "Salesperson"
  end

end
