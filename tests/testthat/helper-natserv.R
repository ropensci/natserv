library("vcr")
vcr_configure(
    dir = "../fixtures",
    filter_sensitive_data = list("<<natserv_api_token>>" = Sys.getenv('NATURE_SERVE_KEY'))
)
check_cassette_names()
