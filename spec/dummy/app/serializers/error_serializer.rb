class ErrorSerializer < ActiveModel::Serializer
  type :error
  attributes :code, :message

  def code
    0
  end

  def message
    object.to_s
  end
end
