class AttachedFileNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true unless value.attached?

    file_number = value.size

    if (limit = options[:maximum]).present? && file_number > limit
      record.errors.add(attribute, 'は4枚までです')
    end
  end
end
