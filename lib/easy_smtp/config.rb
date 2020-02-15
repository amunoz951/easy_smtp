module EasySMTP
  module_function

  def config
    @config ||= EasyJSON.config(defaults: defaults)
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
