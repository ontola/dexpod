# frozen_string_literal: true

class ColorInput < LinkedRails::Form::Field
  def datatype
    NS.ontola[:CssHexColor]
  end

  def pattern
    @pattern ||= /^#([a-f0-9]{3}){1,2}$/i
  end
end
