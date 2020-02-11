module EasySMTP
  module_function

  def config
    @config ||= EasyJson.config(defaults: defaults)
  end

  def defaults
    {
      'smtp' => {
        'server' => nil,
        'port' => 25,
      },
    }
  end
end
