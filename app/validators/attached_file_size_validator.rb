class AttachedFileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true unless value.attached?

    maximum = options[:maximum]
    attachements = value.attachments
    if attachements.any? { |attachment| attachment.byte_size > maximum }
      record.errors.add(attribute, 'のサイズは1MBまでです')
    end
  end
end
