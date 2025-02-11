module StashEngine
  class Author < ActiveRecord::Base
    belongs_to :resource, class_name: 'StashEngine::Resource'

    before_save :strip_whitespace

    scope :names_filled, -> { where("TRIM(IFNULL(author_first_name,'')) <> ''") }

    amoeba do
      enable
    end

    def author_full_name
      [author_last_name, author_first_name].reject(&:blank?).join(', ')
    end

    def author_standard_name
      "#{author_first_name} #{author_last_name}".strip
    end

    def author_html_email_string
      author_email.blank? ? nil : "<a href=\"mailto:#{CGI::escapeHTML(author_email.strip)}\">" +
          "#{CGI::escapeHTML(author_standard_name.strip) }</a>"
    end

    private

    def strip_whitespace
      self.author_first_name = author_first_name.strip if author_first_name
      self.author_last_name = author_last_name.strip if author_last_name
      self.author_email = author_email.strip if author_email
      self.author_orcid = author_orcid.strip if author_orcid
    end
  end
end
