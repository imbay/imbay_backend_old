$time = Time.now.getutc.strftime("%s")
$redis = {
    :session => {
        :host => "127.0.0.1",
        :port => 6379,
        :password => "593WXlrMTlYtbjO8"
    }
}

if (Rails.env == "test" || Rails.env == "development")
    $redis[:session][:password] = "12345"
end
