# frozen_string_literal: true

module TestMethods
  def request_headers(accept: :json)
    {
      accept: Mime::Type.lookup_by_extension(accept).to_s
    }
  end
end
