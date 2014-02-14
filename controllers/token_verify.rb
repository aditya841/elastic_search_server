class TokenVerify

  include EM::Deferrable

  def verify(token, identifier)
    if (identifier == "doctor")
      check = $redis_doctor.exists(token) 
    elsif (identifier == "patient")
      check = $redis_patient.exists(token)
    end
    if(check)
      succeed(true)
    else
      fail(true)
    end
  end
end