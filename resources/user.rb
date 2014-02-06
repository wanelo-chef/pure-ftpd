actions :create
default_action :create

attribute :username, kind_of: String, required: true
attribute :password, kind_of: String, required: true

attribute :max_concurrency, kind_of: Integer, default: 5
