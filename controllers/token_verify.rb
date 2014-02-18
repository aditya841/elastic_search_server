class TokenVerify

  include EM::Deferrable

  def verify(token, index)
    if (index == "doctors")
      check = $redis_doctor.exists(token) 
    elsif (index == "patients")
      check = $redis_patient.exists(token)
    end
    if(check)
      succeed(true)
    else
      fail(true)
    end
  end
end