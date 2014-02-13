# Redis Namespace for doctor and patient
$redis_doctor = Redis::Namespace.new("rxhealth_doctor", :redis => Redis.new)
$redis_patient = Redis::Namespace.new("rxhealth_patient", :redis => Redis.new)