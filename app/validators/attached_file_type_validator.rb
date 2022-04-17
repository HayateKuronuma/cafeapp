class AttachedFileTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true unless value.attached?

    pattern = options[:pattern]
    attachments = value.attachments
    if attachments.any? { |attachment| !attachment.content_type.match?(pattern) }
      record.errors.add(attribute, 'が対応している画像データではありません')
    end
  end
end
