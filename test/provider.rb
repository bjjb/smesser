Smesser.providers['dummy'] = Class.new(Smesser::Provider) do
  def login(*args); true; end
  def send(*args); true; end
end
